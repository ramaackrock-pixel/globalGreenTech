import React, { useState, useEffect } from 'react';
import { ShoppingCart, Plus, Minus, Trash2, CreditCard, Search, Package, Clock, CalendarDays, User, Tag, Receipt } from 'lucide-react';
import inventoryData from '../../mockData/inventory.json';
import customersData from '../../mockData/customers.json';

const AdminKiosk: React.FC = () => {
  const [activeTab, setActiveTab] = useState<'new_sale' | 'history'>('new_sale');
  
  // New Sale State
  const [searchTerm, setSearchTerm] = useState('');
  const [cart, setCart] = useState<{ item: any, quantity: number }[]>([]);
  const [selectedCustomerId, setSelectedCustomerId] = useState<string>('');
  const [paymentStatus, setPaymentStatus] = useState<'Paid' | 'Half Paid' | 'Unpaid'>('Paid');

  // History State
  const [orders, setOrders] = useState<any[]>([]);
  const [dateFilter, setDateFilter] = useState<string>(''); // YYYY-MM-DD

  // Load orders from localStorage
  useEffect(() => {
    const savedOrders = localStorage.getItem('kiosk_orders');
    if (savedOrders) {
      setOrders(JSON.parse(savedOrders));
    }
    
    // Set default date filter to today
    setDateFilter(new Date().toISOString().split('T')[0]);
  }, []);

  // Filter inventory based on search
  const filteredInventory = inventoryData.filter(item => 
    item.name.toLowerCase().includes(searchTerm.toLowerCase()) || 
    item.sku.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const addToCart = (item: any) => {
    setCart(prev => {
      const existing = prev.find(c => c.item.sku === item.sku);
      if (existing) {
        if (existing.quantity >= item.stock) {
          alert(`Cannot add more. Only ${item.stock} in stock.`);
          return prev;
        }
        return prev.map(c => c.item.sku === item.sku ? { ...c, quantity: c.quantity + 1 } : c);
      }
      if (item.stock <= 0) {
        alert("Item is out of stock!");
        return prev;
      }
      return [...prev, { item, quantity: 1 }];
    });
  };

  const updateQuantity = (sku: string, delta: number) => {
    setCart(prev => {
      return prev.map(c => {
        if (c.item.sku === sku) {
          const newQty = c.quantity + delta;
          if (newQty > c.item.stock) {
            alert(`Only ${c.item.stock} in stock.`);
            return c;
          }
          if (newQty <= 0) return { ...c, quantity: 0 }; 
          return { ...c, quantity: newQty };
        }
        return c;
      }).filter(c => c.quantity > 0);
    });
  };

  const removeFromCart = (sku: string) => {
    setCart(prev => prev.filter(c => c.item.sku !== sku));
  };

  const subtotal = cart.reduce((sum, c) => sum + (c.item.price * c.quantity), 0);
  const tax = subtotal * 0.18; // 18% GST
  const total = subtotal + tax;

  const handleCheckout = () => {
    if (cart.length === 0) return;
    if (!selectedCustomerId) {
      alert("Please select a customer for this order.");
      return;
    }
    
    const newOrder = {
      id: `ORD-${Math.floor(Math.random() * 10000).toString().padStart(4, '0')}`,
      customerId: selectedCustomerId,
      items: cart,
      subtotal,
      tax,
      total,
      paymentStatus,
      timestamp: new Date().toISOString()
    };

    const updatedOrders = [newOrder, ...orders];
    setOrders(updatedOrders);
    localStorage.setItem('kiosk_orders', JSON.stringify(updatedOrders));

    alert(`Sale successful! Total: ₹${total.toLocaleString('en-IN', { maximumFractionDigits: 2 })}`);
    
    // Clear cart
    setCart([]);
    setSelectedCustomerId('');
    setPaymentStatus('Paid');
  };

  const deleteOrder = (orderId: string) => {
    if (window.confirm('Are you sure you want to delete this order record?')) {
      const updatedOrders = orders.filter(o => o.id !== orderId);
      setOrders(updatedOrders);
      localStorage.setItem('kiosk_orders', JSON.stringify(updatedOrders));
    }
  };

  // Filter orders by selected date
  const filteredOrders = orders.filter(order => {
    if (!dateFilter) return true;
    const orderDate = new Date(order.timestamp).toISOString().split('T')[0];
    return orderDate === dateFilter;
  });

  return (
    <div className="flex flex-col gap-6 pb-20 min-h-[calc(100vh-100px)]">
      
      {/* Tabs */}
      <div className="flex bg-surface-container-lowest p-1.5 rounded-2xl w-fit border border-outline-variant/30 shadow-sm shrink-0">
        <button 
          onClick={() => setActiveTab('new_sale')}
          className={`px-6 py-2.5 rounded-xl font-bold flex items-center gap-2 transition-all ${
            activeTab === 'new_sale' 
              ? 'bg-primary text-white shadow-md' 
              : 'text-on-surface-variant hover:text-on-surface hover:bg-surface-container'
          }`}
        >
          <ShoppingCart className="w-4 h-4" />
          New Sale
        </button>
        <button 
          onClick={() => setActiveTab('history')}
          className={`px-6 py-2.5 rounded-xl font-bold flex items-center gap-2 transition-all ${
            activeTab === 'history' 
              ? 'bg-primary text-white shadow-md' 
              : 'text-on-surface-variant hover:text-on-surface hover:bg-surface-container'
          }`}
        >
          <Receipt className="w-4 h-4" />
          Order History
        </button>
      </div>

      {/* Tab Content: New Sale */}
      {activeTab === 'new_sale' && (
        <div className="flex flex-col lg:flex-row gap-6 items-start">
          
          {/* Left Panel: Product Catalog */}
          <div className="flex-1 w-full flex flex-col bg-surface-container-lowest rounded-3xl border border-outline-variant/30 shadow-sm overflow-hidden min-h-[600px]">
            <div className="p-5 border-b border-surface-container-highest bg-surface-container/30 shrink-0">
              <h1 className="text-title-lg font-black text-on-surface flex items-center gap-2 mb-4">
                <Package className="w-6 h-6 text-primary" />
                Product Catalog
              </h1>
              <div className="relative">
                <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-on-surface-variant" />
                <input 
                  type="text" 
                  placeholder="Search products by name or SKU..." 
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="w-full pl-12 pr-4 py-3 bg-white border border-outline-variant rounded-xl focus:border-primary focus:ring-2 focus:ring-primary/20 transition-all font-medium text-on-surface outline-none"
                />
              </div>
            </div>

            <div className="flex-1 overflow-y-auto p-5">
              <div className="grid grid-cols-2 md:grid-cols-3 xl:grid-cols-4 gap-4">
                {filteredInventory.map(item => (
                  <button 
                    key={item.sku}
                    onClick={() => addToCart(item)}
                    disabled={item.stock <= 0}
                    className={`relative flex flex-col text-left p-4 rounded-2xl border transition-all ${
                      item.stock > 0 
                        ? 'bg-white border-outline-variant hover:border-primary hover:shadow-md hover:-translate-y-1 group' 
                        : 'bg-surface-container border-outline-variant/50 opacity-60 cursor-not-allowed'
                    }`}
                  >
                    <div className="mb-3">
                      <span className="text-[10px] font-black tracking-widest uppercase text-on-surface-variant bg-surface-container px-2 py-1 rounded-lg">
                        {item.sku}
                      </span>
                    </div>
                    <h3 className="text-label-lg font-bold text-on-surface line-clamp-2 flex-1 mb-2">
                      {item.name}
                    </h3>
                    <div className="flex items-end justify-between w-full mt-auto pt-2">
                      <div className="text-title-md font-black text-primary">₹{item.price}</div>
                      <div className={`text-xs font-bold ${item.stock <= 0 ? 'text-error' : item.stock <= 10 ? 'text-amber-600' : 'text-emerald-600'}`}>
                        {item.stock > 0 ? `${item.stock} in stock` : 'Out of Stock'}
                      </div>
                    </div>
                  </button>
                ))}
              </div>
            </div>
          </div>

          {/* Right Panel: Cart & Checkout */}
          <div className="w-full lg:w-[420px] flex flex-col bg-white rounded-3xl border border-outline-variant/30 shadow-lg overflow-hidden shrink-0 lg:sticky lg:top-24 lg:max-h-[calc(100vh-120px)] min-h-[500px]">
            <div className="p-5 border-b border-surface-container-highest bg-primary text-white flex items-center justify-between shrink-0">
              <h2 className="text-title-md font-extrabold flex items-center gap-2">
                <ShoppingCart className="w-5 h-5" />
                Current Order
              </h2>
              <span className="bg-white/20 px-2.5 py-1 rounded-full text-xs font-bold">
                {cart.reduce((s, c) => s + c.quantity, 0)} Items
              </span>
            </div>

            <div className="flex-1 overflow-y-auto p-2 bg-surface-container-lowest">
              {cart.length === 0 ? (
                <div className="h-full flex flex-col items-center justify-center text-on-surface-variant opacity-60 p-8 text-center space-y-4">
                  <ShoppingCart className="w-16 h-16" />
                  <p className="text-label-lg font-medium">Cart is empty.<br/>Tap items on the left to add them to the order.</p>
                </div>
              ) : (
                <div className="space-y-2 p-2">
                  {cart.map(c => (
                    <div key={c.item.sku} className="bg-white p-3 rounded-xl border border-outline-variant flex gap-3 items-center shadow-sm">
                      <div className="flex-1 min-w-0">
                        <h4 className="text-sm font-bold text-on-surface truncate">{c.item.name}</h4>
                        <div className="text-xs text-on-surface-variant mt-0.5 font-medium">₹{c.item.price} × {c.quantity}</div>
                      </div>
                      
                      <div className="flex items-center gap-3">
                        <div className="flex items-center bg-surface-container rounded-lg border border-outline-variant/50 overflow-hidden">
                          <button onClick={() => updateQuantity(c.item.sku, -1)} className="p-1.5 hover:bg-slate-200 text-on-surface transition-colors"><Minus className="w-3.5 h-3.5" /></button>
                          <span className="w-6 text-center text-xs font-bold">{c.quantity}</span>
                          <button onClick={() => updateQuantity(c.item.sku, 1)} className="p-1.5 hover:bg-slate-200 text-on-surface transition-colors"><Plus className="w-3.5 h-3.5" /></button>
                        </div>
                        <div className="text-sm font-black text-on-surface w-16 text-right">
                          ₹{c.item.price * c.quantity}
                        </div>
                        <button onClick={() => removeFromCart(c.item.sku)} className="p-1.5 text-error/70 hover:text-error hover:bg-error/10 rounded-lg transition-colors">
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>

            {/* Customer & Checkout Form */}
            <div className="p-5 border-t border-surface-container-highest bg-white space-y-4 shrink-0">
              
              <div className="space-y-3 pb-4 border-b border-surface-container-highest">
                <div>
                  <label className="text-xs font-bold text-on-surface-variant uppercase tracking-wider mb-1.5 block">Select Customer</label>
                  <div className="relative">
                    <User className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-on-surface-variant" />
                    <select 
                      value={selectedCustomerId}
                      onChange={(e) => setSelectedCustomerId(e.target.value)}
                      className="w-full pl-9 pr-4 py-2.5 bg-surface-container-lowest border border-outline-variant rounded-xl focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none text-sm font-medium appearance-none"
                    >
                      <option value="">-- Choose Walk-in Customer --</option>
                      {customersData.map(c => (
                        <option key={c.id} value={c.id}>{c.name} ({c.id})</option>
                      ))}
                    </select>
                  </div>
                </div>

                <div>
                  <label className="text-xs font-bold text-on-surface-variant uppercase tracking-wider mb-1.5 block">Payment Status</label>
                  <div className="grid grid-cols-3 gap-2">
                    {['Paid', 'Half Paid', 'Unpaid'].map(status => (
                      <button
                        key={status}
                        onClick={() => setPaymentStatus(status as any)}
                        className={`py-2 text-xs font-bold rounded-lg border transition-all ${
                          paymentStatus === status 
                            ? status === 'Paid' ? 'bg-emerald-50 text-emerald-700 border-emerald-200 shadow-sm' 
                              : status === 'Half Paid' ? 'bg-amber-50 text-amber-700 border-amber-200 shadow-sm'
                              : 'bg-error/10 text-error border-error/20 shadow-sm'
                            : 'bg-white text-on-surface-variant border-outline-variant hover:bg-surface-container'
                        }`}
                      >
                        {status}
                      </button>
                    ))}
                  </div>
                </div>
              </div>

              <div className="space-y-2 text-sm pt-2">
                <div className="flex justify-between text-on-surface-variant font-medium">
                  <span>Subtotal</span>
                  <span>₹{subtotal.toLocaleString('en-IN', { maximumFractionDigits: 2 })}</span>
                </div>
                <div className="flex justify-between text-on-surface-variant font-medium">
                  <span>GST (18%)</span>
                  <span>₹{tax.toLocaleString('en-IN', { maximumFractionDigits: 2 })}</span>
                </div>
                <div className="border-t border-dashed border-outline-variant pt-2 mt-2 flex justify-between items-center">
                  <span className="text-label-lg font-black text-on-surface uppercase tracking-wider">Total</span>
                  <span className="text-headline-sm font-black text-primary">₹{total.toLocaleString('en-IN', { maximumFractionDigits: 2 })}</span>
                </div>
              </div>

              <button 
                onClick={handleCheckout}
                disabled={cart.length === 0}
                className={`w-full py-4 rounded-xl flex items-center justify-center gap-2 font-black text-label-lg transition-all shadow-md ${
                  cart.length === 0 
                    ? 'bg-surface-container text-on-surface-variant opacity-60 cursor-not-allowed shadow-none' 
                    : 'bg-primary text-white hover:bg-primary/90 hover:-translate-y-0.5'
                }`}
              >
                <CreditCard className="w-5 h-5" />
                Complete Sale
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Tab Content: Order History */}
      {activeTab === 'history' && (
        <div className="flex-1 bg-white rounded-3xl border border-outline-variant/30 shadow-sm overflow-hidden flex flex-col min-h-[600px]">
          <div className="p-6 border-b border-surface-container-highest flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 shrink-0">
            <div>
              <h2 className="text-title-lg font-black text-on-surface">Order History</h2>
              <p className="text-label-md text-on-surface-variant">View and manage past Kiosk transactions.</p>
            </div>
            
            <div className="flex items-center gap-3">
              <span className="text-sm font-bold text-on-surface-variant">Filter by Date:</span>
              <div className="relative">
                <CalendarDays className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-on-surface-variant" />
                <input 
                  type="date"
                  value={dateFilter}
                  onChange={(e) => setDateFilter(e.target.value)}
                  className="pl-9 pr-4 py-2 bg-surface-container-lowest border border-outline-variant rounded-xl focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none text-sm font-medium text-on-surface"
                />
              </div>
              {dateFilter && (
                <button 
                  onClick={() => setDateFilter('')}
                  className="text-xs font-bold text-primary hover:text-primary/80 transition-colors"
                >
                  Clear
                </button>
              )}
            </div>
          </div>

          <div className="flex-1 overflow-x-auto min-h-0">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="border-b border-surface-container-highest bg-surface-container-lowest/50 text-label-md text-on-surface-variant sticky top-0 z-10 backdrop-blur-md">
                  <th className="py-4 px-6 font-bold uppercase tracking-wider">Order ID</th>
                  <th className="py-4 px-6 font-bold uppercase tracking-wider">Date & Time</th>
                  <th className="py-4 px-6 font-bold uppercase tracking-wider">Customer</th>
                  <th className="py-4 px-6 font-bold uppercase tracking-wider">Items Purchased</th>
                  <th className="py-4 px-6 font-bold uppercase tracking-wider">Amount</th>
                  <th className="py-4 px-6 font-bold uppercase tracking-wider">Status</th>
                  <th className="py-4 px-6 font-bold uppercase tracking-wider text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-surface-container-highest">
                {filteredOrders.length === 0 ? (
                  <tr>
                    <td colSpan={6} className="py-12 text-center text-on-surface-variant">
                      <Receipt className="w-12 h-12 mx-auto mb-3 opacity-20" />
                      <p className="text-body-lg font-medium">No orders found for this date.</p>
                    </td>
                  </tr>
                ) : (
                  filteredOrders.map((order) => {
                    const customer = customersData.find(c => c.id === order.customerId);
                    return (
                      <tr key={order.id} className="hover:bg-surface-container-lowest/50 transition-colors">
                        <td className="py-4 px-6">
                          <span className="text-body-md font-black text-on-surface">{order.id}</span>
                          <p className="text-xs text-on-surface-variant">{order.items.length} items</p>
                        </td>
                        <td className="py-4 px-6">
                          <div className="flex items-center gap-2 text-body-sm font-medium text-on-surface">
                            <Clock className="w-3.5 h-3.5 text-on-surface-variant" />
                            {new Date(order.timestamp).toLocaleString('en-GB', { dateStyle: 'medium', timeStyle: 'short' })}
                          </div>
                        </td>
                        <td className="py-4 px-6">
                          <span className="text-body-sm font-bold text-on-surface">{customer?.name || order.customerId}</span>
                        </td>
                        <td className="py-4 px-6">
                          <div className="flex flex-col gap-1">
                            {order.items.map((cartItem: any, idx: number) => (
                              <div key={idx} className="text-xs font-medium text-on-surface-variant flex items-center gap-1.5">
                                <span className="text-primary font-bold">{cartItem.quantity}x</span>
                                {cartItem.item.name}
                              </div>
                            ))}
                          </div>
                        </td>
                        <td className="py-4 px-6">
                          <span className="text-body-md font-black text-primary">₹{order.total.toLocaleString('en-IN', { maximumFractionDigits: 2 })}</span>
                        </td>
                        <td className="py-4 px-6">
                          <span className={`px-2.5 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider border ${
                            order.paymentStatus === 'Paid' ? 'bg-emerald-50 text-emerald-700 border-emerald-200' :
                            order.paymentStatus === 'Half Paid' ? 'bg-amber-50 text-amber-700 border-amber-200' :
                            'bg-error/10 text-error border-error/20'
                          }`}>
                            {order.paymentStatus}
                          </span>
                        </td>
                        <td className="py-4 px-6 text-right">
                          <button 
                            onClick={() => deleteOrder(order.id)}
                            className="p-2 text-error/70 hover:text-error hover:bg-error/10 rounded-lg transition-colors"
                            title="Delete Order"
                          >
                            <Trash2 className="w-5 h-5" />
                          </button>
                        </td>
                      </tr>
                    );
                  })
                )}
              </tbody>
            </table>
          </div>
        </div>
      )}

    </div>
  );
};

export default AdminKiosk;
