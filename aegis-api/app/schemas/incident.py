from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from enum import Enum


class IncidentCategory(str, Enum):
    minor = "minor"
    major = "major"
    near_miss = "near_miss"


class InvestigationStatus(str, Enum):
    pending = "pending"
    in_progress = "in_progress"
    completed = "completed"
    closed = "closed"


class IncidentBase(BaseModel):
    title: str
    description: Optional[str] = None
    location: str
    incident_datetime: datetime
    photo: Optional[str] = None


class IncidentCreate(IncidentBase):
    category: IncidentCategory = IncidentCategory.minor


class IncidentUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    location: Optional[str] = None
    incident_datetime: Optional[datetime] = None
    photo: Optional[str] = None
    category: Optional[IncidentCategory] = None


class InvestigationStatusUpdate(BaseModel):
    investigation_status: InvestigationStatus
    investigation_notes: Optional[str] = None


class IncidentResponse(IncidentBase):
    id: int
    user_id: int
    category: str
    investigation_status: str
    investigation_notes: Optional[str] = None
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class IncidentListResponse(BaseModel):
    total: int
    items: list[IncidentResponse]

