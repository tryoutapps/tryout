import urllib.parse
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker
from sqlalchemy.orm import declarative_base

# Password asli: P@ssw0rd
password = urllib.parse.quote_plus("P@ssw0rd")

# Maka URL akan menjadi: postgresql+asyncpg://postgres:P%40ssw0rd@localhost:5432/db_psikotes
DATABASE_URL = f"postgresql+asyncpg://postgres:{password}@localhost:5432/tryoutdb"

engine = create_async_engine(DATABASE_URL, echo=True)
AsyncSessionLocal = async_sessionmaker(bind=engine, class_=AsyncSession, expire_on_commit=False)
Base = declarative_base()

async def get_db():
    async with AsyncSessionLocal() as session:
        yield session
