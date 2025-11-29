from typing import List, Optional
from fastapi import APIRouter, Depends, Query, status
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.security import get_current_user, require_roles, SUPERVISOR_AND_ABOVE, ALL_ROLES
from app.models.user import User
from app.schemas.permit import (
    PermitCreate, 
    PermitUpdate, 
    PermitResponse, 
    PermitListResponse,
    PermitApprovalRequest
)
from app.services.permit_service import PermitService

router = APIRouter(prefix="/permits", tags=["Permits (PTW)"])


@router.post("", response_model=PermitResponse, status_code=status.HTTP_201_CREATED)
def create_permit(
    permit_data: PermitCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Create a new Permit to Work (PTW).
    
    Any authenticated user can create a permit request.
    
    - **permit_type**: hot_work / confined_space / work_at_height (required)
    - **description**: Description (optional)
    - **location**: Work location (optional)
    - **start_date**: Start datetime (required)
    - **end_date**: End datetime (required)
    """
    permit_service = PermitService(db)
    return permit_service.create_permit(permit_data, current_user.id)


@router.get("", response_model=PermitListResponse)
def get_all_permits(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    permit_type: Optional[str] = Query(None, description="Filter by type: hot_work / confined_space / work_at_height"),
    approval_status: Optional[str] = Query(None, description="Filter by status: pending / approved / rejected"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Get all permits with optional filters.
    
    - **skip**: Number of records to skip (pagination)
    - **limit**: Maximum number of records to return
    - **permit_type**: Filter by permit type (optional)
    - **approval_status**: Filter by approval status (optional)
    """
    permit_service = PermitService(db)
    
    if permit_type:
        items = permit_service.get_permits_by_type(permit_type, skip, limit)
    elif approval_status:
        items = permit_service.get_permits_by_status(approval_status, skip, limit)
    else:
        items = permit_service.get_all_permits(skip, limit)
    
    total = permit_service.get_permits_count()
    return PermitListResponse(total=total, items=items)


@router.get("/my", response_model=PermitListResponse)
def get_my_permits(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Get current user's permits.
    """
    permit_service = PermitService(db)
    items = permit_service.get_permits_by_user(current_user.id, skip, limit)
    total = permit_service.count_permits_by_user(current_user.id)
    return PermitListResponse(total=total, items=items)


@router.get("/pending", response_model=PermitListResponse)
def get_pending_permits(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles(SUPERVISOR_AND_ABOVE))
):
    """
    Get all pending permits (Supervisor and above).
    
    Used for approval workflow.
    """
    permit_service = PermitService(db)
    items = permit_service.get_pending_permits(skip, limit)
    total = permit_service.count_pending_permits()
    return PermitListResponse(total=total, items=items)


@router.get("/{permit_id}", response_model=PermitResponse)
def get_permit(
    permit_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Get permit by ID.
    """
    permit_service = PermitService(db)
    return permit_service.get_permit(permit_id)


@router.put("/{permit_id}", response_model=PermitResponse)
def update_permit(
    permit_id: int,
    permit_data: PermitUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Update permit.
    
    - Only owner or admin can update
    - Cannot update processed (approved/rejected) permits
    """
    permit_service = PermitService(db)
    return permit_service.update_permit(permit_id, permit_data, current_user)


@router.post("/{permit_id}/approve", response_model=PermitResponse)
def approve_permit(
    permit_id: int,
    approval_data: PermitApprovalRequest = PermitApprovalRequest(),
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles(SUPERVISOR_AND_ABOVE))
):
    """
    Approve permit (Supervisor and above).
    
    - **approval_notes**: Optional approval notes
    """
    permit_service = PermitService(db)
    return permit_service.approve_permit(permit_id, approval_data, current_user)


@router.post("/{permit_id}/reject", response_model=PermitResponse)
def reject_permit(
    permit_id: int,
    rejection_data: PermitApprovalRequest = PermitApprovalRequest(),
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles(SUPERVISOR_AND_ABOVE))
):
    """
    Reject permit (Supervisor and above).
    
    - **approval_notes**: Optional rejection reason
    """
    permit_service = PermitService(db)
    return permit_service.reject_permit(permit_id, rejection_data, current_user)


@router.delete("/{permit_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_permit(
    permit_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles(["admin"]))
):
    """
    Delete permit (Admin only).
    """
    permit_service = PermitService(db)
    permit_service.delete_permit(permit_id, current_user)
    return None

