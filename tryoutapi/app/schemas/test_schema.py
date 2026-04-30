from pydantic import BaseModel
from typing import List

class GridResponse(BaseModel):
    grid: List[List[str]]
    target: str
