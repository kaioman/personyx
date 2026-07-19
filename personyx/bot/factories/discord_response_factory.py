import discord
from typing import Optional
from services.persona_service import PersonaService
from helpers.discord_ui_helper import DiscordUIHelper
from constants.embed_constants import EmbedColors, EmbedTitles

class DiscordResponseFactory:

    def __init__(self, ui_helper: DiscordUIHelper, persona_service: PersonaService):
        """
        コンストラクタ
        """
        self.ui_helper = ui_helper
        self.persona_service = persona_service

    def update_persona(self, user_id: str):

        # ペルソナ設定取得
        persona_entity = self.persona_service._load_persona(user_id)

        # ペルソナ設定を更新
        self.ui_helper.update_config(persona_entity.persona_config)

    def build_chat_embed(self, text: str, user_id: str, color: Optional[int] = None, title: Optional[str] = None) -> discord.Embed:

        # ペルソナ設定を更新
        self.update_persona(user_id)

        # Embedを生成する
        embed = self.ui_helper.get_chat_embed(description=text, color=color, title=title)
        
        # Embedを返す
        return embed
        
    def build_persona_embed(self, category: str, key:str, *args, user_id: Optional[str] = None, color: Optional[int] = None, title: Optional[str] = None) -> discord.Embed:
        
        # ペルソナ設定を更新する
        if user_id:
            self.update_persona(user_id)

        # メッセージを取得する
        message_content = self.persona_service.get_static_message(category, key, *args, user_id=user_id)

        # EmbedとFileを生成して返す
        return self.build_chat_embed(
            text=message_content,
            user_id=user_id,
            color=color,
            title=title
        )

    def build_warning_embed(self, error_key: str, user_id: str, **kwargs) -> discord.Embed:

        # 警告メッセージを取得
        warning_text = self.persona_service.get_formatted_error_message(
            "system_messages",
            error_key,
            **kwargs, 
            user_id=user_id
        )

        # 警告メッセージEmbedを返す
        return self.build_chat_embed(
            text=warning_text,
            user_id=user_id,
            color=EmbedColors.WARNING,
            title=EmbedTitles.WARNING
        )
    
    def build_error_embed(self, error_key: str, user_id: str, color: int = EmbedColors.ERROR, title: str = EmbedTitles.ERROR, **kwargs) -> discord.Embed:

        # システムエラーメッセージを取得
        error_text = self.persona_service.get_formatted_error_message(
            "system_messages", 
            error_key, 
            **kwargs, 
            user_id=user_id
        )

        #  UIヘルパーでEmbedを作成して返す
        return self.ui_helper.get_chat_embed(description=error_text, color=color, title=title)

    def build_timeout_embed(self, user_id: str) -> discord.Embed:

        # タイムアウトEmbedを返す
        return self.build_persona_embed(
            category="system_messages",
            key="view_timeout",
            user_id=user_id,
            color=EmbedColors.TIMEOUT,
            title=EmbedTitles.TIMEOUT
        )