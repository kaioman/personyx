import discord
from typing import Optional

class DiscordUIHelper:
    """
    Discord BotのUIコンポーネント(Embedや添付ファイル)を構築するヘルパークラス
    ペルソナの設定用Dictを保持し、Embed生成や画像パスの解決を提供する
    
    """
    def __init__(self, persona_config: dict):
        """
        コンストラクタ

        Parameters
        ----------
        persona_config : dict
            ペルソナ設定情報
        """

        # ペルソナ設定を初期設定する
        self.update_config(persona_config)

    def update_config(self, persona_config: dict):
        """
        ペルソナ設定を更新する

        Parameters
        ----------
        persona_config : dict
            ペルソナ設定情報
        """

        # ペルソナ名取得
        self.name = persona_config.get("name", "Unknown")

        # テーマカラーを取得
        self.color = int(persona_config.get("theme_color", "0xff69b4"), 16)

        # ペルソナアイコン画像URLを取得
        self.persona_icon_url = persona_config.get("persona_icon_url")

        # ペルソナサムネイル表示有無を取得
        self.show_thumbnail = persona_config.get("show_thumbnail", False)

    def get_chat_embed(self, description: str, color: Optional[int] = None, title: Optional[str] = None) -> discord.Embed:
        """
        Embedオブジェクトを返す

        Parameters
        ----------
        description : str
            メッセージ内容
        color : Optional[int]
            Embedの左側に表示される帯のカラー
        title : Optional[str]
            Embedのタイトル

        Returns
        -------            
        discord.Embed
            生成したEmbed
        """

        # 画像URLを取得
        image_url = self.prepare_image(self.persona_icon_url)
        # サムネイル表示設定を取得(URLが無い場合は表示しないようFalseを渡す)
        show_thumbnail = self.show_thumbnail and bool(image_url)
        # colorのデフォルト値を処理
        embed_color = color if color is not None else self.color

        # Embed生成
        embed = self.create_embed(
            description=description, 
            image_url=image_url,
            show_thumbnail=show_thumbnail,
            color=embed_color,
            title=title
        )

        # 戻り値を返す
        return embed

    def prepare_image(self, image_input: str) -> str:
        """
        画像URLのバリデーションを行う
        https:// から始まらない場合は空文字を返す

        Parameters
        ----------
        image_input : str
            画像のHTTP URLまたはローカルファイルパス
        
        Returns
        -------
        str
            有効な https URL、または空文字
        """
        
        # image_inputが未指定の場合は処理を抜ける
        if not image_input:
            return ""
        
        # https:// または http:// から始まるURLのみを許可する
        if image_input.startswith("http"):
            return image_input
        
        # ローカルパスなどは許可せず無視する
        return ""

    def create_embed(self, 
        description: str, 
        image_url: str, 
        show_thumbnail: bool, 
        color: int,
        title: Optional[str] = None) -> discord.Embed:
        """
        設定に基づいたDiscord Embedを作成する

        Parameters
        ----------
        description : str
            メッセージ本文
        image_url : str
            set_thumbnailに指定するURL（prepare_imageの戻りを指定する）
        show_thumbnail : bool
            ペルソナのサムネイル表示
        color : int
            Embedの左側に表示される帯のカラー
        
        Returns
        -------
        discord.Embed
            設定済のEmbedインスタンス        
        """

        # Embedを作成する
        embed = discord.Embed(description=description, color=color)

        # Embedタイトルをセットする
        if title:
            embed.title = title

        # authorをセットする
        if image_url:
            embed.set_author(name=self.name, icon_url=image_url)
        else:
            embed.set_author(name=self.name)
        
        # ペルソナサムネイルURLをセットする
        if show_thumbnail and image_url:
            embed.set_thumbnail(url=image_url)

        # Embedを返す
        return embed