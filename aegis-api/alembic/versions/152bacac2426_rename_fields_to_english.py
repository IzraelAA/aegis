"""Rename fields to English

Revision ID: 152bacac2426
Revises: 
Create Date: 2025-11-28 14:48:11.803549

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '152bacac2426'
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Rename Inspection table columns
    op.alter_column('inspections', 'lokasi', new_column_name='location')
    op.alter_column('inspections', 'kategori', new_column_name='category')
    op.alter_column('inspections', 'deskripsi', new_column_name='description')
    op.alter_column('inspections', 'foto', new_column_name='photo')
    
    # Update InspectionStatus enum values in database
    # Note: This requires updating existing data
    op.execute("UPDATE inspections SET status = 'safe' WHERE status = 'aman'")
    op.execute("UPDATE inspections SET status = 'unsafe' WHERE status = 'tidak_aman'")
    
    # Rename Incident table columns
    op.alter_column('incidents', 'judul', new_column_name='title')
    op.alter_column('incidents', 'deskripsi', new_column_name='description')
    op.alter_column('incidents', 'kategori', new_column_name='category')
    op.alter_column('incidents', 'foto', new_column_name='photo')
    op.alter_column('incidents', 'lokasi', new_column_name='location')
    op.alter_column('incidents', 'waktu_kejadian', new_column_name='incident_datetime')
    op.alter_column('incidents', 'status_investigasi', new_column_name='investigation_status')
    op.alter_column('incidents', 'catatan_investigasi', new_column_name='investigation_notes')
    
    # Rename Permit table columns
    op.alter_column('permits', 'jenis_permit', new_column_name='permit_type')
    op.alter_column('permits', 'deskripsi', new_column_name='description')
    op.alter_column('permits', 'lokasi', new_column_name='location')
    op.alter_column('permits', 'tanggal_mulai', new_column_name='start_date')
    op.alter_column('permits', 'tanggal_selesai', new_column_name='end_date')


def downgrade() -> None:
    # Revert Permit table columns
    op.alter_column('permits', 'end_date', new_column_name='tanggal_selesai')
    op.alter_column('permits', 'start_date', new_column_name='tanggal_mulai')
    op.alter_column('permits', 'location', new_column_name='lokasi')
    op.alter_column('permits', 'description', new_column_name='deskripsi')
    op.alter_column('permits', 'permit_type', new_column_name='jenis_permit')
    
    # Revert Incident table columns
    op.alter_column('incidents', 'investigation_notes', new_column_name='catatan_investigasi')
    op.alter_column('incidents', 'investigation_status', new_column_name='status_investigasi')
    op.alter_column('incidents', 'incident_datetime', new_column_name='waktu_kejadian')
    op.alter_column('incidents', 'location', new_column_name='lokasi')
    op.alter_column('incidents', 'photo', new_column_name='foto')
    op.alter_column('incidents', 'category', new_column_name='kategori')
    op.alter_column('incidents', 'description', new_column_name='deskripsi')
    op.alter_column('incidents', 'title', new_column_name='judul')
    
    # Revert InspectionStatus enum values
    op.execute("UPDATE inspections SET status = 'aman' WHERE status = 'safe'")
    op.execute("UPDATE inspections SET status = 'tidak_aman' WHERE status = 'unsafe'")
    
    # Revert Inspection table columns
    op.alter_column('inspections', 'photo', new_column_name='foto')
    op.alter_column('inspections', 'description', new_column_name='deskripsi')
    op.alter_column('inspections', 'category', new_column_name='kategori')
    op.alter_column('inspections', 'location', new_column_name='lokasi')

