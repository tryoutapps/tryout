from fastapi import APIRouter
from app.services.generator import generate_grid
from app.schemas.test_schema import GridResponse

router = APIRouter()

@router.get("/generate", response_model=GridResponse)
def generate():
    grid, target = generate_grid()
    return {
        "grid": grid,
        "target": target
    }
