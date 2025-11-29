from typing import List, Optional
from sqlalchemy.orm import Session
from fastapi import HTTPException, status

from app.models.inspection import Inspection
from app.models.user import User
from app.repositories.inspection_repository import InspectionRepository
from app.schemas.inspection import InspectionCreate, InspectionUpdate, InspectionStatusUpdate


class InspectionService:
    """Service for Inspection operations."""
    
    def __init__(self, db: Session):
        self.db = db
        self.inspection_repo = InspectionRepository(db)
    
    def create_inspection(self, inspection_data: InspectionCreate, user_id: int) -> Inspection:
        """Create a new inspection."""
        inspection_dict = {
            "user_id": user_id,
            "location": inspection_data.location,
            "category": inspection_data.category,
            "description": inspection_data.description,
            "photo": inspection_data.photo,
            "status": inspection_data.status.value
        }
        return self.inspection_repo.create(inspection_dict)
    
    def get_inspection(self, inspection_id: int) -> Inspection:
        """Get inspection by ID."""
        inspection = self.inspection_repo.get(inspection_id)
        if not inspection:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Inspection not found"
            )
        return inspection
    
    def get_all_inspections(self, skip: int = 0, limit: int = 100) -> List[Inspection]:
        """Get all inspections."""
        return self.inspection_repo.get_all_sorted(skip, limit)
    
    def get_inspections_count(self) -> int:
        """Get total inspections count."""
        return self.inspection_repo.count()
    
    def get_inspections_by_user(self, user_id: int, skip: int = 0, limit: int = 100) -> List[Inspection]:
        """Get inspections by user."""
        return self.inspection_repo.get_by_user(user_id, skip, limit)
    
    def count_inspections_by_user(self, user_id: int) -> int:
        """Count inspections by user."""
        return self.inspection_repo.count_by_user(user_id)
    
    def get_inspections_by_status(self, status: str, skip: int = 0, limit: int = 100) -> List[Inspection]:
        """Get inspections by status."""
        return self.inspection_repo.get_by_status(status, skip, limit)
    
    def get_inspections_by_category(self, category: str, skip: int = 0, limit: int = 100) -> List[Inspection]:
        """Get inspections by category."""
        return self.inspection_repo.get_by_category(category, skip, limit)
    
    def update_inspection(
        self, 
        inspection_id: int, 
        inspection_data: InspectionUpdate, 
        current_user: User
    ) -> Inspection:
        """Update inspection."""
        inspection = self.inspection_repo.get(inspection_id)
        if not inspection:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Inspection not found"
            )
        
        # Only owner or admin/safety_officer can update
        allowed_roles = ["admin", "safety_officer", "supervisor"]
        if current_user.id != inspection.user_id and current_user.role not in allowed_roles:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You don't have permission to update this inspection"
            )
        
        update_dict = inspection_data.model_dump(exclude_unset=True)
        # Map schema field names to model field names (they're the same now)
        if "status" in update_dict and hasattr(update_dict["status"], "value"):
            update_dict["status"] = update_dict["status"].value
        
        return self.inspection_repo.update(inspection, update_dict)
    
    def update_inspection_status(
        self, 
        inspection_id: int, 
        status_data: InspectionStatusUpdate,
        current_user: User
    ) -> Inspection:
        """Update inspection status."""
        inspection = self.inspection_repo.get(inspection_id)
        if not inspection:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Inspection not found"
            )
        
        # Only supervisor, safety_officer, or admin can update status
        allowed_roles = ["admin", "safety_officer", "supervisor"]
        if current_user.role not in allowed_roles:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You don't have permission to update inspection status"
            )
        
        return self.inspection_repo.update_status(inspection_id, status_data.status.value)
    
    def delete_inspection(self, inspection_id: int, current_user: User) -> bool:
        """Delete inspection."""
        inspection = self.inspection_repo.get(inspection_id)
        if not inspection:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Inspection not found"
            )
        
        # Only admin can delete
        if current_user.role != "admin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only admin can delete inspections"
            )
        
        return self.inspection_repo.delete(inspection_id)
