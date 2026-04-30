from pydantic import BaseModel
from typing import List

class LogDetailCreate(BaseModel):
    session_id: int
    correct: int
    wrong: int

class TestLogCreate(BaseModel):
    username: str
    test_type_id: int
    total_correct: int
    total_wrong: int
    details: List[LogDetailCreate]
