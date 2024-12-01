import React from 'react';
import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';

const firebaseConfig = {
  // Your Firebase config will go here
};

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <h1>Firebase CMS</h1>
      </header>
    </div>
  );
}

export default App;
