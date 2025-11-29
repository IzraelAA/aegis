from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import settings
from app.routers import auth_router, user_router, inspection_router, incident_router, permit_router

# Create FastAPI application
app = FastAPI(
    title=settings.APP_NAME,
    description="""
    ## AEGIS K3 API - Occupational Health & Safety Management System
    
    This API provides endpoints for managing:
    
    * **Authentication** - User registration, login, and token refresh
    * **Users** - User management with role-based access control
    * **Inspections** - Safety inspection reports
    * **Incidents** - Incident reporting and investigation tracking
    * **Permits (PTW)** - Permit to Work management with approval workflow
    
    ### Roles
    
    * `user` - Basic access, can create reports
    * `supervisor` - Can approve permits and update inspection status
    * `safety_officer` - Full access to incidents and investigations
    * `admin` - Full system access
    
    ### Authentication
    
    All endpoints (except register and login) require JWT Bearer token authentication.
    """,
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_url="/openapi.json"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure appropriately for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth_router.router, prefix="/api/v1")
app.include_router(user_router.router, prefix="/api/v1")
app.include_router(inspection_router.router, prefix="/api/v1")
app.include_router(incident_router.router, prefix="/api/v1")
app.include_router(permit_router.router, prefix="/api/v1")


@app.get("/", tags=["Root"])
def root():
    """
    Root endpoint - API health check.
    """
    return {
        "message": "Welcome to AEGIS K3 API",
        "version": "1.0.0",
        "docs": "/docs",
        "health": "ok"
    }


@app.get("/health", tags=["Health"])
def health_check():
    """
    Health check endpoint for monitoring.
    """
    return {"status": "healthy"}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)

