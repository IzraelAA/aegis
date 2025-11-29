from typing import Optional, List
from sqlalchemy.orm import Session

from app.models.incident import Incident
from app.repositories.base_repository import BaseRepository


class IncidentRepository(BaseRepository[Incident]):
    """Repository for Incident operations."""
    
    def __init__(self, db: Session):
        super().__init__(Incident, db)
    
    def get_by_user(self, user_id: int, skip: int = 0, limit: int = 100) -> List[Incident]:
        """Get all incidents by user."""
        return self.db.query(Incident).filter(
            Incident.user_id == user_id
        ).order_by(Incident.created_at.desc()).offset(skip).limit(limit).all()
    
    def count_by_user(self, user_id: int) -> int:
        """Count incidents by user."""
        return self.db.query(Incident).filter(Incident.user_id == user_id).count()
    
    def get_by_category(self, category: str, skip: int = 0, limit: int = 100) -> List[Incident]:
        """Get incidents by category."""
        return self.db.query(Incident).filter(
            Incident.category == category
        ).order_by(Incident.created_at.desc()).offset(skip).limit(limit).all()
    
    def count_by_category(self, category: str) -> int:
        """Count incidents by category."""
        return self.db.query(Incident).filter(Incident.category == category).count()
    
    def get_by_investigation_status(self, status: str, skip: int = 0, limit: int = 100) -> List[Incident]:
        """Get incidents by investigation status."""
        return self.db.query(Incident).filter(
            Incident.investigation_status == status
        ).order_by(Incident.created_at.desc()).offset(skip).limit(limit).all()
    
    def count_by_investigation_status(self, status: str) -> int:
        """Count incidents by investigation status."""
        return self.db.query(Incident).filter(Incident.investigation_status == status).count()
    
    def get_by_location(self, location: str, skip: int = 0, limit: int = 100) -> List[Incident]:
        """Get incidents by location."""
        search_filter = f"%{location}%"
        return self.db.query(Incident).filter(
            Incident.location.ilike(search_filter)
        ).order_by(Incident.created_at.desc()).offset(skip).limit(limit).all()
    
    def get_all_sorted(self, skip: int = 0, limit: int = 100) -> List[Incident]:
        """Get all incidents sorted by newest first."""
        return self.db.query(Incident).order_by(
            Incident.created_at.desc()
        ).offset(skip).limit(limit).all()
    
    def update_investigation_status(
        self, 
        incident_id: int, 
        status: str, 
        notes: Optional[str] = None
    ) -> Optional[Incident]:
        """Update incident investigation status."""
        incident = self.get(incident_id)
        if incident:
            incident.investigation_status = status
            if notes:
                incident.investigation_notes = notes
            self.db.commit()
            self.db.refresh(incident)
        return incident
    
    def search_incidents(self, query: str, skip: int = 0, limit: int = 100) -> List[Incident]:
        """Search incidents by title or description."""
        search_filter = f"%{query}%"
        return self.db.query(Incident).filter(
            (Incident.title.ilike(search_filter)) |
            (Incident.description.ilike(search_filter))
        ).order_by(Incident.created_at.desc()).offset(skip).limit(limit).all()
