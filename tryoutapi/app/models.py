from sqlalchemy import Column, Integer, String, Boolean, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from .database import Base
from datetime import datetime

class TestType(Base):
    __tablename__ = "test_types"
    # Gunakan primary_key (huruf kecil)
    id = Column(Integer, primary_key=True)
    test_name = Column(String(100), nullable=False)
    is_active = Column(Boolean, default=True)

    sessions = relationship("MasterSession", back_populates="test_type")

class MasterSession(Base):
    __tablename__ = "master_sessions"
    id = Column(Integer, primary_key=True)
    test_type_id = Column(Integer, ForeignKey("test_types.id"))
    session_order = Column(Integer, nullable=False)
    session_name = Column(String(100))
    duration = Column(Integer, default=30)

    test_type = relationship("TestType", back_populates="sessions")
    details = relationship("SessionDetail", back_populates="session")

class SessionDetail(Base):
    __tablename__ = "session_details"
    id = Column(Integer, primary_key=True)
    session_id = Column(Integer, ForeignKey("master_sessions.id"))
    image_name = Column(String(255), nullable=False)
    label = Column(String(1), nullable=False)

    session = relationship("MasterSession", back_populates="details")

# Tambahkan juga untuk tabel log jika sudah kamu masukkan
class TestLog(Base):
    __tablename__ = "test_logs"
    id = Column(Integer, primary_key=True)
    username = Column(String(100), nullable=False)
    test_type_id = Column(Integer, ForeignKey("test_types.id"))
    total_correct = Column(Integer, nullable=False)
    total_wrong = Column(Integer, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)

    details = relationship("TestLogDetail", back_populates="log")

class TestLogDetail(Base):
    __tablename__ = "test_log_details"
    id = Column(Integer, primary_key=True)
    log_id = Column(Integer, ForeignKey("test_logs.id"))
    session_id = Column(Integer, ForeignKey("master_sessions.id"))
    correct = Column(Integer, nullable=False)
    wrong = Column(Integer, nullable=False)

    log = relationship("TestLog", back_populates="details")
