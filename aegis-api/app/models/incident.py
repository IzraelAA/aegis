from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey, Enum
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum

from app.core.database import Base


class IncidentCategory(str, enum.Enum):
    minor = "minor"
    major = "major"
    near_miss = "near_miss"


class InvestigationStatus(str, enum.Enum):
    pending = "pending"
    in_progress = "in_progress"
    completed = "completed"
    closed = "closed"


class Incident(Base):
    __tablename__ = "incidents"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    title = Column(String(255), nullable=False)
    description = Column(Text, nullable=True)
    category = Column(String(50), default=IncidentCategory.minor.value, nullable=False)
    photo = Column(String(500), nullable=True)  # Photo URL
    location = Column(String(255), nullable=False)
    incident_datetime = Column(DateTime(timezone=True), nullable=False)
    investigation_status = Column(String(50), default=InvestigationStatus.pending.value, nullable=False)
    investigation_notes = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationship
    user = relationship("User", back_populates="incidents")

    def __repr__(self):
        return f"<Incident {self.id} - {self.title}>"

