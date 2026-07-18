import os
import io
import discord
import asyncio
import libcore_hng.utils.app_logger as app_logger
from discord import app_commands
from discord.ext import commands
from services.persona_service import PersonaService
from services.comfyui_service import ComfyUIService
from services.image_service import ImageService, UserNotFoundError
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
        
        # ユーザーID取得
        user_id = self.image_service.resolve_discord_user_id(message.author)

        # セッションKey取得
        session_key = (message.channel.id, user_id or "__default__")

        ## チャンネルID取得
        #channel_id = message.channel.id
        # チャンネル固有のセッションが存在しない場合は新規構築
        if session_key not in self.sessions:
            system_inst = self.persona_service.build_system_instruction(user_id=user_id)
            self.sessions[session_key] = self.client.start_chat_session(
                system_instruction=system_inst,
                temperature=os.getenv("TEMPERATURE", 0.9)
            )
        try:
            # Discordへ送信
            session = self.sessions[session_key]
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
                app_logger.error(f"Response empty")
                err_msg = self.persona_service.get_static_message("system_message", "empty_response", user_id=user_id)
                await message.reply(err_msg)

        except Exception as e:
            app_logger.error(f"Chat Error: {e}")
            err_msg = self.persona_service.get_formatted_error_message("system_message", "chat_error", error=e, user_id=user_id)
            await message.reply(err_msg)

    @app_commands.command(name="dressup", description="Botをドレスアップします")
    async def dress_up(self, interaction: discord.Interaction):
        """
        スラッシュコマンド dressup
        """

        # ユーザーID取得
        user_id = self.image_service.resolve_discord_user_id(interaction.user)

        # DressUpMenuViewインスタンス生成
        view = self.DressUpMenuView(
            self.comfyui_service, 
            self.persona_service, 
            self.image_service, 
            user_id=user_id
        )
        
        # RatingLevel選択前メッセージ取得
        message_content = self.persona_service.get_static_message("start_messages", "common", user_id=user_id)

        # RatingLevel選択前メッセージ送信
        await interaction.response.send_message(
            content=message_content,
            view=view,
            ephemeral=False
        )

        # 変数messageに送信したメッセージを格納してViewを渡す(Timeout時に書き換えするため)
        view.message = await interaction.original_response()
    
    async def _workflow_autocomplete(self, _: discord.Integration, current: str) -> list[app_commands.Choice[str]]:
        """
        ワークフローファイル名のオートコンプリート

        Parameters
        ----------
        interaction : discord.Interaction
            インタラクションオブジェクト
        current : str
            現在入力されているテキスト

        Returns
        -------
        list[app_commands.Choice[str]]
            マッチするワークフローファイルのリスト
        """

        # 有効なワークフローファイルのリスト取得
        workflows = self.comfyui_service.get_available_workflows()

        # 現在入力されているテキストでフィルタリング
        # 25はDiscord APIの上限
        filtered_workflows = [
            w for w in workflows
            if w.lower().startswith(current.lower())
        ][:25]

        return [
            app_commands.Choice(name=workflow, value=workflow)
            for workflow in filtered_workflows
        ]
    
    @app_commands.command(name="dressup_debug", description="[DEBUG] ワークフロー指定してドレスアップ")
    @app_commands.autocomplete(workflow_file=_workflow_autocomplete)
    async def dress_up_debug(self, interaction: discord.Integration, workflow_file: str):
        """
        スラッシュコマンド dressup_debug(デバッグ用)
        ワークフローファイルを指定して画像生成を実行 

        Parameters
        ----------
        interaction : discord.Interaction
            インタラクションオブジェクト
        workflow_file : str
            ワークフローファイル名
        """

        # ユーザーID取得
        user_id = self.image_service.resolve_discord_user_id(interaction.user)

        # DressUpMenuViewインスタンス生成
        view = self.DressUpMenuView(
            self.comfyui_service, 
            self.persona_service, 
            self.image_service, 
            workflow_file=workflow_file, 
            user_id=user_id
        )
        
        # RatingLevel選択前メッセージ取得
        message_content = self.persona_service.get_static_message("start_messages", "common", user_id=user_id)

        # RatingLevel選択前メッセージ送信
        await interaction.response.send_message(
            content=message_content,
            view=view,
            ephemeral=False
        )

        # 変数messageに送信したメッセージを格納してViewを渡す(Timeout時に書き換えするため)
        view.message = await interaction.original_response()

    class DressUpMenuView(discord.ui.View):

        def __init__(self, 
            comfyui_service: ComfyUIService, 
            persona_service: PersonaService, 
            image_service: ImageService,
            workflow_file: str = "",
            user_id: str | None = None):
            super().__init__(timeout=int(os.getenv("VIEW_TIMEOUT", 60)))
            self.comfyui_service = comfyui_service
            self.persona_service = persona_service
            self.image_service = image_service
            self.workflow_file = workflow_file
            self.message: discord.Message = None
            self.user_id = user_id
            raw_options = self.persona_service.get_raw_data("system_messages", "rating_options", user_id=self.user_id)
            
            # デコレータで定義したselectメニューのoptionsを上書きする
            self.select_callback.options = [
                discord.SelectOption(**opt) for opt in raw_options
            ]

            # プレースホルダーを取得する
            self.select_callback.placeholder = self.persona_service.get_static_message("system_messages", "rating_placeholder", user_id=user_id)

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
            message_content = self.persona_service.get_static_message("start_messages", "generation_image", rating_level_value, user_id=self.user_id)
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
                # Discordユーザー -> アプリ内 user_idを解決して画像生成/保存処理に渡す
                images = await self.comfyui_service.generate_images(rating_level, self.workflow_file, self.user_id)

                # 生成画像をDBに保存してDiscordに送信する
                if len(images) > 0:                    
                    try:
                        self.image_service.save_generated_images(images, user_name=interaction.user.name, user_id=self.user_id)
                    except UserNotFoundError as e:
                        await interaction.channel.send(
                            f"⚠️ **[ERROR]** {str(e)}"
                        )
                        return
                    except Exception as db_error:
                        app_logger.error(f"Error saving generated images to DB: {db_error}")
                        await interaction.channel.send(
                            f"❌ **[ERROR]** DB保存エラー: {db_error}"
                        )
                        return

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
                    fail_msg = self.persona_service.get_static_message("system_messages", "generation_failed", user_id=self.user_id)
                    await interaction.channel.send(fail_msg)

            except Exception as e:
                app_logger.error(f"Error during dress_up: {e}")
                err_msg = self.persona_service.get_formatted_error_message("system_messages", "chat_error", error=e, user_id=self.user_id)
                await interaction.channel.send(err_msg)

        async def on_timeout(self):
            """
            ユーザーが何もせずタイムアウトした時の処理
            """

            # タイムアウトメッセージを取得
            timeout_msg = self.persona_service.get_static_message("system_messages", "view_timeout", user_id=self.user_id)

            if self.message:
                try:
                    # ボタンやセレクトメニューを無効化し、メッセージをタイムアウトメッセージに更新
                    await self.message.edit(content=f"**[SYSTEM: SESSION TIMEOUT]**\n{timeout_msg}", view=None)
                except Exception as e:
                    app_logger.error(f"Timeout Edit Error: {e}")
