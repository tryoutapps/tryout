import React, { useState, useEffect, useRef } from 'react';
import { API_ENDPOINTS } from '../config';

const TestScene: React.FC<{ onRestart: () => void }> = ({ onRestart }) => {
  const [session, setSession] = useState(1);
  const [keyBox, setKeyBox] = useState<any[]>([]);
  const [questionItems, setQuestionItems] = useState<any[]>([]);
  const [correctAnswer, setCorrectAnswer] = useState("");

  const [currentSessionCorrect, setCurrentSessionCorrect] = useState(0);
  const [currentSessionWrong, setCurrentSessionWrong] = useState(0);
  const [score, setScore] = useState(0);
  const [wrong, setWrong] = useState(0);
  const [isReady, setIsReady] = useState(false);
  const [sessionResults, setSessionResults] = useState<any[]>([]);

  const [timeLeft, setTimeLeft] = useState(5);
  const [isBreak, setIsBreak] = useState(false);
  const [isFinished, setIsFinished] = useState(false);

  const [totalSessions, setTotalSessions] = useState(0);
  const [isLoading, setIsLoading] = useState(true);

  // Ref untuk mengunci proses agar tidak duplikat
  const isFetching = useRef(false);
  // Ref untuk mencatat sesi mana yang sedang ditampilkan agar tidak double fetch
  const activeSessionRef = useRef(0);

  // 1. Ambil Info Total Sesi
  useEffect(() => {
    const getTestInfo = async () => {
      try {
        const res = await fetch(API_ENDPOINTS.TEST_INFO(1));
        const data = await res.json();
        setTotalSessions(data.total_sessions);
        setIsLoading(false);
      } catch (e) {
        console.error("Gagal mengambil info tes:", e);
      }
    };
    getTestInfo();
  }, []);

  const preloadImages = (items: any[]) => {
    items.forEach((item) => {
      const img = new Image();
      img.src = `/assets/${item.img}`;
    });
  };

  const fetchSessionData = async (sId: number) => {
    // JANGAN fetch jika sedang fetch atau sesi ini sudah aktif
    if (isFetching.current || activeSessionRef.current === sId) return;

    isFetching.current = true;
    setIsReady(false);

    try {
      const res = await fetch(API_ENDPOINTS.SESSION_DATA(sId));
      const data = await res.json();

      preloadImages(data.key_box);

      // Beri sedikit delay agar transisi mulus
      setTimeout(() => {
        setKeyBox(data.key_box);
        generateQuestion(data.key_box);
        setTimeLeft(data.duration);

        activeSessionRef.current = sId; // Tandai sesi ini sudah sukses dimuat
        setIsReady(true);
        isFetching.current = false;
      }, 500);

    } catch (e) {
      console.error("Error fetch:", e);
      isFetching.current = false;
    }
  };

  const generateQuestion = (currentKeys: any[]) => {
    if (currentKeys.length === 0) return;
    const missing = currentKeys[Math.floor(Math.random() * currentKeys.length)];
    const others = currentKeys.filter(k => k.id !== missing.id);
    setQuestionItems(others.sort(() => Math.random() - 0.5));
    setCorrectAnswer(missing.id);
  };

  // Effect Fetch Data: Hanya jalan jika sesi berubah dan TIDAK sedang istirahat
  useEffect(() => {
    if (!isFinished && !isBreak && totalSessions > 0 && session <= totalSessions) {
      fetchSessionData(session);
    }
  }, [session, isFinished, isBreak, totalSessions]);

  // 2. Logika Timer
  useEffect(() => {
    let timer: ReturnType<typeof setTimeout>;
    if (timeLeft > 0 && isReady && !isBreak && !isFinished) {
      timer = setTimeout(() => setTimeLeft(prev => prev - 1), 1000);
    } else if (timeLeft === 0 && isReady && !isFinished && !isBreak) {
      // Tambahkan syarat isReady agar tidak trigger saat loading
      handleEndOfSession();
    }
    return () => clearTimeout(timer);
  }, [timeLeft, isBreak, isFinished, isReady]);

  // 3. Logika Menjawab
  const handleAnswer = (letter: string) => {
    if (!isReady || isBreak || isFinished) return;

    if (letter === correctAnswer) {
      setScore(prev => prev + 1);
      setCurrentSessionCorrect(prev => prev + 1);
    } else {
      setWrong(prev => prev + 1);
      setCurrentSessionWrong(prev => prev + 1);
    }
    generateQuestion(keyBox);
  };

  const handleEndOfSession = () => {
    if (isBreak || isFinished) return;

    setIsBreak(true);
    setIsReady(false);

    // Simpan hasil sesi ke state results
    const resultData = {
      session: session, // Pastikan key sesuai dengan yang dirender di table
      correct: currentSessionCorrect,
      wrong: currentSessionWrong
    };
    setSessionResults(prev => [...prev, resultData]);

    if (session < totalSessions) {
      setTimeout(() => {
        setCurrentSessionCorrect(0);
        setCurrentSessionWrong(0);
        setSession(prev => prev + 1);
        setIsBreak(false); // Sesi baru akan di-fetch oleh useEffect
      }, 3000);
    } else {
      setIsFinished(true);
      saveFinalResult();
    }
  };

  const saveFinalResult = async () => {
    // Ambil data terbaru karena state mungkin belum update sempurna saat fungsi dipanggil
    const payload = {
      username: "Lamhot",
      test_type_id: 1,
      total_correct: score,
      total_wrong: wrong,
      details: [...sessionResults, {
        session_id: session,
        correct: currentSessionCorrect,
        wrong: currentSessionWrong
      }]
    };

    try {
      await fetch(API_ENDPOINTS.SAVE_RESULT, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });
    } catch (e) {
      console.error("Gagal simpan hasil:", e);
    }
  };

  if (isLoading) return <div className="loading">Memuat Data Tes...</div>;

  if (isFinished) {
    return (
      <div className="test-container">
        <div className="result-card">
          <h2>Laporan Hasil Tes</h2>
          <table className="result-table">
            <thead>
              <tr>
                <th>Sesi</th>
                <th>Benar</th>
                <th>Salah</th>
              </tr>
            </thead>
            <tbody>
              {sessionResults.map((res, idx) => (
                <tr key={idx}>
                  <td>Sesi {res.session}</td>
                  <td className="res-correct">{res.correct}</td>
                  <td className="res-wrong">{res.wrong}</td>
                </tr>
              ))}
            </tbody>
          </table>
          <div className="total-summary">
            <h3>Total Benar: {score}</h3>
            <h3>Total Salah: {wrong}</h3>
          </div>
          <button className="btn-restart" onClick={onRestart}>Selesai</button>
        </div>
      </div>
    );
  }

  return (
    <div className="test-container">
      <div className="header-timer">
        <h2 style={{ fontSize: '1.5rem', color: '#333' }}>
          Sesi {session} <span style={{ color: '#888', fontSize: '1rem' }}>dari {totalSessions}</span>
        </h2>
        <div className={`timer-box ${timeLeft <= 5 ? 'warning' : ''}`}>
          {isBreak ? "SIAP-SIAP..." : !isReady ? "LOADING..." : `00:${timeLeft < 10 ? '0' + timeLeft : timeLeft}`}
        </div>
      </div>

      {isBreak ? (
        <div className="break-overlay">
          <div className="loader"></div>
          <h2>Sesi {session} Selesai</h2>
          <p>Mohon tunggu sesi berikutnya...</p>
        </div>
      ) : (
        <>
          <div className="key-section">
            {keyBox.map(item => (
              <div key={item.id} className="key-item">
                <img src={`/assets/${item.img}`} alt={item.id} />
                <div className="label">{item.id}</div>
              </div>
            ))}
          </div>

          <div className="question-grid">
            {questionItems.map((item, idx) => (
              <div key={idx} className="question-item">
                <img src={`/assets/${item.img}`} alt="target" />
              </div>
            ))}
          </div>

          <div className="answer-section">
            {['A', 'B', 'C', 'D', 'E'].map(l => (
              <button
                key={l}
                onClick={() => handleAnswer(l)}
                className="btn-answer"
                disabled={!isReady}
              >{l}</button>
            ))}
          </div>
        </>
      )}
    </div>
  );
};

export default TestScene;
