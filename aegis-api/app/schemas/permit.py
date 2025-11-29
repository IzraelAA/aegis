from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from enum import Enum


class PermitType(str, Enum):
    hot_work = "hot_work"
    confined_space = "confined_space"
    work_at_height = "work_at_height"


class ApprovalStatus(str, Enum):
    pending = "pending"
    approved = "approved"
    rejected = "rejected"


class PermitBase(BaseModel):
    permit_type: PermitType
    description: Optional[str] = None
    location: Optional[str] = None
    start_date: datetime
    end_date: datetime


class PermitCreate(PermitBase):
    pass


class PermitUpdate(BaseModel):
    permit_type: Optional[PermitType] = None
    description: Optional[str] = None
    location: Optional[str] = None
    start_date: Optional[datetime] = None
    end_date: Optional[datetime] = None


class PermitApprovalRequest(BaseModel):
    approval_notes: Optional[str] = None


class PermitResponse(PermitBase):
    id: int
    user_id: int
    approval_status: str
    approved_by: Optional[int] = None
    approval_notes: Optional[str] = None
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class PermitListResponse(BaseModel):
    total: int
    items: list[PermitResponse]

