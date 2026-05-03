import os
import discord
from discord.ext import commands
from services.persona_service import PersonaService
from pycorex.gemini_client import GeminiClient

class MessageCog(commands.Cog):
    """
    Discord メッセージをトリガーとしたAI対話制御を担当するCogクラス

    チャネルごとのセッション管理、Personaに基づいたプロンプト構築、
    Gemini APIとの通信を仲介する
    """
    
    def __init__(self, bot: commands.Bot, gemini_client: GeminiClient, persona_service: PersonaService):
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
        
        """
        self.bot = bot
        self.client = gemini_client
        self.persona_service = persona_service
        self.sessions: dict[int, any] = {}

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