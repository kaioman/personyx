
_SYSTEM_PREFIX = "SYSTEM"

class EmbedTitles:

    DRESSUP_SELECT = f"**[{_SYSTEM_PREFIX}: DRESSUP SELECT]**"
    """ ドレスアップ前のRating選択 """

    DRESSUP_SELECT_DEBUG = f"**[{_SYSTEM_PREFIX}] DRESSUP SELECT (DEBUG)]**"
    """ ドレスアップ前のRating選択(デバッグ) """

    DRESSUP_START = f"**[{_SYSTEM_PREFIX}: DRESSUP START]**"
    """ ドレスアップ開始 """

    DRESSUP_COMPLETE = lambda level: f"**[{_SYSTEM_PREFIX}: DRESSUP COMPLETE]: Level {level}**"
    """ ドレスアップ完了 """

    WARNING = f"⚠️ **[{_SYSTEM_PREFIX}: WARNING]**"
    """ 警告 """

    TIMEOUT = f"⏳ **[{_SYSTEM_PREFIX}: SESSION TIMEOUT]**"
    """ タイムアウト """

    ERROR = f"⚠️ **[{_SYSTEM_PREFIX}: ERROR]**"
    """ システムエラー """

class EmbedColors:

    DEFAULT = None
    """ ペルソナテーマカラー """

    WARNING = 0xFEE75C
    """ 警告 """

    TIMEOUT = 0x808080
    """ タイムアウト(グレー) """

    ERROR = 0xED4245
    """ システムエラー(レッド) """