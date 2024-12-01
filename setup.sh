#!/bin/bash

# Create base directories
mkdir -p functions/src/{auth,storage,processing,api}
mkdir -p web/src/{components,hooks,utils,services}
mkdir -p scripts/{migration,setup}
mkdir -p config

# Create initial configuration files
cat > config/firebase.json << 'EOL'
{
  "firestore": {
    "rules": "config/firestore.rules",
    "indexes": "config/firestore.indexes.json"
  },
  "storage": {
    "rules": "config/storage.rules"
  },
  "functions": {
    "source": "functions"
  },
  "hosting": {
    "public": "web/build",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ]
  }
}
EOL

cat > config/firestore.rules << 'EOL'
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
EOL

cat > config/storage.rules << 'EOL'
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
EOL

# Create functions files
cat > functions/src/index.ts << 'EOL'
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

export * from './auth';
export * from './storage';
export * from './processing';
export * from './api';
EOL

cat > functions/src/auth/index.ts << 'EOL'
import * as functions from 'firebase-functions';

export const onUserCreated = functions.auth.user().onCreate(async (user) => {
  // Handle new user creation
  console.log('New user created:', user.uid);
});
EOL

cat > functions/src/storage/index.ts << 'EOL'
import * as functions from 'firebase-functions';

export const onFileUploaded = functions.storage.object().onFinalize(async (object) => {
  // Handle file upload
  console.log('File uploaded:', object.name);
});
EOL

# Create web application files
cat > web/src/index.tsx << 'EOL'
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './components/App';
import './index.css';

const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);

root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOL

cat > web/src/components/App.tsx << 'EOL'
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
EOL

cat > web/src/services/firebase.ts << 'EOL'
import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';
import { getStorage } from 'firebase/storage';

const firebaseConfig = {
  // Your Firebase config will go here
};

const app = initializeApp(firebaseConfig);

export const auth = getAuth(app);
export const db = getFirestore(app);
export const storage = getStorage(app);
EOL

# Create package.json files
cat > functions/package.json << 'EOL'
{
  "name": "functions",
  "version": "1.0.0",
  "description": "Firebase CMS Functions",
  "main": "lib/index.js",
  "scripts": {
    "build": "tsc",
    "serve": "npm run build && firebase emulators:start --only functions",
    "shell": "npm run build && firebase functions:shell",
    "start": "npm run shell",
    "deploy": "firebase deploy --only functions",
    "logs": "firebase functions:log",
    "test": "jest"
  },
  "dependencies": {
    "firebase-admin": "^11.11.0",
    "firebase-functions": "^4.5.0"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "@types/node": "^18.0.0"
  },
  "private": true
}
EOL

cat > web/package.json << 'EOL'
{
  "name": "web",
  "version": "1.0.0",
  "description": "Firebase CMS Web Interface",
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "firebase": "^10.7.0",
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "react-scripts": "5.0.1"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "@types/node": "^18.0.0"
  }
}
EOL

# Create TypeScript configuration
cat > functions/tsconfig.json << 'EOL'
{
  "compilerOptions": {
    "target": "es2017",
    "module": "commonjs",
    "outDir": "lib",
    "rootDir": "src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true
  },
  "include": ["src"]
}
EOL

cat > web/tsconfig.json << 'EOL'
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noFallthroughCasesInSwitch": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx"
  },
  "include": ["src"]
}
EOL

# Create .gitignore
cat > .gitignore << 'EOL'
# Dependencies
node_modules/
.pnp
.pnp.js

# Testing
coverage/

# Production
build/
dist/
lib/

# Firebase
.firebase/
firebase-debug.log
firestore-debug.log
ui-debug.log

# Environment
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# IDE
.idea/
.vscode/
*.swp
*.swo
.DS_Store

# Logs
npm-debug.log*
yarn-debug.log*
yarn-error.log*
EOL

# Initialize git repository
git init

echo "Project structure and files created successfully!"