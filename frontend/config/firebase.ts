import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';

const firebaseConfig = {
  apiKey: "AIzaSyCi8fWPQmm8uRBDotdl0mgR8gguFB9sjnU",
  authDomain: "tabletools-765cd.firebaseapp.com",
};

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);

export { app, auth };