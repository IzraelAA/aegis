from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.schemas.auth import Token, LoginRequest, RegisterRequest, RefreshTokenRequest
from app.schemas.user import UserResponse
from app.services.auth_service import AuthService

router = APIRouter(prefix="/auth", tags=["Authentication"])


@router.post("/register", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
def register(
    user_data: RegisterRequest,
    db: Session = Depends(get_db)
):
    """
    Register a new user.
    
    - **email**: Valid email address (required)
    - **username**: Unique username (required)
    - **password**: User password (required)
    - **full_name**: Full name (optional)
    - **phone**: Phone number (optional)
    - **department**: Department name (optional)
    """
    auth_service = AuthService(db)
    return auth_service.register(user_data)


@router.post("/login", response_model=Token)
def login(
    login_data: LoginRequest,
    db: Session = Depends(get_db)
):
    """
    Login to get access and refresh tokens.
    
    - **email**: Registered email address
    - **password**: User password
    
    Returns access_token and refresh_token.
    """
    auth_service = AuthService(db)
    return auth_service.login(login_data)


@router.post("/refresh", response_model=Token)
def refresh_token(
    token_data: RefreshTokenRequest,
    db: Session = Depends(get_db)
):
    """
    Refresh access token using refresh token.
    
    - **refresh_token**: Valid refresh token
    
    Returns new access_token and refresh_token.
    """
    auth_service = AuthService(db)
    return auth_service.refresh_token(token_data)

