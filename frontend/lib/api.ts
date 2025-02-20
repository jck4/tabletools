import axios from "axios";
import AsyncStorage from '@react-native-async-storage/async-storage';
import { getAuth, signOut } from 'firebase/auth';
import { app } from '../config/firebase';
import { API_BASE_URL } from "../config";

// Create an Axios instance for reuse
export const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    "Content-Type": "application/json",
    Accept: "application/json",
  },
});

// Generic function to fetch generator data
export const getGeneratorData = async (generatorType) => {
  try {
    const response = await api.post(`/generator/generate_${generatorType}`);
    return response.data;
  } catch (error) {
    console.error(`Error fetching ${generatorType}:`, error);
    throw error;
  }
};

// Convenience wrappers if you want named functions:
export const getEncounter = () => getGeneratorData('encounter');
export const getTrap = () => getGeneratorData('trap');
export const getNpc = () => getGeneratorData('npc');
export const getTreasure = () => getGeneratorData('treasure');
export const getQuest = () => getGeneratorData('quest');

// Request Interceptor to attach token to each request
api.interceptors.request.use(
  async (config) => {
    const token = await AsyncStorage.getItem("userToken");
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Logout function to sign out the user and remove token from storage
export const logoutUser = async () => {
  try {
    const auth = getAuth(app);
    await signOut(auth);
  } catch (error) {
    console.error("Error signing out:", error);
  }
  await AsyncStorage.removeItem("userToken");
  // Optionally, add navigation logic here to redirect the user to your login screen.
};

// Response Interceptor to handle 401 errors
api.interceptors.response.use(
  (response) => response,
  async (error) => {
    if (error.response?.status === 401) {
      await logoutUser();
      // Optionally, navigate to the login screen here.
    }
    return Promise.reject(error);
  }
);
