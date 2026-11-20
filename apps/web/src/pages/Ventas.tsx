import { useEffect, useMemo, useRef, useState } from 'react';
import { apiFetch } from '../api/client';
import Modal from '../components/Modal';
import Alert from '../components/Alert';
import ReceiptPrinterAnimation, { type ReceiptSaleData } from '../components/ReceiptPrinterAnimation';

type MetodoPago = 'EFECTIVO' | 'TARJETA' | 'TRANSFERENCIA';

interface Venta {
  id: number;
  total: number;
  descuentoTotal: number;
  metodoPago?: MetodoPago;
  tieneStockInsuficiente?: boolean;
  motivoAutorizacion?: string | null;
  createdAt: string;
  detalles?: { productoId: number; cantidad: number; subtotal: number; stockInsuficiente?: boolean; producto?: { nombre: string } }[];
}

interface Producto {
  id: number;
  codigoBarra?: string | null;
  nombre: string;
  precio: number;
  stock: number;
  descuento: number;
  precioConDescuento?: number;
  categoria?: { descuento: number };
}

interface ProductosResponse {
  items: Producto[];
}

type ItemCarrito = {
  producto: Producto;
  cantidad: number;
};

const formatMoney = (value: number) =>
  value.toLocaleString('es-CL', { style: 'currency', currency: 'CLP', maximumFractionDigits: 0 });

const precioFinal = (producto: Producto) => {
  if (producto.precioConDescuento !== undefined) return producto.precioConDescuento;
  const descuento = Math.min((producto.descuento ?? 0) + (producto.categoria?.descuento ?? 0), 100);
  return +(producto.precio * (1 - descuento / 100)).toFixed(2);
};

const descuentoTotalProducto = (producto: Producto) =>
  Math.min((producto.descuento ?? 0) + (producto.categoria?.descuento ?? 0), 100);

export default function Ventas() {
  const [ventas, setVentas] = useState<Venta[]>([]);
  const [productos, setProductos] = useState<Producto[]>([]);
  const [resultados, setResultados] = useState<Producto[]>([]);
  const [carrito, setCarrito] = useState<ItemCarrito[]>([]);
  const [loading, setLoading] = useState(true);
  const [buscandoProductos, setBuscandoProductos] = useState(false);
  const [busquedaProducto, setBusquedaProducto] = useState('');
  const [error, setError] = useState('');
  const [showPago, setShowPago] = useState(false);
  const [showAutorizacion, setShowAutorizacion] = useState(false);
  const [showTicket, setShowTicket] = useState(false);
  const [metodoPago, setMetodoPago] = useState<MetodoPago>('EFECTIVO');
  const [montoRecibido, setMontoRecibido] = useState('');
  const [pinAutorizacion, setPinAutorizacion] = useState('');
  const [motivoAutorizacion, setMotivoAutorizacion] = useState('');
  const [cobrando, setCobrando] = useState(false);
  const [ventaCerrada, setVentaCerrada] = useState<Venta | null>(null);
  const searchInputRef = useRef<HTMLInputElement | null>(null);

  const cargarProductos = async (busqueda = '') => {
    const params = new URLSearchParams({ limit: '24' });
    const q = busqueda.trim();
    if (q) params.set('q', q);

    setBuscandoProductos(true);
    try {
      const response = await apiFetch<ProductosResponse>(`/productos?${params}`);
      if (q) setResultados(response.items);
      else {
        setProductos(response.items);
        setResultados(response.items);
      }
    } finally {
      setBuscandoProductos(false);
    }
  };

  const cargar = async () => {
    try {
      setLoading(true);
      setError('');
      const [vs, ps] = await Promise.all([
        apiFetch<Venta[]>('/ventas'),
        apiFetch<ProductosResponse>('/productos?limit=100'),
      ]);
      setVentas(vs);
      setProductos(ps.items);
      setResultados(ps.items.slice(0, 24));
    } catch (e: any) {
      setError(e.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    cargar();
  }, []);

  useEffect(() => {
    const timer = window.setTimeout(() => {
      cargarProductos(busquedaProducto).catch((e: any) => setError(e.message));
    }, 220);
    return () => window.clearTimeout(timer);
  }, [busquedaProducto]);

  const productosMasVendidos = useMemo(() => {
    const unidadesPorProducto = new Map<number, number>();
    for (const venta of ventas) {
      for (const detalle of venta.detalles ?? []) {
        unidadesPorProducto.set(detalle.productoId, (unidadesPorProducto.get(detalle.productoId) ?? 0) + detalle.cantidad);
      }
    }
    const vendidos = productos
      .filter((producto) => unidadesPorProducto.has(producto.id))
      .sort((a, b) => (unidadesPorProducto.get(b.id) ?? 0) - (unidadesPorProducto.get(a.id) ?? 0))
      .slice(0, 8);
    return vendidos.length ? vendidos : productos.slice(0, 8);
  }, [productos, ventas]);

  const subtotal = useMemo(() => carrito.reduce((acc, item) => acc + item.producto.precio * item.cantidad, 0), [carrito]);
  const descuentoTotal = useMemo(
    () => carrito.reduce((acc, item) => acc + (item.producto.precio - precioFinal(item.producto)) * item.cantidad, 0),
    [carrito],
  );
  const total = useMemo(() => carrito.reduce((acc, item) => acc + precioFinal(item.producto) * item.cantidad, 0), [carrito]);
  const vuelto = useMemo(() => metodoPago === 'EFECTIVO' ? Math.max(Number(montoRecibido || 0) - total, 0) : 0, [metodoPago, montoRecibido, total]);
  const productosSinStock = useMemo(
    () => carrito
      .filter((item) => item.cantidad > item.producto.stock)
      .map((item) => ({
        id: item.producto.id,
        nombre: item.producto.nombre,
        solicitado: item.cantidad,
        disponible: item.producto.stock,
        faltante: item.cantidad - item.producto.stock,
      })),
    [carrito],
  );

  const agregarProducto = (producto: Producto) => {
    setError('');
    setCarrito((actual) => {
      const existe = actual.find((item) => item.producto.id === producto.id);
      if (existe) {
        return actual.map((item) =>
          item.producto.id === producto.id ? { ...item, cantidad: item.cantidad + 1 } : item,
        );
      }
      return [...actual, { producto, cantidad: 1 }];
    });
    setBusquedaProducto('');
    window.setTimeout(() => searchInputRef.current?.focus(), 0);
  };

  const agregarDesdeBusqueda = () => {
    const q = busquedaProducto.trim();
    if (!q) return;
    const exacto = resultados.find((producto) => producto.codigoBarra === q || String(producto.id) === q);
    const seleccionado = exacto ?? resultados[0];
    if (seleccionado) agregarProducto(seleccionado);
  };

  const cambiarCantidad = (productoId: number, cantidad: number) => {
    setCarrito((actual) =>
      actual.map((item) =>
        item.producto.id === productoId ? { ...item, cantidad: Math.max(cantidad || 1, 1) } : item,
      ),
    );
  };

  const cancelarVenta = () => {
    setCarrito([]);
    setBusquedaProducto('');
    setMontoRecibido('');
    setPinAutorizacion('');
    setMotivoAutorizacion('');
    setMetodoPago('EFECTIVO');
    setError('');
    searchInputRef.current?.focus();
  };

  const cobrar = async (autorizacion?: { pinAutorizacion: string; motivoAutorizacion: string }) => {
    if (metodoPago === 'EFECTIVO' && Number(montoRecibido || 0) < total) {
      setError('El monto recibido no alcanza para pagar la venta.');
      return;
    }

    const ventaConStockInsuficiente = productosSinStock.length > 0;
    if (ventaConStockInsuficiente && !autorizacion) {
      setShowPago(false);
      setShowAutorizacion(true);
      return;
    }

    try {
      setCobrando(true);
      setError('');
      const venta = await apiFetch<Venta>('/ventas', {
        method: 'POST',
        body: JSON.stringify({
          metodoPago,
          pinAutorizacion: autorizacion?.pinAutorizacion,
          motivoAutorizacion: autorizacion?.motivoAutorizacion,
          detalles: carrito.map((item) => ({ productoId: item.producto.id, cantidad: item.cantidad })),
        }),
      });
      setVentaCerrada(venta);
      setShowPago(false);
      setShowTicket(true);
      setCarrito([]);
      setBusquedaProducto('');
      setMontoRecibido('');
      setPinAutorizacion('');
      setMotivoAutorizacion('');
      await cargar();
    } catch (e: any) {
      setError(e.message);
    } finally {
      setCobrando(false);
    }
  };

  const iniciarCobro = () => {
    setMontoRecibido(total.toFixed(0));
    setError('');
    setShowPago(true);
  };

  const autorizarStockInsuficiente = () => {
    if (!pinAutorizacion.trim()) {
      setError('Ingrese el PIN de autorizacion.');
      return;
    }
    if (!motivoAutorizacion.trim()) {
      setError('Ingrese el motivo de autorizacion.');
      return;
    }
    setError('');
    setShowAutorizacion(false);
    cobrar({
      pinAutorizacion: pinAutorizacion.trim(),
      motivoAutorizacion: motivoAutorizacion.trim(),
    });
  };

  const eliminar = async (id: number) => {
    if (!confirm('Eliminar esta venta? Se restaurara el stock de sus productos.')) return;
    try {
      setError('');
      await apiFetch(`/ventas/${id}`, { method: 'DELETE' });
      cargar();
    } catch (e: any) {
      setError(e.message);
    }
  };

  if (loading) return <div className="loading">Cargando ventas...</div>;

  return (
    <div className="page sales-page">
      <div className="page-header">
        <div>
          <h2>Ventas</h2>
          <p className="page-subtitle">Caja rapida para escaneo, revision y cobro</p>
        </div>
      </div>

      {error && <Alert message={error} onClose={() => setError('')} />}

      <div className="sales-workspace">
        <section className="sales-panel sales-selection">
          <div className="sales-panel-header"><h3>Seleccion</h3><span className="badge badge-yellow">Entrada</span></div>
          <div className="form-group">
            <label>Buscar o escanear</label>
            <input ref={searchInputRef} value={busquedaProducto} onChange={(e) => setBusquedaProducto(e.target.value)} onKeyDown={(e) => e.key === 'Enter' && agregarDesdeBusqueda()} placeholder="Nombre, codigo de barras o ID" autoFocus />
          </div>
          {buscandoProductos && <div className="loading loading-inline">Buscando productos...</div>}
          <div className="quick-products">
            {resultados.slice(0, 6).map((producto) => (
              <button key={producto.id} type="button" className="quick-product" onClick={() => agregarProducto(producto)}>
                <span>{producto.nombre}</span><strong>{formatMoney(precioFinal(producto))}</strong><small className={producto.stock <= 0 ? 'text-danger' : undefined}>Stock {producto.stock}</small>
              </button>
            ))}
            {resultados.length === 0 && <p className="empty-state">No hay productos para esa busqueda.</p>}
          </div>
          <div className="top-products">
            <h4>Mas vendidos</h4>
            <div className="top-products-grid">
              {productosMasVendidos.map((producto) => (
                <button key={producto.id} type="button" className="btn btn-secondary btn-sm" onClick={() => agregarProducto(producto)}>
                  {producto.nombre}
                </button>
              ))}
            </div>
          </div>
        </section>

        <section className="sales-panel sales-cart">
          <div className="sales-panel-header"><h3>Lista de compra</h3><span className="badge badge-green">Revision</span></div>
          <div className="cart-table-wrap">
            <table className="cart-table">
              <thead><tr><th>Producto</th><th>Cantidad</th><th>Precio</th><th>Subtotal</th><th></th></tr></thead>
              <tbody>
                {carrito.map((item) => {
                  const descuento = descuentoTotalProducto(item.producto);
                  return (
                    <tr key={item.producto.id}>
                      <td><strong>{item.producto.nombre}</strong><span>{item.producto.codigoBarra || `ID ${item.producto.id}`}</span>{descuento > 0 && <em>{descuento}% desc.</em>}</td>
                      <td>
                        <div className="qty-control">
                          <button type="button" onClick={() => cambiarCantidad(item.producto.id, item.cantidad - 1)}>-</button>
                          <input type="number" min={1} value={item.cantidad} onChange={(e) => cambiarCantidad(item.producto.id, Number(e.target.value))} />
                          <button type="button" onClick={() => cambiarCantidad(item.producto.id, item.cantidad + 1)}>+</button>
                        </div>
                      </td>
                      <td>{formatMoney(precioFinal(item.producto))}{item.cantidad > item.producto.stock && <em className="stock-warning">Stock insuficiente</em>}</td>
                      <td><strong>{formatMoney(precioFinal(item.producto) * item.cantidad)}</strong></td>
                      <td><button className="btn btn-danger btn-sm" type="button" onClick={() => setCarrito((actual) => actual.filter((p) => p.producto.id !== item.producto.id))}>Borrar</button></td>
                    </tr>
                  );
                })}
                {carrito.length === 0 && <tr><td colSpan={5}><div className="empty-cart">Escanea o selecciona productos para iniciar la venta.</div></td></tr>}
              </tbody>
            </table>
          </div>
        </section>

        <aside className="sales-panel sales-control">
          <div className="sales-panel-header"><h3>Control</h3><span className="badge badge-red">Pago</span></div>
          <div className="total-box"><span>Total</span><strong>{formatMoney(total)}</strong></div>
          <div className="sale-summary">
            <div><span>Subtotal</span><strong>{formatMoney(subtotal)}</strong></div>
            <div><span>Descuentos</span><strong>{formatMoney(descuentoTotal)}</strong></div>
            <div><span>Items</span><strong>{carrito.reduce((acc, item) => acc + item.cantidad, 0)}</strong></div>
          </div>
          <div className="sales-actions">
            <button className="btn btn-success btn-xl" type="button" onClick={iniciarCobro} disabled={carrito.length === 0}>Cobrar</button>
            <button className="btn btn-danger btn-xl" type="button" onClick={cancelarVenta} disabled={carrito.length === 0}>Cancelar venta</button>
          </div>
        </aside>
      </div>

      <div className="sales-flow">
        <div><strong>1. Entrada</strong><span>Escaneo o busqueda.</span></div>
        <div><strong>2. Revision</strong><span>Cantidades y descuentos.</span></div>
        <div><strong>3. Pago</strong><span>Efectivo, tarjeta o transferencia.</span></div>
        <div><strong>4. Cierre</strong><span>Ticket, stock y caja limpia.</span></div>
      </div>

      <div className="table-wrap sales-history">
        <table>
          <thead><tr><th>#</th><th>Total</th><th>Descuento</th><th>Metodo</th><th>Productos</th><th>Fecha</th><th>Acciones</th></tr></thead>
          <tbody>
            {ventas.map((venta) => (
              <tr key={venta.id}>
                <td>#{venta.id}</td><td><strong>{formatMoney(venta.total)}</strong>{venta.tieneStockInsuficiente && <span className="badge badge-red">Stock insuficiente</span>}</td><td>{venta.descuentoTotal > 0 ? formatMoney(venta.descuentoTotal) : '-'}</td><td>{venta.metodoPago ?? 'EFECTIVO'}</td><td>{venta.detalles?.map((detalle) => `${detalle.producto?.nombre} x${detalle.cantidad}`).join(', ')}</td><td>{new Date(venta.createdAt).toLocaleString('es-CL')}</td><td><button className="btn btn-danger btn-sm" onClick={() => eliminar(venta.id)}>Eliminar</button></td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {showAutorizacion && (
        <Modal title="Autorizar stock insuficiente" onClose={() => setShowAutorizacion(false)}>
          {error && <div className="alert alert-error">{error}</div>}
          <p className="modal-message">Stock insuficiente. Se requiere PIN de autorización.</p>
          <div className="form-group">
            <div className="stock-shortage-list">
              {productosSinStock.map((producto) => (
                <div key={producto.id}>
                  <strong>{producto.nombre}</strong>
                  <span>Solicitado: {producto.solicitado} | Disponible: {producto.disponible} | Faltan: {producto.faltante}</span>
                </div>
              ))}
            </div>
            <label>PIN</label>
            <input type="password" inputMode="numeric" value={pinAutorizacion} onChange={(e) => setPinAutorizacion(e.target.value)} autoFocus />
          </div>
          <div className="form-group">
            <label>Motivo</label>
            <input value={motivoAutorizacion} onChange={(e) => setMotivoAutorizacion(e.target.value)} placeholder="Motivo de autorizacion" />
          </div>
          <div className="modal-actions">
            <button className="btn btn-secondary" onClick={() => setShowAutorizacion(false)}>Cancelar</button>
            <button className="btn btn-success" onClick={autorizarStockInsuficiente}>Autorizar</button>
          </div>
        </Modal>
      )}

      {showPago && (
        <Modal title="Cobrar venta" onClose={() => setShowPago(false)}>
          {error && <div className="alert alert-error">{error}</div>}
          <div className="payment-total">{formatMoney(total)}</div>
          <div className="payment-methods">
            {(['EFECTIVO', 'TARJETA', 'TRANSFERENCIA'] as MetodoPago[]).map((metodo) => (
              <button key={metodo} type="button" className={`btn ${metodoPago === metodo ? 'btn-primary' : 'btn-secondary'}`} onClick={() => setMetodoPago(metodo)}>
                {metodo === 'EFECTIVO' ? 'Efectivo' : metodo === 'TARJETA' ? 'Tarjeta' : 'Transferencia'}
              </button>
            ))}
          </div>
          {metodoPago === 'EFECTIVO' && (
            <>
              <div className="form-group"><label>Monto recibido</label><input type="number" min={0} value={montoRecibido} onChange={(e) => setMontoRecibido(e.target.value)} /></div>
              <div className="change-box"><span>Vuelto</span><strong>{formatMoney(vuelto)}</strong></div>
            </>
          )}
          <div className="modal-actions">
            <button className="btn btn-secondary" onClick={() => setShowPago(false)}>Volver</button>
            <button className="btn btn-success" onClick={() => cobrar()} disabled={cobrando}>{cobrando ? 'Cobrando...' : 'Confirmar pago'}</button>
          </div>
        </Modal>
      )}

      <ReceiptPrinterAnimation
        isOpen={showTicket}
        autoClose={true}
        saleData={ventaCerrada ? {
          transactionId: ventaCerrada.id,
          total: ventaCerrada.total,
          discount: ventaCerrada.descuentoTotal,
          createdAt: ventaCerrada.createdAt,
          items: (ventaCerrada.detalles ?? []).map((detalle) => ({
            id: detalle.productoId,
            name: detalle.producto?.nombre ?? `Producto #${detalle.productoId}`,
            quantity: detalle.cantidad,
            subtotal: detalle.subtotal,
          })),
        } satisfies ReceiptSaleData : null}
        onComplete={() => setShowTicket(false)}
      />
    </div>
  );
}
