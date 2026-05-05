// Mengambil URL dari .env, jika tidak ada gunakan fallback localhost
const BASE_URL = import.meta.env.VITE_API_BASE_URL || "http://localhost:8002/api";

export const API_ENDPOINTS = {
  TEST_INFO: (id: number) => `${BASE_URL}/test-info/${id}`,
  SESSION_DATA: (order: number) => `${BASE_URL}/session-data/${order}`,
  SAVE_RESULT: `${BASE_URL}/save-result`,
};
