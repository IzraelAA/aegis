from typing import Optional, List
from sqlalchemy.orm import Session

from app.models.inspection import Inspection
from app.repositories.base_repository import BaseRepository


class InspectionRepository(BaseRepository[Inspection]):
    """Repository for Inspection operations."""
    
    def __init__(self, db: Session):
        super().__init__(Inspection, db)
    
    def get_by_user(self, user_id: int, skip: int = 0, limit: int = 100) -> List[Inspection]:
        """Get all inspections by user."""
        return self.db.query(Inspection).filter(
            Inspection.user_id == user_id
        ).order_by(Inspection.created_at.desc()).offset(skip).limit(limit).all()
    
    def count_by_user(self, user_id: int) -> int:
        """Count inspections by user."""
        return self.db.query(Inspection).filter(Inspection.user_id == user_id).count()
    
    def get_by_status(self, status: str, skip: int = 0, limit: int = 100) -> List[Inspection]:
        """Get inspections by status."""
        return self.db.query(Inspection).filter(
            Inspection.status == status
        ).order_by(Inspection.created_at.desc()).offset(skip).limit(limit).all()
    
    def count_by_status(self, status: str) -> int:
        """Count inspections by status."""
        return self.db.query(Inspection).filter(Inspection.status == status).count()
    
    def get_by_category(self, category: str, skip: int = 0, limit: int = 100) -> List[Inspection]:
        """Get inspections by category."""
        return self.db.query(Inspection).filter(
            Inspection.category == category
        ).order_by(Inspection.created_at.desc()).offset(skip).limit(limit).all()
    
    def get_by_location(self, location: str, skip: int = 0, limit: int = 100) -> List[Inspection]:
        """Get inspections by location."""
        search_filter = f"%{location}%"
        return self.db.query(Inspection).filter(
            Inspection.location.ilike(search_filter)
        ).order_by(Inspection.created_at.desc()).offset(skip).limit(limit).all()
    
    def get_all_sorted(self, skip: int = 0, limit: int = 100) -> List[Inspection]:
        """Get all inspections sorted by newest first."""
        return self.db.query(Inspection).order_by(
            Inspection.created_at.desc()
        ).offset(skip).limit(limit).all()
    
    def update_status(self, inspection_id: int, status: str) -> Optional[Inspection]:
        """Update inspection status."""
        inspection = self.get(inspection_id)
        if inspection:
            inspection.status = status
            self.db.commit()
            self.db.refresh(inspection)
        return inspection
