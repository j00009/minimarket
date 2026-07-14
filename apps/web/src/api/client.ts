const BASE_URL = 'http://localhost:3000/api';
 
export const TOKEN_KEY = 'minimarket_token';
export const REFRESH_TOKEN_KEY = 'minimarket_refresh_token';
 
let refreshInFlight: Promise<string | null> | null = null;
 
async function refreshAccessToken(): Promise<string | null> {
  const refreshToken = localStorage.getItem(REFRESH_TOKEN_KEY);
  if (!refreshToken) return null;
 
  // Si ya hay un refresh en curso (ej. varias peticiones en paralelo
  // recibieron 401 al mismo tiempo), todas esperan el mismo resultado
  // en vez de disparar refresh_token varias veces (el backend lo rota
  // y revoca el anterior, así que una segunda llamada en paralelo con
  // el mismo refresh_token fallaría).
  if (!refreshInFlight) {
    refreshInFlight = (async () => {
      try {
        const res = await fetch(`${BASE_URL}/auth/refresh`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ refresh_token: refreshToken }),
        });
        if (!res.ok) return null;
        const data = await res.json();
        localStorage.setItem(TOKEN_KEY, data.access_token);
        localStorage.setItem(REFRESH_TOKEN_KEY, data.refresh_token);
        return data.access_token as string;
      } catch {
        return null;
      } finally {
        refreshInFlight = null;
      }
    })();
  }
  return refreshInFlight;
}
 
export async function apiFetch<T>(path: string, options?: RequestInit, _retried = false): Promise<T> {
  const token = localStorage.getItem(TOKEN_KEY);
  const headers = new Headers(options?.headers);
  headers.set('Content-Type', 'application/json');
  if (token) headers.set('Authorization', `Bearer ${token}`);
 
  const res = await fetch(`${BASE_URL}${path}`, {
    ...options,
    headers,
  });
 
  if (res.status === 401 && !_retried && path !== '/auth/refresh' && path !== '/auth/login') {
    const newToken = await refreshAccessToken();
    if (newToken) {
      return apiFetch<T>(path, options, true);
    }
    localStorage.removeItem(TOKEN_KEY);
    localStorage.removeItem(REFRESH_TOKEN_KEY);
  }
 
  if (!res.ok) {
    const error = await res.json().catch(() => ({}));
    const message = Array.isArray(error.message) ? error.message.join(', ') : error.message;
    throw new Error(message || 'Error en la peticion');
  }
  return res.json();
}
 