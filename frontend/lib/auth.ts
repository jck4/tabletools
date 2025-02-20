import { getAuth, signInWithEmailAndPassword, signOut } from 'firebase/auth';
import { app } from '../config/firebase';
import AsyncStorage from '@react-native-async-storage/async-storage';

const auth = getAuth(app);

/**
 * Signs in using email and password.
 * Returns the Firebase ID token if successful.
 */
export const loginWithEmail = async (email: string, password: string): Promise<string | null> => {
  const userCredential = await signInWithEmailAndPassword(auth, email, password);
  const idToken = await userCredential.user.getIdToken();
  if (idToken) {
    await AsyncStorage.setItem('userToken', idToken);
  }
  return idToken;
};

/**
 * Logs out the user.
 */
export const logoutUser = async (): Promise<void> => {
  await signOut(auth);
  await AsyncStorage.removeItem('userToken');
};
