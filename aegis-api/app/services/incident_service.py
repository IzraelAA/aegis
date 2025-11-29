from typing import List, Optional
from sqlalchemy.orm import Session
from fastapi import HTTPException, status

from app.models.incident import Incident
from app.models.user import User
from app.repositories.incident_repository import IncidentRepository
from app.schemas.incident import IncidentCreate, IncidentUpdate, InvestigationStatusUpdate


class IncidentService:
    """Service for Incident operations."""
    
    def __init__(self, db: Session):
        self.db = db
        self.incident_repo = IncidentRepository(db)
    
    def create_incident(self, incident_data: IncidentCreate, user_id: int) -> Incident:
        """Create a new incident report."""
        incident_dict = {
            "user_id": user_id,
            "title": incident_data.title,
            "description": incident_data.description,
            "category": incident_data.category.value,
            "photo": incident_data.photo,
            "location": incident_data.location,
            "incident_datetime": incident_data.incident_datetime,
            "investigation_status": "pending"
        }
        return self.incident_repo.create(incident_dict)
    
    def get_incident(self, incident_id: int) -> Incident:
        """Get incident by ID."""
        incident = self.incident_repo.get(incident_id)
        if not incident:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Incident not found"
            )
        return incident
    
    def get_all_incidents(self, skip: int = 0, limit: int = 100) -> List[Incident]:
        """Get all incidents."""
        return self.incident_repo.get_all_sorted(skip, limit)
    
    def get_incidents_count(self) -> int:
        """Get total incidents count."""
        return self.incident_repo.count()
    
    def get_incidents_by_user(self, user_id: int, skip: int = 0, limit: int = 100) -> List[Incident]:
        """Get incidents by user."""
        return self.incident_repo.get_by_user(user_id, skip, limit)
    
    def count_incidents_by_user(self, user_id: int) -> int:
        """Count incidents by user."""
        return self.incident_repo.count_by_user(user_id)
    
    def get_incidents_by_category(
        self, 
        category: str, 
        skip: int = 0, 
        limit: int = 100
    ) -> List[Incident]:
        """Get incidents by category."""
        return self.incident_repo.get_by_category(category, skip, limit)
    
    def count_incidents_by_category(self, category: str) -> int:
        """Count incidents by category."""
        return self.incident_repo.count_by_category(category)
    
    def get_incidents_by_status(
        self, 
        status_inv: str, 
        skip: int = 0, 
        limit: int = 100
    ) -> List[Incident]:
        """Get incidents by investigation status."""
        return self.incident_repo.get_by_investigation_status(status_inv, skip, limit)
    
    def update_incident(
        self, 
        incident_id: int, 
        incident_data: IncidentUpdate, 
        current_user: User
    ) -> Incident:
        """Update incident."""
        incident = self.incident_repo.get(incident_id)
        if not incident:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Incident not found"
            )
        
        # Only owner or admin/safety_officer can update
        allowed_roles = ["admin", "safety_officer"]
        if current_user.id != incident.user_id and current_user.role not in allowed_roles:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You don't have permission to update this incident"
            )
        
        update_dict = incident_data.model_dump(exclude_unset=True)
        # Map schema field names to model field names (they're the same now)
        if "category" in update_dict and hasattr(update_dict["category"], "value"):
            update_dict["category"] = update_dict["category"].value
        
        return self.incident_repo.update(incident, update_dict)
    
    def update_investigation_status(
        self, 
        incident_id: int, 
        status_data: InvestigationStatusUpdate,
        current_user: User
    ) -> Incident:
        """Update incident investigation status."""
        incident = self.incident_repo.get(incident_id)
        if not incident:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Incident not found"
            )
        
        # Only safety_officer or admin can update investigation status
        allowed_roles = ["admin", "safety_officer"]
        if current_user.role not in allowed_roles:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only Safety Officer or Admin can update investigation status"
            )
        
        return self.incident_repo.update_investigation_status(
            incident_id, 
            status_data.investigation_status.value,
            status_data.investigation_notes
        )
    
    def delete_incident(self, incident_id: int, current_user: User) -> bool:
        """Delete incident."""
        incident = self.incident_repo.get(incident_id)
        if not incident:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Incident not found"
            )
        
        # Only admin can delete
        if current_user.role != "admin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only admin can delete incidents"
            )
        
        return self.incident_repo.delete(incident_id)
    
    def search_incidents(self, query: str, skip: int = 0, limit: int = 100) -> List[Incident]:
        """Search incidents."""
        return self.incident_repo.search_incidents(query, skip, limit)
