import os
import asyncio
import discord
import libcore_hng.utils.app_logger as app_logger
import pycorex.configs.app_init as app

from discord.ext import commands
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
#from models import Log
from pathlib import Path
from dotenv import load_dotenv
from cogs.general_cog import GeneralCog
from cogs.message_cog import MessageCog
from services.persona_service import PersonaService
from services.system_service import SystemService
from services.comfyui_service import ComfyUIService
from pycorex.gemini_client import GeminiClient

class MyBot(commands.Bot):
    """
    Personyxシステムの核となるDiscord Botクラス
    アプリ初期化、GeminiClient初期化、各機能(Cog)の統合を管理する
    """

    def __init__(self, intents):
        """
        コンストラクタ

        Parameters
        ----------
        intents : discord.Intents
            Discord Gatewayから受信するイベント権限
        
        """
        super().__init__(command_prefix="!", intents=intents)
        self.gemini_client = None
        self.comfyui_service = None
        self.persona_service = None

    def _setup_comfyui_service(self, gemini_client, persona_conf_path, mod_config_path):
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
            gemini_client=gemini_client,
            persona_conf_path=persona_conf_path,
            mod_config_path=mod_config_path
        )
    
    async def setup_hook(self):
        """
        Botの起動時に非同期で実行される初期設定プロセス
        アプリ初期化、GeminiClient初期化、各機能(Cog)の登録を実行する
        """

        # アプリ基盤を初期化する
        self._initialize_app_infrastructure()

        # AI関連サービスの構築
        self.persona_service, self.gemini_client = self._build_ai_service()

        # ComfyUIServiceクラスインスタンス生成
        self.comfyui_service = self._setup_comfyui_service(
            gemini_client=self.gemini_client,
            persona_conf_path="configs/comfyui/prompt/persona/Aoi.json",
            mod_config_path="configs/comfyui/workflow/modifications/aoi_workflow_config.json"
        )

        # Cogの登録
        await self._register_cogs()

        # スラッシュコマンドを同期する
        try:
            synced = await self.tree.sync()
            app_logger.info(f"Synced {len(synced)} command(s) globally.")
        except Exception as e:
            app_logger.error(f"Failed to sync commands: {e}")

    def _initialize_app_infrastructure(self):
        """
        GCP設定、ロガー、環境変数などのアプリ基盤を初期化する
        """
        system_service = SystemService(self)
        system_service.setup_app()

    def _build_ai_service(self) -> tuple[PersonaService, GeminiClient]:
        """
        Persona管理、GeminiClientのインスタンスを生成する

        Returns
        -------
        tuple[PersonaService, GeminiClient]
            初期化済の各サービスインスタンス
        """

        # 設定ファイルのパスとAPIキーを取得
        instruction_path = os.environ.get("INSTRUCTION_PATH", "configs/instruction.json")
        persona_path = os.environ.get("PERSONA_PATH", "personas/Aoi.json")

        # PersonaServiceインスタンス初期化
        persona_service = PersonaService(
            instruction_path=instruction_path,
            persona_path=persona_path
        )

        # GeminiClientインスタンス初期化
        gemini_client = GeminiClient(api_key=app.core.config.gemini.api_key)

        # インスタンスを返す
        return persona_service, gemini_client

    async def _register_cogs(self):
        """
        各機能(Cog)をBotに登録する
        """

        # 汎用システム管理Cog
        await self.add_cog(GeneralCog(self))

        # メッセージ応答・AI応答Cog
        await self.add_cog(
            MessageCog(
                self, 
                gemini_client=self.gemini_client, 
                comfyui_service=self.comfyui_service,
                persona_service=self.persona_service
            )
        )

if __name__ == "__main__":

    # .envの読み込み
    currnent_file = Path(__file__).resolve()
    target_dir = currnent_file.parent.parent / 'personyx-service'
    env_path = target_dir / '.env'
    load_dotenv(dotenv_path=env_path)

    # Discord Tokenの取得
    token = os.environ.get("DISCORD_TOKEN")
    if not token:
        raise SystemExit("DISCORD_TOKEN is not set in environment variables.")

    # Bot起動
    async def start():
        """
        Botの非同期エントリポイント
        """
        intents = discord.Intents.default()
        intents.message_content = True

        async with MyBot(intents=intents) as bot:
            await bot.start(token)

    try:
        asyncio.run(start())
    except KeyboardInterrupt:
        pass