from sqlalchemy import create_engine, event
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from sqlalchemy.pool import NullPool
from typing import Generator
import psycopg2

from app.core.config import settings

# Get database URL (supports both DATABASE_URL and separate variables)
database_url = settings.get_database_url()

# Supabase Connection Types:
# - Direct Connection (port 5432): Best for long-lived connections, supports all PostgreSQL features
# - Session Pooler (port 5432): Similar to direct but with Supabase pooling layer  
# - Transaction Pooler (port 6543): For serverless/short-lived connections, NO prepared statements
#
# Note: Transaction Pooler (port 6543) has compatibility issues with SQLAlchemy.
# Recommended: Use Session Pooler (port 5432) for better compatibility.

# Check if using Transaction Pooler (port 6543 or pooler.supabase.com)
is_transaction_pooler = ":6543" in database_url or "pooler.supabase.com" in database_url

def get_raw_connection():
    """Get a raw psycopg2 connection for Transaction Pooler compatibility."""
    from urllib.parse import urlparse, unquote
    import os
    from dotenv import load_dotenv
    load_dotenv()
    
    DATABASE_URL = os.getenv("DATABASE_URL")
    if DATABASE_URL:
        parsed = urlparse(DATABASE_URL)
        return psycopg2.connect(
            user=parsed.username,
            password=unquote(parsed.password) if parsed.password else "",
            host=parsed.hostname,
            port=parsed.port or 5432,
            dbname=parsed.path.lstrip("/")
        )
    else:
        return psycopg2.connect(
            user=os.getenv("user", "postgres"),
            password=os.getenv("password", ""),
            host=os.getenv("host", "localhost"),
            port=os.getenv("port", 5432),
            dbname=os.getenv("dbname", "postgres")
        )

# Custom creator function for Transaction Pooler
def transaction_pooler_creator():
    """Custom connection creator that works with Transaction Pooler."""
    return get_raw_connection()

if is_transaction_pooler:
    # Transaction Pooler: use custom creator to bypass SQLAlchemy connection issues
    engine = create_engine(
        "postgresql+psycopg2://",
        creator=transaction_pooler_creator,
        poolclass=NullPool,  # Disable client-side pooling
        echo=False
    )
else:
    # Direct Connection or Session Pooler: standard SQLAlchemy connection
    engine = create_engine(
        database_url,
        pool_pre_ping=True,
        pool_size=10,
        max_overflow=20,
        pool_recycle=3600,
        echo=False
    )

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()


def get_db() -> Generator[Session, None, None]:
    """Dependency to get database session."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
