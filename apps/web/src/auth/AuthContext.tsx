import { createContext, useContext, useEffect, useMemo, useState } from 'react';
import { TOKEN_KEY, REFRESH_TOKEN_KEY, apiFetch } from '../api/client';

export type RolUsuario = 'ADMIN' | 'SUPERVISOR' | 'SUPER_ADMIN' | 'VENDEDOR';
export type PermisoUsuario = 'dashboard.ver' | 'usuarios.gestionar' | 'stock.autorizar';

export type AuthUser = {
  sub: number;
  email: string;
  nombre: string;
  rol: RolUsuario;
  permisos: PermisoUsuario[];
};

type LoginResponse = {
  access_token: string;
  refresh_token: string;
  user: AuthUser;
};

type AuthContextValue = {
  user: AuthUser | null;
  loading: boolean;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
};

const AuthContext = createContext<AuthContextValue | null>(null);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<AuthUser | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!localStorage.getItem(TOKEN_KEY)) {
      setLoading(false);
      return;
    }

    apiFetch<AuthUser>('/auth/me')
      .then(setUser)
      .catch(() => {
        localStorage.removeItem(TOKEN_KEY);
        setUser(null);
      })
      .finally(() => setLoading(false));
  }, []);

  const value = useMemo<AuthContextValue>(() => ({
    user,
    loading,
    async login(email: string, password: string) {
      const response = await apiFetch<LoginResponse>('/auth/login', {
        method: 'POST',
        body: JSON.stringify({ email, password }),
      });
      localStorage.setItem(TOKEN_KEY, response.access_token);
      localStorage.setItem(REFRESH_TOKEN_KEY, response.refresh_token);
      setUser(response.user);
    },
    logout() {
      localStorage.removeItem(TOKEN_KEY);
      localStorage.removeItem(REFRESH_TOKEN_KEY);
      setUser(null);
    },
  }), [user, loading]);

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) throw new Error('useAuth debe usarse dentro de AuthProvider');
  return context;
}
