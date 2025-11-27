import { API_ENDPOINTS } from '../config/api';

export interface ChatResponse {
  message?: string;
  error?: string;
  tools_used?: string[];
  tools_details?: any[];
  available_tools?: string[];
}

export interface ChatError {
  message: string;
  isNetworkError: boolean;
}

class ChatService {
  private async request<T>(
    endpoint: string,
    options: RequestInit = {}
  ): Promise<T> {
    const defaultHeaders = {
      'Content-Type': 'application/json',
    };

    const config: RequestInit = {
      ...options,
      headers: {
        ...defaultHeaders,
        ...options.headers,
      },
    };

    try {
      const response = await fetch(endpoint, config);

      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(
          errorData.error || `Error ${response.status}: ${response.statusText}`
        );
      }

      return await response.json();
    } catch (error) {
      if (error instanceof TypeError && error.message === 'Failed to fetch') {
        throw {
          message:
            'Error al conectar con el servidor. Asegúrate de que el backend esté corriendo.',
          isNetworkError: true,
        } as ChatError;
      }

      throw {
        message: error instanceof Error ? error.message : 'Error desconocido',
        isNetworkError: false,
      } as ChatError;
    }
  }

  async sendMessage(prompt: string): Promise<ChatResponse> {
    return this.request<ChatResponse>(API_ENDPOINTS.AI_AGENT, {
      method: 'POST',
      body: JSON.stringify({ prompt }),
    });
  }
}

export const chatService = new ChatService();

