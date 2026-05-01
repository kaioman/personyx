import json
import os
import asyncio

import discord
from discord.ext import commands
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
#from models import Log
from pathlib import Path
from dotenv import load_dotenv

def load_persona():
    persona_path = os.path.join(os.path.dirname(__file__), "persona.json")
    try:
        with open(persona_path, "r", encoding="utf-8") as persona_file:
            return json.load(persona_file)
    except FileNotFoundError:
        return {
            "name": "Aoi",
            "traits": "落ち着いていて丁寧な返答",
            "style": "丁寧語",
        }


# def get_db_engine():
#     db_url = f"postgresql://{os.environ.get('DB_USER', 'personyx')}:{os.environ.get('DB_PASSWORD', 'personyx_pass')}@{os.environ.get('DB_HOST', 'db')}:{os.environ.get('DB_PORT', '5432')}/{os.environ.get('DB_NAME', 'personyx')}"
#     return create_engine(db_url)


# def log_to_db(user_name: str, message: str, response: str) -> None:
#     engine = get_db_engine()
#     Session = sessionmaker(bind=engine)
#     session = Session()
#     try:
#         log_entry = Log(user_name=user_name, message=message, response=response)
#         session.add(log_entry)
#         session.commit()
#     except Exception as exc:
#         print("[Bot] DB logging failed:", exc)
#         session.rollback()
#     finally:
#         session.close()


persona = load_persona()
intents = discord.Intents.default()
intents.message_content = True
bot = commands.Bot(command_prefix="!", intents=intents)


@bot.event
async def on_ready():
    print(f"[Bot] Logged in as {bot.user} (ID: {bot.user.id})")
    print("[Bot] Ready to receive messages.")


@bot.event
async def on_message(message: discord.Message):
    if message.author.bot:
        return

    content = message.content.strip()
    user_name = str(message.author)

    if content.startswith("!persona"):
        response = f"私は{persona['name']}です。{persona['traits']}、{persona['style']}でお答えします。"
    elif any(keyword in content.lower() for keyword in ["hello", "hi", "こんにちは", "こんばんは", "おはよう", "こんばんは"]):
        response = (
            f"こんにちは、{message.author.display_name}さん。"
            f" 私は{persona['name']}。{persona['traits']}で、{persona['style']}に返答します。"
        )
    else:
        response = (
            f"{message.author.display_name}さん、メッセージを受け取りました。"
            f" まずは簡単な挨拶で応答しています。"
        )

    await message.channel.send(response)
    #await asyncio.get_running_loop().run_in_executor(None, log_to_db, user_name, content, response)

if __name__ == "__main__":

    # .envの読み込み
    currnent_file = Path(__file__).resolve()
    target_dir = currnent_file.parent.parent / 'personyx-service'
    env_path = target_dir / '.env'
    load_dotenv(dotenv_path=env_path)

    token = os.environ.get("DISCORD_TOKEN")
    if not token:
        raise SystemExit("DISCORD_TOKEN is not set in environment variables.")

    bot.run(token)
