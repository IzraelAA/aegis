from typing import List, Optional
from fastapi import APIRouter, Depends, Query, status
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.security import get_current_user, require_roles, SUPERVISOR_AND_ABOVE, ALL_ROLES
from app.models.user import User
from app.schemas.inspection import (
    InspectionCreate, 
    InspectionUpdate, 
    InspectionResponse, 
    InspectionListResponse,
    InspectionStatusUpdate
)
from app.services.inspection_service import InspectionService

router = APIRouter(prefix="/inspections", tags=["Inspections"])


@router.post("", response_model=InspectionResponse, status_code=status.HTTP_201_CREATED)
def create_inspection(
    inspection_data: InspectionCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Create a new inspection.
    
    Any authenticated user can create an inspection.
    
    - **location**: Location of inspection (required)
    - **category**: Category of inspection (required)
    - **description**: Description (optional)
    - **photo**: Photo URL (optional)
    - **status**: safe / unsafe (default: safe)
    """
    inspection_service = InspectionService(db)
    return inspection_service.create_inspection(inspection_data, current_user.id)


@router.get("", response_model=InspectionListResponse)
def get_all_inspections(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    status: Optional[str] = Query(None, description="Filter by status: safe / unsafe"),
    category: Optional[str] = Query(None, description="Filter by category"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Get all inspections with optional filters.
    
    - **skip**: Number of records to skip (pagination)
    - **limit**: Maximum number of records to return
    - **status**: Filter by status (optional)
    - **category**: Filter by category (optional)
    """
    inspection_service = InspectionService(db)
    
    if status:
        items = inspection_service.get_inspections_by_status(status, skip, limit)
    elif category:
        items = inspection_service.get_inspections_by_category(category, skip, limit)
    else:
        items = inspection_service.get_all_inspections(skip, limit)
    
    total = inspection_service.get_inspections_count()
    return InspectionListResponse(total=total, items=items)


@router.get("/my", response_model=InspectionListResponse)
def get_my_inspections(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Get current user's inspections.
    """
    inspection_service = InspectionService(db)
    items = inspection_service.get_inspections_by_user(current_user.id, skip, limit)
    total = inspection_service.count_inspections_by_user(current_user.id)
    return InspectionListResponse(total=total, items=items)


@router.get("/user/{user_id}", response_model=InspectionListResponse)
def get_inspections_by_user(
    user_id: int,
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles(SUPERVISOR_AND_ABOVE))
):
    """
    Get inspections by user ID (Supervisor and above).
    """
    inspection_service = InspectionService(db)
    items = inspection_service.get_inspections_by_user(user_id, skip, limit)
    total = inspection_service.count_inspections_by_user(user_id)
    return InspectionListResponse(total=total, items=items)


@router.get("/{inspection_id}", response_model=InspectionResponse)
def get_inspection(
    inspection_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Get inspection by ID.
    """
    inspection_service = InspectionService(db)
    return inspection_service.get_inspection(inspection_id)


@router.put("/{inspection_id}", response_model=InspectionResponse)
def update_inspection(
    inspection_id: int,
    inspection_data: InspectionUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Update inspection.
    
    - Owner can update their own inspection
    - Supervisor and above can update any inspection
    """
    inspection_service = InspectionService(db)
    return inspection_service.update_inspection(inspection_id, inspection_data, current_user)


@router.patch("/{inspection_id}/status", response_model=InspectionResponse)
def update_inspection_status(
    inspection_id: int,
    status_data: InspectionStatusUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles(SUPERVISOR_AND_ABOVE))
):
    """
    Update inspection status (Supervisor and above).
    
    - **status**: safe / unsafe
    """
    inspection_service = InspectionService(db)
    return inspection_service.update_inspection_status(inspection_id, status_data, current_user)


@router.delete("/{inspection_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_inspection(
    inspection_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles(["admin"]))
):
    """
    Delete inspection (Admin only).
    """
    inspection_service = InspectionService(db)
    inspection_service.delete_inspection(inspection_id, current_user)
    return None

