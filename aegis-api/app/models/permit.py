from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey, Enum
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum

from app.core.database import Base


class PermitType(str, enum.Enum):
    hot_work = "hot_work"
    confined_space = "confined_space"
    work_at_height = "work_at_height"


class ApprovalStatus(str, enum.Enum):
    pending = "pending"
    approved = "approved"
    rejected = "rejected"


class Permit(Base):
    __tablename__ = "permits"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    permit_type = Column(String(50), default=PermitType.hot_work.value, nullable=False)
    description = Column(Text, nullable=True)
    location = Column(String(255), nullable=True)
    start_date = Column(DateTime(timezone=True), nullable=False)
    end_date = Column(DateTime(timezone=True), nullable=False)
    approval_status = Column(String(50), default=ApprovalStatus.pending.value, nullable=False)
    approved_by = Column(Integer, ForeignKey("users.id"), nullable=True)
    approval_notes = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    user = relationship("User", back_populates="permits", foreign_keys=[user_id])
    approver = relationship("User", foreign_keys=[approved_by])

    def __repr__(self):
        return f"<Permit {self.id} - {self.permit_type}>"

