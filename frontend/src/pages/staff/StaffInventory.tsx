import React, { useState } from 'react';
import { Package, Search, Plus, Filter, AlertCircle, X, CheckCircle } from 'lucide-react';
import inventoryData from '../../mockData/inventory.json';

const StaffInventory: React.FC = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const [showRequestModal, setShowRequestModal] = useState(false);
  const [requestStatus, setRequestStatus] = useState<'idle' | 'submitting' | 'success'>('idle');

  // Filter inventory based on search
  const filteredInventory = inventoryData.filter(item => 
    item.name.toLowerCase().includes(searchTerm.toLowerCase()) || 
    item.sku.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const handleRequestSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setRequestStatus('submitting');
    setTimeout(() => {
      setRequestStatus('success');
      setTimeout(() => {
        setShowRequestModal(false);
        setRequestStatus('idle');
      }, 2000);
    }, 1000);
  };

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 card relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-full bg-gradient-to-l from-primary-container/50 to-transparent pointer-events-none"></div>

        <div className="relative z-10">
          <h1 className="text-headline-lg text-on-surface">My Inventory</h1>
          <p className="text-body-md text-on-surface-variant mt-1">Track parts you have and request new stock from admin.</p>
        </div>
        
        <div className="relative z-10">
          <button 
            onClick={() => setShowRequestModal(true)}
            className="btn-primary"
          >
            <Plus className="w-5 h-5" />
            Request Parts
          </button>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="card p-6 border-l-4 border-l-primary flex items-center gap-4">
          <div className="p-3 bg-primary-container text-on-primary-container rounded-xl">
            <Package className="w-6 h-6" />
          </div>
          <div>
            <p className="text-label-md text-on-surface-variant uppercase tracking-widest">Total Items</p>
            <p className="text-headline-md font-extrabold text-on-surface">185</p>
          </div>
        </div>
        <div className="card p-6 border-l-4 border-l-secondary flex items-center gap-4">
          <div className="p-3 bg-secondary-container text-on-secondary-container rounded-xl">
            <Package className="w-6 h-6" />
          </div>
          <div>
            <p className="text-label-md text-on-surface-variant uppercase tracking-widest">Parts Used Today</p>
            <p className="text-headline-md font-extrabold text-on-surface">3</p>
          </div>
        </div>
        <div className="card p-6 border-l-4 border-l-error flex items-center gap-4">
          <div className="p-3 bg-error-container text-on-error-container rounded-xl">
            <AlertCircle className="w-6 h-6" />
          </div>
          <div>
            <p className="text-label-md text-on-surface-variant uppercase tracking-widest">Low Stock Alerts</p>
            <p className="text-headline-md font-extrabold text-on-surface">2</p>
          </div>
        </div>
      </div>

      {/* Inventory Table */}
      <div className="card overflow-hidden">
        <div className="p-6 border-b border-surface-container-highest flex flex-col sm:flex-row justify-between items-center gap-4">
          <h2 className="text-title-md font-bold text-on-surface">Current Stock</h2>
          <div className="flex gap-3 w-full sm:w-auto">
            <div className="relative flex-1 sm:w-64">
              <Search className="w-5 h-5 absolute left-3 top-1/2 -translate-y-1/2 text-outline" />
              <input 
                type="text" 
                placeholder="Search inventory..." 
                className="input-field pl-10"
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
              />
            </div>
            <button className="btn-secondary px-3">
              <Filter className="w-5 h-5" />
            </button>
          </div>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-surface-container-lowest border-b border-surface-container-highest text-label-md text-on-surface-variant uppercase tracking-wider">
                <th className="p-4 font-bold">Item Name</th>
                <th className="p-4 font-bold">SKU</th>
                <th className="p-4 font-bold">In Hand</th>
                <th className="p-4 font-bold">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-surface-container-highest text-body-sm text-on-surface">
              {filteredInventory.map((item) => {
                const isLowStock = item.stock <= item.minStockAlert;
                return (
                  <tr key={item.id} className="hover:bg-surface-container/50 transition-colors">
                    <td className="p-4 font-bold">{item.name}</td>
                    <td className="p-4 text-on-surface-variant">{item.sku}</td>
                    <td className="p-4 font-bold">{item.stock}</td>
                    <td className="p-4">
                      {isLowStock ? (
                        <span className="badge-expired">Low Stock</span>
                      ) : (
                        <span className="badge-active">In Stock</span>
                      )}
                    </td>
                  </tr>
                );
              })}
              {filteredInventory.length === 0 && (
                <tr>
                  <td colSpan={4} className="p-8 text-center text-on-surface-variant">
                    No inventory found matching your search.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Request Parts Modal */}
      {showRequestModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm animate-in fade-in duration-200">
          <div className="card w-full max-w-md shadow-2xl animate-in zoom-in-95 duration-200">
            <div className="flex justify-between items-center p-6 border-b border-surface-container-highest">
              <h2 className="text-title-lg font-bold text-on-surface">Request Parts</h2>
              <button 
                onClick={() => setShowRequestModal(false)}
                className="p-2 hover:bg-surface-container rounded-full transition-colors text-on-surface-variant"
              >
                <X className="w-5 h-5" />
              </button>
            </div>
            
            {requestStatus === 'success' ? (
              <div className="p-8 flex flex-col items-center text-center">
                <div className="w-16 h-16 bg-primary-container text-on-primary-container rounded-full flex items-center justify-center mb-4">
                  <CheckCircle className="w-8 h-8" />
                </div>
                <h3 className="text-title-lg font-bold text-on-surface mb-2">Request Sent!</h3>
                <p className="text-body-md text-on-surface-variant">The admin has been notified of your parts request.</p>
              </div>
            ) : (
              <form onSubmit={handleRequestSubmit} className="p-6 space-y-4">
                <div>
                  <label className="block text-label-md font-bold text-on-surface-variant mb-1.5 uppercase tracking-wider">Select Part</label>
                  <div className="select-wrapper">
                    <select className="select-field" required>
                      <option value="" disabled selected>Choose a part...</option>
                      {inventoryData.map(item => (
                        <option key={item.id} value={item.id}>{item.name} ({item.sku})</option>
                      ))}
                    </select>
                  </div>
                </div>
                
                <div>
                  <label className="block text-label-md font-bold text-on-surface-variant mb-1.5 uppercase tracking-wider">Quantity</label>
                  <input type="number" min="1" required className="input-field" placeholder="Enter quantity needed" />
                </div>
                
                <div>
                  <label className="block text-label-md font-bold text-on-surface-variant mb-1.5 uppercase tracking-wider">Notes (Optional)</label>
                  <textarea className="input-field min-h-[80px]" placeholder="E.g., Need this for tomorrow's AMC tasks"></textarea>
                </div>
                
                <div className="pt-4 flex gap-3">
                  <button type="button" onClick={() => setShowRequestModal(false)} className="btn-ghost flex-1">Cancel</button>
                  <button type="submit" className="btn-primary flex-1" disabled={requestStatus === 'submitting'}>
                    {requestStatus === 'submitting' ? 'Submitting...' : 'Send Request'}
                  </button>
                </div>
              </form>
            )}
          </div>
        </div>
      )}
    </div>
  );
};

export default StaffInventory;
