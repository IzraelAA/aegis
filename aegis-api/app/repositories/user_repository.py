from typing import Optional, List
from sqlalchemy.orm import Session

from app.models.user import User
from app.repositories.base_repository import BaseRepository


class UserRepository(BaseRepository[User]):
    """Repository for User operations."""
    
    def __init__(self, db: Session):
        super().__init__(User, db)
    
    def get_by_email(self, email: str) -> Optional[User]:
        """Get user by email."""
        return self.db.query(User).filter(User.email == email).first()
    
    def get_by_username(self, username: str) -> Optional[User]:
        """Get user by username."""
        return self.db.query(User).filter(User.username == username).first()
    
    def get_active_users(self, skip: int = 0, limit: int = 100) -> List[User]:
        """Get all active users."""
        return self.db.query(User).filter(User.is_active == True).offset(skip).limit(limit).all()
    
    def get_users_by_role(self, role: str, skip: int = 0, limit: int = 100) -> List[User]:
        """Get users by role."""
        return self.db.query(User).filter(User.role == role).offset(skip).limit(limit).all()
    
    def search_users(self, query: str, skip: int = 0, limit: int = 100) -> List[User]:
        """Search users by name or email."""
        search_filter = f"%{query}%"
        return self.db.query(User).filter(
            (User.full_name.ilike(search_filter)) |
            (User.email.ilike(search_filter)) |
            (User.username.ilike(search_filter))
        ).offset(skip).limit(limit).all()
    
    def count_by_role(self, role: str) -> int:
        """Count users by role."""
        return self.db.query(User).filter(User.role == role).count()
    
    def deactivate_user(self, user_id: int) -> Optional[User]:
        """Deactivate user."""
        user = self.get(user_id)
        if user:
            user.is_active = False
            self.db.commit()
            self.db.refresh(user)
        return user
    
    def activate_user(self, user_id: int) -> Optional[User]:
        """Activate user."""
        user = self.get(user_id)
        if user:
            user.is_active = True
            self.db.commit()
            self.db.refresh(user)
        return user
