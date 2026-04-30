from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession
# TAMBAHKAN BARIS INI
from . import models, schemas

# --- Logika Query Sesi (Sudah ada sebelumnya) ---
async def get_test_session_data(db: AsyncSession, session_order: int, test_type_id: int = 1):
    result = await db.execute(
        select(models.MasterSession)
        .options(selectinload(models.MasterSession.details))
        .where(
            models.MasterSession.test_type_id == test_type_id,
            models.MasterSession.session_order == session_order
        )
    )
    return result.scalar_one_or_none()

# --- Logika Simpan Log ---
async def create_test_log(db: AsyncSession, log_data: schemas.TestLogCreate):
    # Sekarang schemas.TestLogCreate sudah bisa dikenali
    new_log = models.TestLog(
        username=log_data.username,
        test_type_id=log_data.test_type_id,
        total_correct=log_data.total_correct,
        total_wrong=log_data.total_wrong
    )
    db.add(new_log)
    await db.flush()

    for detail in log_data.details:
        new_detail = models.TestLogDetail(
            log_id=new_log.id,
            session_id=detail.session_id,
            correct=detail.correct,
            wrong=detail.wrong
        )
        db.add(new_detail)

    await db.commit()
    await db.refresh(new_log)
    return new_log
