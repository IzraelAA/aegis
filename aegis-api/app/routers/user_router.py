from typing import List, Optional
from fastapi import APIRouter, Depends, Query, status
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.security import get_current_user, require_roles, ADMIN_ONLY, ALL_ROLES
from app.models.user import User
from app.schemas.user import UserCreate, UserUpdate, UserResponse, UserProfileResponse
from app.services.user_service import UserService

router = APIRouter(prefix="/users", tags=["Users"])


@router.get("/me", response_model=UserProfileResponse)
def get_profile(
    current_user: User = Depends(get_current_user)
):
    """
    Get current user profile.
    
    Requires authentication.
    """
    return current_user


@router.put("/me", response_model=UserResponse)
def update_profile(
    user_data: UserUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Update current user profile.
    
    Regular users cannot change their role.
    """
    user_service = UserService(db)
    return user_service.update_user(current_user.id, user_data, current_user)


@router.get("", response_model=List[UserResponse])
def get_all_users(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles(ADMIN_ONLY))
):
    """
    Get all users (Admin only).
    
    - **skip**: Number of records to skip (pagination)
    - **limit**: Maximum number of records to return
    """
    user_service = UserService(db)
    return user_service.get_all_users(skip, limit)


@router.post("", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
def create_user(
    user_data: UserCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles(ADMIN_ONLY))
):
    """
    Create a new user (Admin only).
    
    Admin can assign any role to the new user.
    """
    user_service = UserService(db)
    return user_service.create_user(user_data)


@router.get("/{user_id}", response_model=UserResponse)
def get_user(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles(ADMIN_ONLY))
):
    """
    Get user by ID (Admin only).
    """
    user_service = UserService(db)
    return user_service.get_user(user_id)


@router.put("/{user_id}", response_model=UserResponse)
def update_user(
    user_id: int,
    user_data: UserUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Update user by ID.
    
    - Regular users can only update their own profile
    - Admin can update any user and change roles
    """
    user_service = UserService(db)
    return user_service.update_user(user_id, user_data, current_user)


@router.delete("/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_user(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles(ADMIN_ONLY))
):
    """
    Delete user by ID (Admin only).
    """
    user_service = UserService(db)
    user_service.delete_user(user_id)
    return None


@router.post("/{user_id}/deactivate", response_model=UserResponse)
def deactivate_user(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles(ADMIN_ONLY))
):
    """
    Deactivate user (Admin only).
    
    Deactivated users cannot login.
    """
    user_service = UserService(db)
    return user_service.deactivate_user(user_id)


@router.post("/{user_id}/activate", response_model=UserResponse)
def activate_user(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles(ADMIN_ONLY))
):
    """
    Activate user (Admin only).
    """
    user_service = UserService(db)
    return user_service.activate_user(user_id)


@router.get("/search/", response_model=List[UserResponse])
def search_users(
    q: str = Query(..., min_length=1),
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles(ADMIN_ONLY))
):
    """
    Search users by name, email, or username (Admin only).
    """
    user_service = UserService(db)
    return user_service.search_users(q, skip, limit)


@router.get("/role/{role}", response_model=List[UserResponse])
def get_users_by_role(
    role: str,
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles(ADMIN_ONLY))
):
    """
    Get users by role (Admin only).
    
    Valid roles: user, supervisor, safety_officer, admin
    """
    user_service = UserService(db)
    return user_service.get_users_by_role(role, skip, limit)

