import os
import io
import discord
import asyncio
import libcore_hng.utils.app_logger as app_logger
from discord import app_commands
from discord.ext import commands
from services.persona_service import PersonaService
from services.comfyui_service import ComfyUIService
from services.image_service import ImageService
from services.log_service import ChatLogDto, LogService
from pycorex.enums.rating_level import RatingLevel
from pycorex.gemini_client import GeminiClient

class MessageCog(commands.Cog):
    """
    Discord メッセージをトリガーとしたAI対話制御を担当するCogクラス

    チャネルごとのセッション管理、Personaに基づいたプロンプト構築、
    Gemini APIとの通信を仲介する
    """
    
    def __init__(
            self, 
            bot: commands.Bot, 
            gemini_client: GeminiClient, 
            comfyui_service: ComfyUIService,
            persona_service: PersonaService,
            log_service: LogService,
            image_service: ImageService):
        """
        コンストラクタ

        Parameters
        ----------
        bot : commands.Bot
            Dicord Botのインスタンス
        gemini_client : GeminiClient
            Gemini API通信用クライアント
        comfyui_service : ComfyUIService
            ComfyUI API通信用クライアント
        persona_service : PersonaService
            システムプロンプト構築用サービス
        log_service : LogService
            ログサービス
        """
        self.bot = bot
        self.client = gemini_client
        self.persona_service = persona_service
        self.log_service = log_service
        self.image_service = image_service
        self.sessions: dict[int, any] = {}
        self.comfyui_service = comfyui_service

    def _setup_comfyui_service(self, persona_conf_path, mod_config_path):
        """
        ComfyUIServiceをセットアップする

        Parameters
        ----------
        persona_conf_path : Optional[str]
            PersonaJSONファイルパス
        mod_config_path : Optional[str]
            ComfyUI Workflow変更設定ファイルパス
        
        """
        return ComfyUIService(
            gemini_client=self.client,
            persona_conf_path=persona_conf_path,
            mod_config_path=mod_config_path
        )

    @commands.Cog.listener()
    async def on_message(self, message: discord.Message):
        """
        メッセージ受信時に実行されるイベントリスナー
        新規チャンネルの場合はセッションを初期化し、継続中の場合は履歴を保持したまま
        AI 応答を生成し、Discordに送信する

        message : discord.Message
            受信したメッセージオブジェクト
        
        """
        # Bot自身のメッセージは無視する
        if message.author.bot or not message.content:
            return
        
        # チャンネルID取得
        channel_id = message.channel.id
        # チャンネル固有のセッションが存在しない場合は新規構築
        if channel_id not in self.sessions:
            system_inst = self.persona_service.build_system_instruction()
            self.sessions[channel_id] = self.client.start_chat_session(
                system_instruction=system_inst,
                temperature=os.getenv("TEMPERATURE", 0.9)
            )
        
        try:
            # Discordへ送信
            session = self.sessions[channel_id]
            response = await self.client.send_chat_message(session, message.content)
            if response and response.text:

                # メッセージ送信
                await message.reply(response.text)

                # ログデータDto作成
                log_data = ChatLogDto(
                    user_name=str(message.author),
                    message=message.content,
                    response=response.text
                )

                # ログデータ書き込み
                self.log_service.save_chat_log(log_data)

            else:
                app_logger.error(f"Response empty Error: {e}")
                err_msg = self.persona_service.get_static_message("system_message", "empty_response")
                await message.reply(err_msg)

        except Exception as e:
            app_logger.error(f"Chat Error: {e}")
            err_msg = self.persona_service.get_static_message("system_message", "chat_error")
            await message.reply(err_msg.format(error=e))

    @app_commands.command(name="dressup", description="Botをドレスアップします")
    async def dress_up(self, interaction: discord.Interaction):
        """
        スラッシュコマンド dressup
        """

        # DressUpMenuViewインスタンス生成
        view = self.DressUpMenuView(self.comfyui_service, self.persona_service, self.image_service)
        
        # RatingLevel選択前メッセージ取得
        message_content = self.persona_service.get_static_message("start_messages", "common")

        # RatingLevel選択前メッセージ送信
        await interaction.response.send_message(
            content=message_content,
            view=view,
            ephemeral=False
        )

        # 変数messageに送信したメッセージを格納してViewを渡す(Timeout時に書き換えするため)
        view.message = await interaction.original_response()
        
    class DressUpMenuView(discord.ui.View):

        def __init__(self, comfyui_service: ComfyUIService, persona_service: PersonaService, image_service: ImageService):
            super().__init__(timeout=int(os.getenv("VIEW_TIMEOUT", 60)))
            self.comfyui_service = comfyui_service
            self.persona_service = persona_service
            self.image_service = image_service
            self.message: discord.Message = None
            raw_options = self.persona_service.get_raw_data("system_messages", "rating_options")
            
            # デコレータで定義したselectメニューのoptionsを上書きする
            self.select_callback.options = [
                discord.SelectOption(**opt) for opt in raw_options
            ]

            # プレースホルダーを取得する
            self.select_callback.placeholder = self.persona_service.get_static_message("system_messages", "rating_placeholder")

        @discord.ui.select()
        async def select_callback(self, interaction: discord.Interaction, select: discord.ui.Select):
            """
            RatingLevel選択後の処理
            """
            # タイマーストップ
            self.stop()
            
            # 選択されたRatingLevel取得
            rating_level_value = select.values[0]
            rating_level = RatingLevel(int(rating_level_value))

            # dressup開始メッセージ取得
            message_content = self.persona_service.get_static_message("start_messages", "generation_image", rating_level_value)
            # dressup開始メッセージ送信
            await interaction.response.edit_message(
                content=f"**[SYSTEM: DRESSUP START]**\n{message_content}",
                view=None
            )
            # dressup処理を非同期で実行
            asyncio.create_task(self._execute_dress_up(interaction, rating_level))

        async def _execute_dress_up(self, interaction: discord.Interaction, rating_level: RatingLevel):
            try:

                # dressup終了メッセージ取得
                message_content = self.persona_service.get_static_message("finish_messages", str(rating_level.value))
                # RatingLevelに応じて画像を生成する
                images = await self.comfyui_service.generate_images(rating_level)
                # 生成画像をDBに保存してDiscordに送信する
                if len(images) > 0:                    
                    try:
                        self.image_service.save_generated_images(images, generated_by_user=interaction.user.name)
                    except Exception as db_error:
                        app_logger.error(f"Error saving generated images to DB: {db_error}")

                    d_files = []
                    for image_record in images:
                        image_binary = io.BytesIO(image_record["image_bytes"])
                        d_file = discord.File(fp=image_binary, filename=image_record["filename"])
                        d_files.append(d_file)

                    await interaction.channel.send(
                        content=f"**[SYSTEM: DRESSUP COMPLETE]: Level {rating_level.value}**\n{message_content}",
                        files=d_files
                    )
                else:
                    fail_msg = self.persona_service.get_static_message("system_messages", "generation_failed")
                    await interaction.channel.send(fail_msg)

            except Exception as e:
                app_logger.error(f"Error during dress_up: {e}")
                err_msg = self.persona_service.get_static_message("system_messages", "chat_error")
                await interaction.channel.send(err_msg.format(error=e))

        async def on_timeout(self):
            """
            ユーザーが何もせずタイムアウトした時の処理
            """

            # タイムアウトメッセージを取得
            timeout_msg = self.persona_service.get_static_message("system_messages", "view_timeout")

            if self.message:
                try:
                    # ボタンやセレクトメニューを無効化し、メッセージをタイムアウトメッセージに更新
                    await self.message.edit(content=f"**[SYSTEM: SESSION TIMEOUT]**\n{timeout_msg}", view=None)
                except Exception as e:
                    app_logger.error(f"Timeout Edit Error: {e}")