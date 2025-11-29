from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from enum import Enum


class InspectionStatus(str, Enum):
    safe = "safe"
    unsafe = "unsafe"


class InspectionBase(BaseModel):
    location: str
    category: str
    description: Optional[str] = None
    photo: Optional[str] = None


class InspectionCreate(InspectionBase):
    status: InspectionStatus = InspectionStatus.safe


class InspectionUpdate(BaseModel):
    location: Optional[str] = None
    category: Optional[str] = None
    description: Optional[str] = None
    photo: Optional[str] = None
    status: Optional[InspectionStatus] = None


class InspectionStatusUpdate(BaseModel):
    status: InspectionStatus


class InspectionResponse(InspectionBase):
    id: int
    user_id: int
    status: str
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class InspectionListResponse(BaseModel):
    total: int
    items: list[InspectionResponse]

