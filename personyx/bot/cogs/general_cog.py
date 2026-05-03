from discord.ext import commands
from services.system_service import SystemService

class GeneralCog(commands.Cog):
    """
    Bot 全体のシステム管理及びライフサイクル制御を担当するCog
    Botの起動イベント(on_ready)を検知し、アプリ基盤のセットアップ、
    接続確認、システムステータスのログ出力を管理する
    """
    def __init__(self, bot):
        """
        コンストラクタ

        Parameters
        ----------
        bot : commands.Bot
            Dicord Botのインスタンス
        
        """
        self.bot = bot
        self.system_service = SystemService(bot)

    @commands.Cog.listener()
    async def on_ready(self):
        """
        BotがDiscord Gatewayへの接続を完了し、準備が整った際に実行されるイベント
        """
        # アプリ基盤セットアップ        
        self.system_service.setup_app()

        # 準備完了ログ出力
        self.system_service.log_boot_message()
