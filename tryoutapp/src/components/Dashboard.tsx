import React from 'react';

interface DashboardProps {
  onStart: () => void;
}

const Dashboard: React.FC<DashboardProps> = ({ onStart }) => {
  return (
    <div className="welcome-screen">
      <h1>Simulasi Tes Kecermatan</h1>
      <p>Temukan simbol yang hilang dari kotak kunci dalam waktu 60 detik.</p>
      <div className="instruction-box">
        <small>Instruksi: Pilih abjad (A-E) yang mewakili gambar yang TIDAK muncul di baris soal.</small>
      </div>
      <button className="btn-start" onClick={onStart}>MULAI TES SEKARANG</button>
    </div>
  );
};

export default Dashboard;
