import os
import libcore_hng.utils.app_logger as app_logger
import shared.configs.initialize_app as app
from discord.ext import commands
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, Session
from cogs.general_cog import GeneralCog
from cogs.message_cog import MessageCog
from services.persona_service import PersonaService
from services.system_service import SystemService
from services.comfyui_service import ComfyUIService
from services.image_service import ImageService
from services.log_service import LogService
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
        self.log_service = None
        self.image_service = None
        self.session_factory = None

        # アプリを初期化する
        app.setup(__file__)

    def _setup_comfyui_service(self, gemini_client, charspec_conf_path, db_session_factory=None):
        """
        ComfyUIServiceをセットアップする

        Parameters
        ----------
        gemini_client : GeminiClient
            GeminiClientインスタンス
        charspec_conf_path : Optional[str]
            キャラクター仕様JSONファイルパス
        db_session_factory : sessionmaker[Session]
            DBセッションファクトリ
        persona_id : str
            ペルソナID
        """
        return ComfyUIService(
            gemini_client=gemini_client,
            comfyui_config=app.config.comfyui,
            charspec_conf_path=charspec_conf_path,
            db_session_factory=db_session_factory,
        )
    
    def _get_session_factory(self) -> sessionmaker[Session]:
        
        database_url = os.environ.get("DATABASE_URL")
        if not database_url:
            raise ValueError("alembic.iniにsqlalchemy.urlが設定されていません")

        engine = create_engine(
            database_url,
            pool_pre_ping=True,
            echo=True
        )

        return sessionmaker(
            bind=engine,
            expire_on_commit=False,
            autoflush=False
        )
    
    async def setup_hook(self):
        """
        Botの起動時に非同期で実行される初期設定プロセス
        アプリ初期化、GeminiClient初期化、各機能(Cog)の登録を実行する
        """

        # DBセッションファクトリ生成
        self.session_factory = self._get_session_factory()

        # AI関連サービスの構築
        self.persona_service, self.gemini_client = self._build_ai_service(self.session_factory)

        # 各種サービスの初期化
        self.log_service = LogService(self.session_factory)
        self.image_service = ImageService(self.session_factory)

        # ペルソナ設定ファイルパス取得
        persona_name = os.environ.get("PERSONA_NAME", "Aoi")
        persona_conf_dir = os.environ.get("PERSONA_CONF_DIR", "configs/personas")
        charspec_conf_path = os.path.join(persona_conf_dir, persona_name, "character_spec.json")

        # ComfyUIServiceクラスインスタンス生成
        self.comfyui_service = self._setup_comfyui_service(
            gemini_client=self.gemini_client,
            charspec_conf_path=charspec_conf_path,
            db_session_factory=self.session_factory,
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

    def _build_ai_service(self, session_factory:sessionmaker[Session]) -> tuple[PersonaService, GeminiClient]:
        """
        Persona管理、GeminiClientのインスタンスを生成する

        Returns
        -------
        tuple[PersonaService, GeminiClient]
            初期化済の各サービスインスタンス
        session_factory : sessionmaker[Session]
            DBセッションファクトリ
        """

        # ペルソナチャット設定ファイルのパスを取得
        instruction_path = os.environ.get("INSTRUCTION_PATH", "configs/personas/_system/instruction.json")
        persona_name = os.environ.get("PERSONA_NAME", "Aoi")
        persona_chat_dir = os.environ.get("PERSONA_CAHT_DIR", "configs/personas")
        persona_path = os.path.join(persona_chat_dir, persona_name, "persona.json")

        # PersonaServiceインスタンス初期化
        persona_service = PersonaService(
            instruction_path=instruction_path,
            persona_path=persona_path,
            db_session_factory=session_factory
        )

        # GeminiClientインスタンス初期化
        gemini_client = GeminiClient(api_key=app.config.gemini.api_key)

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
                persona_service=self.persona_service,
                log_service=self.log_service,
                image_service=self.image_service
            )
        )
    
    def init_bot(self):

        # アプリ基盤を初期化する
        self._initialize_app_infrastructure()
        
    def get_app_token(self):

        # Discordアプリトークンを返す
        return app.config.discord.app_token

    async def start_bot(self):
        
        # Bot初期化
        self.init_bot()
        
        # アプリトークン取得
        token = self.get_app_token()

        # Bot開始処理実行
        await self.start(token)