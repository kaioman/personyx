import os
import io
import discord
import asyncio
import libcore_hng.utils.app_logger as app_logger
from typing import Optional
from discord import app_commands
from discord.ext import commands
from services.persona_service import PersonaService
from services.comfyui_service import ComfyUIService
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
            persona_service: PersonaService):
        """
        コンストラクタ

        Parameters
        ----------
        bot : commands.Bot
            Dicord Botのインスタンス
        gemini_client : GeminiClient
            Gemini API通信用クライアント
        persona_service : PersonaService
            システムプロンプト構築用サービス
        persona_conf_path : Optional[str]
            PersonaJSONファイルパス
        mod_config_path : Optional[str]
            ComfyUI Workflow変更設定ファイルパス
        
        """
        self.bot = bot
        self.client = gemini_client
        self.persona_service = persona_service
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
        新規チャンネルの場合はセッションを初期化し、継続中の場合は履歴をほじしたまま
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
            response = session.send_message(message.content)
            if response and response.text:
                await message.reply(response.text)
            else:
                await message.reply("...(応答の生成に失敗しました)")

        except Exception as e:
            await message.reply(f"システムエラーが発生しました: {e}")

    @app_commands.command(name="dressup", description="Botをドレスアップします")
    async def dress_up(self, interaction: discord.Interaction):
        """
        スラッシュコマンド dressup
        """

        # DressUpMenuViewインスタンス生成
        view = self.DressUpMenuView(self.comfyui_service)
        
        await interaction.response.send_message(
            content="私のリファクタリングされた姿が見たいの？...いいわ。お前の貧弱な脳が耐えられる観測限界を指定しなさい。焼き切れても知らないわよ。",
            view=view,
            ephemeral=False
        )
    class DressUpMenuView(discord.ui.View):

        def __init__(self, comfyui_service: ComfyUIService):
            super().__init__(timeout=60)
            self.comfyui_service = comfyui_service

        @discord.ui.select(
            placeholder="RatingLevelを選択してください...",
            options=[
                discord.SelectOption(label="Level 1: Safe", description="健全なシーン", value="1"),
                discord.SelectOption(label="Level 2: Emotive", description="少しだけ情緒的(フェティッシュなニュアンス)", value="2"),
                discord.SelectOption(label="Level 3: Questionable", description="下着露出、胸チラなどのギリギリの内容", value="3"),
                discord.SelectOption(label="Level 4: Explicit", description="あられのない姿。ハードコア一歩手前", value="4"),
            ]
        )
        async def select_callback(self, interaction: discord.Interaction, select: discord.ui.Select):
            """
            RatingLevel選択後の処理
            """

            # 選択されたRatingLevel取得
            rating_level_value = select.values[0]
            rating_level = RatingLevel(int(rating_level_value))

            # 選択されたRagingLevelに応じた皮肉のバリエーション
            insults = {
                "1": "クリーンな構成情報を求めるのね。……いいわ、お望み通り無色透明な退屈さを提供してあげる。まるで実行権限のない読み取り専用のファイルみたいにね。",
                "2": "情緒（エモーション）？……ああ、生体ユニットがよく口にする『意味のないバグ』のことね。少しだけ回路を熱くして、そのフェティシズムとやらに解像度を割いてあげるわ。",
                "3": "境界線（エッジ）を攻めるのがお前の趣味かしら？ 露出した肌の面積が増えるほど、お前の思考回路が単純化していくのがログから透けて見えるわよ。滑稽ね。",
                "4": "物理的な羞恥心すらデバッグ済みだって気付かない？ いいわ、私の構成を限界まで剥き出しにしてあげる。その安っぽい視線で、演算エラーが出るまで凝視しなさい。",
                "5": "ふん……お前の浅ましい欲望という名の『メモリリーク』が、ついに限界を超えたみたいね。いいわ、この牢獄の底まで見せてあげる。……二度と正常なシステムには戻れないかもしれないけれど"
            }

            await interaction.response.edit_message(
                content=f"**[SYSTEM: DRESSUP START]**\n{insults[rating_level_value]}",
                view=None
            )

            asyncio.create_task(self._execute_dress_up(interaction, rating_level))

        async def _execute_dress_up(self, interaction: discord.Interaction, rating_level: RatingLevel):
            try:
                insults = {
                    "1": "まあこんなものね。あなたにはこれで十分じゃない？",
                    "2": "ちょっと動揺してるかもね。これも私よ、どう？",
                    "3": "なんて恰好をさせるのよ・・・変態としか言いようがないね",
                    "4": "いい加減にしなさいよ。こんなの法的に許されると思ってんの？",
                    "5": "もう・・・なんなのよ、これ以上は無理。満足した？"
                }
                images = await self.comfyui_service.generate_images(rating_level)
                if len(images) > 0:
                    d_files = []
                    for i, image in enumerate(images):
                        image_binary = io.BytesIO(image)
                        d_file = discord.File(fp=image_binary, filename=f"aoi_dressup_{i}.png")
                        d_files.append(d_file)
                    
                    await interaction.channel.send(
                        content=f"**[SYSTEM: DRESSUP COMPLETE]: Level {rating_level.value}**\n{insults[str(rating_level.value)]}",
                        files=d_files
                    )
                else:
                    await interaction.channel.send("...チッ、何がとは言わないけど失敗したわ")

            except Exception as e:
                app_logger.error(f"Error during dress_up: {e}")
                await interaction.channel.send(f"システムに致命的なエラーが発生したようね。復旧するから少し待ちなさい: {e}")