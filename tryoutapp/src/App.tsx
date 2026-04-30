import { useState } from 'react';
import Dashboard from './components/Dashboard';
import TestScene from './components/TestScene';
import './App.css';

function App() {
  const [currentPage, setCurrentPage] = useState<'dashboard' | 'test'>('dashboard');

  return (
    <div className="test-container">
      {currentPage === 'dashboard' ? (
        <Dashboard onStart={() => setCurrentPage('test')} />
      ) : (
        <TestScene onRestart={() => setCurrentPage('dashboard')} />
      )}
    </div>
  );
}

export default App;
