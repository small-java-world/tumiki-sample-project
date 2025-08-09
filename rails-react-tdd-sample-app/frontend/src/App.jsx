import React, { useEffect, useState } from 'react';
import './App.css';

function App() {
  const [now, setNow] = useState(new Date());
  const [apiHealth, setApiHealth] = useState(null);
  const [isChecking, setIsChecking] = useState(false);
  const [checkError, setCheckError] = useState(null);

  useEffect(() => {
    const timerId = setInterval(() => setNow(new Date()), 1000);
    return () => clearInterval(timerId);
  }, []);

  const handleCheckHealth = async () => {
    try {
      setIsChecking(true);
      setCheckError(null);
      setApiHealth(null);
      const response = await fetch('/health');
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }
      const json = await response.json();
      setApiHealth(json);
    } catch (error) {
      setCheckError(String(error));
    } finally {
      setIsChecking(false);
    }
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>railsとreactのtddの題材のサンプルアプリ Frontend</h1>
        <p>Rails + React + MySQL + MinIO + moto（Cognito代替）</p>
        <div style={{ marginTop: '1rem', fontSize: '1.1rem' }}>
          <span>System time: </span>
          <strong>{now.toLocaleString()}</strong>
        </div>
        <div style={{ marginTop: '1.25rem' }}>
          <button onClick={handleCheckHealth} disabled={isChecking}>
            {isChecking ? 'Checking…' : 'Check API Health'}
          </button>
          <div style={{ marginTop: '0.75rem', textAlign: 'left', maxWidth: 600 }}>
            {checkError && (
              <div role="alert" style={{ color: '#ff6b6b' }}>
                Error: {checkError}
              </div>
            )}
            {apiHealth && (
              <pre aria-label="api-health-json" style={{ background: '#111', padding: '0.75rem', borderRadius: 6 }}>
                {JSON.stringify(apiHealth, null, 2)}
              </pre>
            )}
          </div>
        </div>
      </header>
    </div>
  );
}

export default App;
