const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:3000';

export const API_ENDPOINTS = {
  AI_AGENT: `${API_BASE_URL}/api/ai_agent`,
} as const;

export default API_BASE_URL;

