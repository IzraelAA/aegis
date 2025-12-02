from sqlalchemy import Column, Integer, String, Boolean, DateTime, Enum
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum

from app.core.database import Base


class UserRole(str, enum.Enum):
    user = "user"
    supervisor = "supervisor"
    safety_officer = "safety_officer"
    admin = "admin"


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String(255), unique=True, index=True, nullable=False)
    username = Column(String(100), unique=True, index=True, nullable=False)
    hashed_password = Column(String(255), nullable=False)
    full_name = Column(String(255), nullable=True)
    phone = Column(String(20), nullable=True)
    department = Column(String(100), nullable=True)
    role = Column(String(50), default=UserRole.user.value, nullable=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    inspections = relationship("Inspection", back_populates="user", lazy="dynamic")
    incidents = relationship("Incident", back_populates="user", lazy="dynamic")
    # Specify foreign_keys to resolve ambiguity (Permit has both user_id and approved_by)
    permits = relationship("Permit", back_populates="user", foreign_keys="[Permit.user_id]", lazy="dynamic")

    def __repr__(self):
        return f"<User {self.username}>"

