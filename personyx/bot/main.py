import asyncio
import discord
from core import MyBot

if __name__ == "__main__":

    # Bot起動
    async def start():
        """
        Botの非同期エントリポイント
        """
        intents = discord.Intents.default()
        intents.message_content = True

        # botを開始する
        async with MyBot(intents=intents) as bot:
            await bot.start_bot()

    try:
        asyncio.run(start())
    except KeyboardInterrupt:
        pass