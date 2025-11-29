from typing import Optional, List
from sqlalchemy.orm import Session

from app.models.permit import Permit
from app.repositories.base_repository import BaseRepository


class PermitRepository(BaseRepository[Permit]):
    """Repository for Permit operations."""
    
    def __init__(self, db: Session):
        super().__init__(Permit, db)
    
    def get_by_user(self, user_id: int, skip: int = 0, limit: int = 100) -> List[Permit]:
        """Get all permits by user."""
        return self.db.query(Permit).filter(
            Permit.user_id == user_id
        ).order_by(Permit.created_at.desc()).offset(skip).limit(limit).all()
    
    def count_by_user(self, user_id: int) -> int:
        """Count permits by user."""
        return self.db.query(Permit).filter(Permit.user_id == user_id).count()
    
    def get_by_type(self, permit_type: str, skip: int = 0, limit: int = 100) -> List[Permit]:
        """Get permits by type."""
        return self.db.query(Permit).filter(
            Permit.permit_type == permit_type
        ).order_by(Permit.created_at.desc()).offset(skip).limit(limit).all()
    
    def count_by_type(self, permit_type: str) -> int:
        """Count permits by type."""
        return self.db.query(Permit).filter(Permit.permit_type == permit_type).count()
    
    def get_by_approval_status(self, status: str, skip: int = 0, limit: int = 100) -> List[Permit]:
        """Get permits by approval status."""
        return self.db.query(Permit).filter(
            Permit.approval_status == status
        ).order_by(Permit.created_at.desc()).offset(skip).limit(limit).all()
    
    def count_by_approval_status(self, status: str) -> int:
        """Count permits by approval status."""
        return self.db.query(Permit).filter(Permit.approval_status == status).count()
    
    def get_pending_permits(self, skip: int = 0, limit: int = 100) -> List[Permit]:
        """Get all pending permits."""
        return self.db.query(Permit).filter(
            Permit.approval_status == "pending"
        ).order_by(Permit.created_at.desc()).offset(skip).limit(limit).all()
    
    def count_pending_permits(self) -> int:
        """Count pending permits."""
        return self.db.query(Permit).filter(Permit.approval_status == "pending").count()
    
    def get_all_sorted(self, skip: int = 0, limit: int = 100) -> List[Permit]:
        """Get all permits sorted by newest first."""
        return self.db.query(Permit).order_by(
            Permit.created_at.desc()
        ).offset(skip).limit(limit).all()
    
    def approve_permit(
        self, 
        permit_id: int, 
        approved_by: int, 
        notes: Optional[str] = None
    ) -> Optional[Permit]:
        """Approve permit."""
        permit = self.get(permit_id)
        if permit:
            permit.approval_status = "approved"
            permit.approved_by = approved_by
            if notes:
                permit.approval_notes = notes
            self.db.commit()
            self.db.refresh(permit)
        return permit
    
    def reject_permit(
        self, 
        permit_id: int, 
        rejected_by: int, 
        notes: Optional[str] = None
    ) -> Optional[Permit]:
        """Reject permit."""
        permit = self.get(permit_id)
        if permit:
            permit.approval_status = "rejected"
            permit.approved_by = rejected_by
            if notes:
                permit.approval_notes = notes
            self.db.commit()
            self.db.refresh(permit)
        return permit
