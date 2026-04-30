from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.ext.asyncio import AsyncSession

# PASTIKAN BARIS INI LENGKAP
from . import crud, database, schemas, models
from sqlalchemy.future import select

app = FastAPI(title="Psikotes API Advance")

origins = [
    "http://localhost:5173",
    "http://127.0.0.1:5173",
    "http://localhost:3000", # Jika pakai port lama
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # Untuk development, pakai ["*"] agar semua dizinkan
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/api/test-info/{test_type_id}")
async def get_test_info(test_type_id: int, db: AsyncSession = Depends(database.get_db)):
    try:
        result = await db.execute(
            select(models.MasterSession).where(models.MasterSession.test_type_id == test_type_id)
        )
        sessions = result.scalars().all()

        return {
            "total_sessions": len(sessions),
            "test_name": "Tes Kecermatan",
            "session_ids": [s.session_order for s in sessions]
        }

    except Exception as e:
        import traceback
        traceback.print_exc()
        return {"error": str(e)}

@app.get("/api/session-data/{order}")
async def read_session(order: int, db: AsyncSession = Depends(database.get_db)):
    db_session = await crud.get_test_session_data(db, session_order=order)
    if db_session is None:
        raise HTTPException(status_code=404, detail="Sesi tidak ditemukan")

    return {
        "session_id": db_session.id,
        "name": db_session.session_name,
        "duration": db_session.duration,
        "key_box": [{"id": d.label, "img": d.image_name} for d in db_session.details]
    }

@app.post("/api/save-result")
async def save_result(payload: schemas.TestLogCreate, db: AsyncSession = Depends(database.get_db)):
    # Sekarang 'schemas' sudah didefinisikan karena sudah di-import di atas
    try:
        result = await crud.create_test_log(db, payload)
        return {"status": "success", "log_id": result.id}
    except Exception as e:
        print(f"Error saving result: {e}") # Tambahkan print untuk debug
        raise HTTPException(status_code=500, detail=str(e))
