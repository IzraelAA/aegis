from typing import List, Optional
from fastapi import APIRouter, Depends, Query, status
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.security import get_current_user, require_roles, SAFETY_OFFICER_AND_ABOVE, ALL_ROLES
from app.models.user import User
from app.schemas.incident import (
    IncidentCreate, 
    IncidentUpdate, 
    IncidentResponse, 
    IncidentListResponse,
    InvestigationStatusUpdate
)
from app.services.incident_service import IncidentService

router = APIRouter(prefix="/incidents", tags=["Incidents"])


@router.post("", response_model=IncidentResponse, status_code=status.HTTP_201_CREATED)
def create_incident(
    incident_data: IncidentCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Create a new incident report.
    
    Any authenticated user can report an incident.
    
    - **title**: Incident title (required)
    - **description**: Description (optional)
    - **location**: Location (required)
    - **incident_datetime**: Incident datetime (required)
    - **category**: minor / major / near_miss (default: minor)
    - **photo**: Photo URL (optional)
    """
    incident_service = IncidentService(db)
    return incident_service.create_incident(incident_data, current_user.id)


@router.get("", response_model=IncidentListResponse)
def get_all_incidents(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    category: Optional[str] = Query(None, description="Filter by category: minor / major / near_miss"),
    investigation_status: Optional[str] = Query(None, description="Filter by investigation status"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Get all incidents with optional filters.
    
    - **skip**: Number of records to skip (pagination)
    - **limit**: Maximum number of records to return
    - **category**: Filter by category (optional)
    - **investigation_status**: Filter by investigation status (optional)
    """
    incident_service = IncidentService(db)
    
    if category:
        items = incident_service.get_incidents_by_category(category, skip, limit)
    elif investigation_status:
        items = incident_service.get_incidents_by_status(investigation_status, skip, limit)
    else:
        items = incident_service.get_all_incidents(skip, limit)
    
    total = incident_service.get_incidents_count()
    return IncidentListResponse(total=total, items=items)


@router.get("/my", response_model=IncidentListResponse)
def get_my_incidents(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Get current user's incident reports.
    """
    incident_service = IncidentService(db)
    items = incident_service.get_incidents_by_user(current_user.id, skip, limit)
    total = incident_service.count_incidents_by_user(current_user.id)
    return IncidentListResponse(total=total, items=items)


@router.get("/search", response_model=IncidentListResponse)
def search_incidents(
    q: str = Query(..., min_length=1),
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Search incidents by title or description.
    """
    incident_service = IncidentService(db)
    items = incident_service.search_incidents(q, skip, limit)
    return IncidentListResponse(total=len(items), items=items)


@router.get("/{incident_id}", response_model=IncidentResponse)
def get_incident(
    incident_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Get incident by ID.
    """
    incident_service = IncidentService(db)
    return incident_service.get_incident(incident_id)


@router.put("/{incident_id}", response_model=IncidentResponse)
def update_incident(
    incident_id: int,
    incident_data: IncidentUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Update incident.
    
    - Owner can update their own incident
    - Safety Officer and Admin can update any incident
    """
    incident_service = IncidentService(db)
    return incident_service.update_incident(incident_id, incident_data, current_user)


@router.patch("/{incident_id}/investigation", response_model=IncidentResponse)
def update_investigation_status(
    incident_id: int,
    status_data: InvestigationStatusUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles(SAFETY_OFFICER_AND_ABOVE))
):
    """
    Update incident investigation status (Safety Officer and Admin only).
    
    - **investigation_status**: pending / in_progress / completed / closed
    - **investigation_notes**: Investigation notes (optional)
    """
    incident_service = IncidentService(db)
    return incident_service.update_investigation_status(incident_id, status_data, current_user)


@router.delete("/{incident_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_incident(
    incident_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_roles(["admin"]))
):
    """
    Delete incident (Admin only).
    """
    incident_service = IncidentService(db)
    incident_service.delete_incident(incident_id, current_user)
    return None

