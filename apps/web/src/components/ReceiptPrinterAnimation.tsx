import { useEffect, useRef } from 'react';
import './ReceiptPrinterAnimation.css';

export interface ReceiptItem {
  id?: string | number;
  name: string;
  quantity: number;
  subtotal: number;
}

export interface ReceiptSaleData {
  transactionId: string | number;
  total: number;
  items: ReceiptItem[];
  createdAt?: string | Date;
  discount?: number;
}

interface ReceiptPrinterAnimationProps {
  isOpen: boolean;
  saleData: ReceiptSaleData | null;
  onComplete: () => void;
  /** Set to false to keep the animation open while reviewing it. */
  autoClose?: boolean;
}

const formatMoney = (value: number) =>
  value.toLocaleString('es-CL', { style: 'currency', currency: 'CLP', maximumFractionDigits: 0 });

/** Confirmation overlay that simulates a thermal receipt being printed. */
export default function ReceiptPrinterAnimation({ isOpen, saleData, onComplete, autoClose = true }: ReceiptPrinterAnimationProps) {
  const onCompleteRef = useRef(onComplete);

  useEffect(() => {
    onCompleteRef.current = onComplete;
  }, [onComplete]);

  useEffect(() => {
    if (!isOpen || !autoClose) return;

    // Matches the CSS sequence: print (1.15s), cut, then a short reading delay.
    const timeout = window.setTimeout(() => onCompleteRef.current(), 3_500);
    return () => window.clearTimeout(timeout);
  }, [isOpen, autoClose]);

  if (!isOpen || !saleData) return null;

  const printedAt = saleData.createdAt ? new Date(saleData.createdAt) : new Date();
  const visibleItems = saleData.items.slice(0, 5);
  const remainingItems = saleData.items.length - visibleItems.length;

  return (
    <div className={`receipt-animation-overlay${autoClose ? '' : ' receipt-animation-overlay--persistent'}`} role="status" aria-live="polite" aria-label="Venta aprobada, imprimiendo boleta">
      <div className="receipt-animation" key={`${saleData.transactionId}-${String(printedAt)}`}>
        <p className="receipt-success-label"><span aria-hidden="true">✓</span> Pago aprobado</p>

        <div className="receipt-printer" aria-hidden="true">
          <div className="receipt-printer-top">
            <div className="receipt-printer-brand">Nexus</div>
            <div className="receipt-printer-led" />
          </div>
          <div className="receipt-printer-slot"><span /></div>
        </div>

        <div className="receipt-paper-window">
          <article className="receipt-paper">
            <header className="receipt-header">
              <strong>MINIMARKET</strong>
              <span>COMPROBANTE DE VENTA</span>
              <span>TRANSACCIÓN #{saleData.transactionId}</span>
              <span>{printedAt.toLocaleString('es-CL')}</span>
            </header>

            <div className="receipt-divider" />
            <div className="receipt-items">
              {visibleItems.map((item, index) => (
                <div className="receipt-item" key={item.id ?? `${item.name}-${index}`}>
                  <span>{item.name} x{item.quantity}</span>
                  <strong>{formatMoney(item.subtotal)}</strong>
                </div>
              ))}
              {remainingItems > 0 && <p className="receipt-more-items">+ {remainingItems} producto{remainingItems === 1 ? '' : 's'} más</p>}
            </div>
            <div className="receipt-divider" />
            {saleData.discount !== undefined && saleData.discount > 0 && (
              <div className="receipt-item"><span>Descuento</span><strong>-{formatMoney(saleData.discount)}</strong></div>
            )}
            <div className="receipt-total"><span>TOTAL</span><strong>{formatMoney(saleData.total)}</strong></div>
            <p className="receipt-thanks">¡Gracias por su compra!</p>
            <div className="receipt-zigzag" aria-hidden="true" />
          </article>
        </div>
      </div>
    </div>
  );
}
