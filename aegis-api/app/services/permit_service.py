from typing import List, Optional
from sqlalchemy.orm import Session
from fastapi import HTTPException, status

from app.models.permit import Permit
from app.models.user import User
from app.repositories.permit_repository import PermitRepository
from app.schemas.permit import PermitCreate, PermitUpdate, PermitApprovalRequest


class PermitService:
    """Service for Permit operations."""
    
    def __init__(self, db: Session):
        self.db = db
        self.permit_repo = PermitRepository(db)
    
    def create_permit(self, permit_data: PermitCreate, user_id: int) -> Permit:
        """Create a new permit."""
        # Validate dates
        if permit_data.start_date >= permit_data.end_date:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Start date must be before end date"
            )
        
        permit_dict = {
            "user_id": user_id,
            "permit_type": permit_data.permit_type.value,
            "description": permit_data.description,
            "location": permit_data.location,
            "start_date": permit_data.start_date,
            "end_date": permit_data.end_date,
            "approval_status": "pending"
        }
        return self.permit_repo.create(permit_dict)
    
    def get_permit(self, permit_id: int) -> Permit:
        """Get permit by ID."""
        permit = self.permit_repo.get(permit_id)
        if not permit:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Permit not found"
            )
        return permit
    
    def get_all_permits(self, skip: int = 0, limit: int = 100) -> List[Permit]:
        """Get all permits."""
        return self.permit_repo.get_all_sorted(skip, limit)
    
    def get_permits_count(self) -> int:
        """Get total permits count."""
        return self.permit_repo.count()
    
    def get_permits_by_user(self, user_id: int, skip: int = 0, limit: int = 100) -> List[Permit]:
        """Get permits by user."""
        return self.permit_repo.get_by_user(user_id, skip, limit)
    
    def count_permits_by_user(self, user_id: int) -> int:
        """Count permits by user."""
        return self.permit_repo.count_by_user(user_id)
    
    def get_permits_by_type(self, permit_type: str, skip: int = 0, limit: int = 100) -> List[Permit]:
        """Get permits by type."""
        return self.permit_repo.get_by_type(permit_type, skip, limit)
    
    def get_permits_by_status(self, status_approval: str, skip: int = 0, limit: int = 100) -> List[Permit]:
        """Get permits by approval status."""
        return self.permit_repo.get_by_approval_status(status_approval, skip, limit)
    
    def get_pending_permits(self, skip: int = 0, limit: int = 100) -> List[Permit]:
        """Get pending permits."""
        return self.permit_repo.get_pending_permits(skip, limit)
    
    def count_pending_permits(self) -> int:
        """Count pending permits."""
        return self.permit_repo.count_pending_permits()
    
    def update_permit(
        self, 
        permit_id: int, 
        permit_data: PermitUpdate, 
        current_user: User
    ) -> Permit:
        """Update permit."""
        permit = self.permit_repo.get(permit_id)
        if not permit:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Permit not found"
            )
        
        # Only owner or admin can update
        if current_user.id != permit.user_id and current_user.role != "admin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You don't have permission to update this permit"
            )
        
        # Cannot update approved/rejected permit
        if permit.approval_status != "pending":
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Cannot update processed permit"
            )
        
        update_dict = permit_data.model_dump(exclude_unset=True)
        # Map schema field names to model field names (they're the same now)
        if "permit_type" in update_dict and hasattr(update_dict["permit_type"], "value"):
            update_dict["permit_type"] = update_dict["permit_type"].value
        
        # Validate dates if updated
        start_date = update_dict.get("start_date", permit.start_date)
        end_date = update_dict.get("end_date", permit.end_date)
        if start_date >= end_date:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Start date must be before end date"
            )
        
        return self.permit_repo.update(permit, update_dict)
    
    def approve_permit(
        self, 
        permit_id: int, 
        approval_data: PermitApprovalRequest,
        current_user: User
    ) -> Permit:
        """Approve permit."""
        permit = self.permit_repo.get(permit_id)
        if not permit:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Permit not found"
            )
        
        # Only supervisor, safety_officer, or admin can approve
        allowed_roles = ["admin", "safety_officer", "supervisor"]
        if current_user.role not in allowed_roles:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You don't have permission to approve permits"
            )
        
        # Cannot approve non-pending permit
        if permit.approval_status != "pending":
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Permit has already been processed"
            )
        
        return self.permit_repo.approve_permit(
            permit_id, 
            current_user.id, 
            approval_data.approval_notes
        )
    
    def reject_permit(
        self, 
        permit_id: int, 
        rejection_data: PermitApprovalRequest,
        current_user: User
    ) -> Permit:
        """Reject permit."""
        permit = self.permit_repo.get(permit_id)
        if not permit:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Permit not found"
            )
        
        # Only supervisor, safety_officer, or admin can reject
        allowed_roles = ["admin", "safety_officer", "supervisor"]
        if current_user.role not in allowed_roles:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You don't have permission to reject permits"
            )
        
        # Cannot reject non-pending permit
        if permit.approval_status != "pending":
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Permit has already been processed"
            )
        
        return self.permit_repo.reject_permit(
            permit_id, 
            current_user.id, 
            rejection_data.approval_notes
        )
    
    def delete_permit(self, permit_id: int, current_user: User) -> bool:
        """Delete permit."""
        permit = self.permit_repo.get(permit_id)
        if not permit:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Permit not found"
            )
        
        # Only admin can delete
        if current_user.role != "admin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only admin can delete permits"
            )
        
        return self.permit_repo.delete(permit_id)
