from typing import List, Optional
from sqlalchemy.orm import Session
from fastapi import HTTPException, status

from app.models.user import User
from app.repositories.user_repository import UserRepository
from app.schemas.user import UserCreate, UserUpdate
from app.core.security import get_password_hash


class UserService:
    """Service for User operations."""
    
    def __init__(self, db: Session):
        self.db = db
        self.user_repo = UserRepository(db)
    
    def create_user(self, user_data: UserCreate) -> User:
        """Create a new user (admin only)."""
        # Check if email already exists
        if self.user_repo.get_by_email(user_data.email):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email already registered"
            )
        
        # Check if username already exists
        if self.user_repo.get_by_username(user_data.username):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Username already taken"
            )
        
        # Hash password
        hashed_password = get_password_hash(user_data.password)
        
        # Create new user
        user_dict = {
            "email": user_data.email,
            "username": user_data.username,
            "hashed_password": hashed_password,
            "full_name": user_data.full_name,
            "phone": user_data.phone,
            "department": user_data.department,
            "role": user_data.role.value,
            "is_active": True
        }
        
        return self.user_repo.create(user_dict)
    
    def get_user(self, user_id: int) -> User:
        """Get user by ID."""
        user = self.user_repo.get(user_id)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        return user
    
    def get_all_users(self, skip: int = 0, limit: int = 100) -> List[User]:
        """Get all users (admin only)."""
        return self.user_repo.get_all(skip, limit)
    
    def get_users_count(self) -> int:
        """Get total users count."""
        return self.user_repo.count()
    
    def update_user(self, user_id: int, user_data: UserUpdate, current_user: User) -> User:
        """Update user."""
        user = self.user_repo.get(user_id)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        
        # Regular users can only update themselves
        if current_user.role != "admin" and current_user.id != user_id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You don't have permission to update this user"
            )
        
        # Regular users cannot change role
        if current_user.role != "admin" and user_data.role is not None:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You don't have permission to change role"
            )
        
        # Check email uniqueness if changed
        if user_data.email and user_data.email != user.email:
            existing = self.user_repo.get_by_email(user_data.email)
            if existing:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail="Email already in use"
                )
        
        # Check username uniqueness if changed
        if user_data.username and user_data.username != user.username:
            existing = self.user_repo.get_by_username(user_data.username)
            if existing:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail="Username already in use"
                )
        
        update_dict = user_data.model_dump(exclude_unset=True)
        if "role" in update_dict and update_dict["role"]:
            update_dict["role"] = update_dict["role"].value
        
        return self.user_repo.update(user, update_dict)
    
    def delete_user(self, user_id: int) -> bool:
        """Delete user (admin only)."""
        user = self.user_repo.get(user_id)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        return self.user_repo.delete(user_id)
    
    def deactivate_user(self, user_id: int) -> User:
        """Deactivate user (admin only)."""
        user = self.user_repo.deactivate_user(user_id)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        return user
    
    def activate_user(self, user_id: int) -> User:
        """Activate user (admin only)."""
        user = self.user_repo.activate_user(user_id)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        return user
    
    def get_profile(self, current_user: User) -> User:
        """Get current user profile."""
        return current_user
    
    def search_users(self, query: str, skip: int = 0, limit: int = 100) -> List[User]:
        """Search users (admin only)."""
        return self.user_repo.search_users(query, skip, limit)
    
    def get_users_by_role(self, role: str, skip: int = 0, limit: int = 100) -> List[User]:
        """Get users by role (admin only)."""
        return self.user_repo.get_users_by_role(role, skip, limit)
