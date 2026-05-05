const STORAGE_KEY = 'psikotes_progress';

export const saveProgress = (data: any) => {
  localStorage.setItem(STORAGE_KEY, JSON.stringify({
    ...data,
    timestamp: new Date().getTime()
  }));
};

export const getProgress = () => {
  const saved = localStorage.getItem(STORAGE_KEY);
  if (!saved) return null;

  const parsed = JSON.parse(saved);

  // Data dianggap hangus setelah 2 jam untuk keamanan
  const twoHours = 2 * 60 * 60 * 1000;
  const isExpired = new Date().getTime() - parsed.timestamp > twoHours;

  if (isExpired) {
    localStorage.removeItem(STORAGE_KEY);
    return null;
  }

  return parsed;
};

export const clearProgress = () => {
  localStorage.removeItem(STORAGE_KEY);
};
