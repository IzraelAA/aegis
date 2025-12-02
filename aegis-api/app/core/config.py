from pydantic_settings import BaseSettings
from functools import lru_cache
from urllib.parse import quote_plus, urlparse, parse_qs, urlencode
import os
import re


class Settings(BaseSettings):
    # Database - Option 1: Direct DATABASE_URL
    DATABASE_URL: str = "postgresql://postgres:password@localhost:5432/aegis_k3"
    
    # Database - Option 2: Separate variables (for Supabase)
    db_user: str = ""
    db_password: str = ""
    db_host: str = ""
    db_port: str = "5432"
    db_name: str = "postgres"
    db_sslmode: str = "require"  # Required for Supabase
    
    # JWT
    SECRET_KEY: str = "your-super-secret-key-change-this-in-production"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    REFRESH_TOKEN_EXPIRE_DAYS: int = 7
    
    # App
    APP_NAME: str = "AEGIS K3 API"
    DEBUG: bool = True
    
    class Config:
        env_file = ".env"
        case_sensitive = True
    
    def _clean_database_url(self, url: str) -> str:
        """
        Clean database URL by removing unsupported parameters like 'pgbouncer'.
        """
        # Remove pgbouncer parameter (not supported by psycopg2)
        url = re.sub(r'[?&]pgbouncer=[^&]*', '', url)
        
        # Clean up any double ampersands or trailing question marks
        url = re.sub(r'\?&', '?', url)
        url = re.sub(r'&&+', '&', url)
        url = url.rstrip('?&')
        
        # Ensure using psycopg2 driver (most compatible with basic usage)
        if url.startswith('postgresql://'):
            url = url.replace('postgresql://', 'postgresql+psycopg2://', 1)
        elif url.startswith('postgresql+psycopg://'):
            url = url.replace('postgresql+psycopg://', 'postgresql+psycopg2://', 1)
        
        return url
    
    def get_database_url(self) -> str:
        """
        Get database URL from either DATABASE_URL or separate variables.
        Priority: DATABASE_URL > separate variables
        """
        # If DATABASE_URL is set and not default, use it
        if self.DATABASE_URL and self.DATABASE_URL != "postgresql://postgres:password@localhost:5432/aegis_k3":
            return self._clean_database_url(self.DATABASE_URL)
        
        # Otherwise, construct from separate variables
        # Support both 'user' and 'db_user' for flexibility
        user = self.db_user or os.getenv("user", "postgres")
        password = self.db_password or os.getenv("password", "")
        host = self.db_host or os.getenv("host", "localhost")
        port = self.db_port or os.getenv("port", "5432")
        dbname = self.db_name or os.getenv("dbname", "postgres")
        
        # URL-encode password to handle special characters
        encoded_password = quote_plus(password)
        
        # Construct connection string for Supabase
        return f"postgresql+psycopg2://{user}:{encoded_password}@{host}:{port}/{dbname}"


@lru_cache()
def get_settings() -> Settings:
    return Settings()


settings = get_settings()

