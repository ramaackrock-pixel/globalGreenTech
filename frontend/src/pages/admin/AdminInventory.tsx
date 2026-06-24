import React, { useState, useEffect } from 'react';
import { Package, Filter, MoreVertical, Plus, Download, AlertTriangle, CheckCircle2, User, Clock, Check, X } from 'lucide-react';
import inventoryData from '../../mockData/inventory.json';
import { useSearch } from '../../context/SearchContextProvider';
import InventoryModal from './InventoryModal';

const AdminInventory: React.FC = () => {
  const [stockFilter, setStockFilter] = useState<string>('All');
  const [isModalOpen, setIsModalOpen] = useState<boolean>(false);
  const [inventory, setInventory] = useState<any[]>(inventoryData);
  const [requests, setRequests] = useState<any[]>([]);
  const { searchQuery } = useSearch();

  useEffect(() => {
    const saved = localStorage.getItem('inventory_requests');
    if (saved) setRequests(JSON.parse(saved));
  }, []);

  const handleRequestAction = (reqId: string, action: 'Approved' | 'Denied') => {
    const updatedReqs = requests.map(r => r.id === reqId ? { ...r, status: action } : r);
    setRequests(updatedReqs);
    localStorage.setItem('inventory_requests', JSON.stringify(updatedReqs));

    if (action === 'Approved') {
      const req = requests.find(r => r.id === reqId);
      if (req) {
        setInventory(prev => prev.map(item => {
          // Note: using basic string matching for prototype
          if (item.name === req.partName || req.partName.includes(item.name)) {
            return { ...item, stock: Math.max(0, item.stock - parseInt(req.quantity)) };
          }
          return item;
        }));
      }
    }
  };

  const handleSaveItem = (newItem: any) => {
    // InventoryModal passes up { name, sku, price, stock, minStockAlert } inside 'newItem'
    // We just need to give it an ID before appending it!
    const newId = `i${inventory.length + 1}`;
    const item = {
      id: newId,
      ...newItem
    };

    setIsModalOpen(false);
    setInventory((prev) => [...prev, item]);
  };

  const filteredInventory = inventory.filter((item: any) => {
    // Filter by stock status
    let matchesStock = true;
    if (stockFilter === 'Low Stock') {
      matchesStock = item.stock <= item.minStockAlert;
    } else if (stockFilter === 'In Stock') {
      matchesStock = item.stock > item.minStockAlert;
    }

    // Filter by search query
    const matchesSearch = searchQuery.trim() === '' ||
      item.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      item.sku.toLowerCase().includes(searchQuery.toLowerCase());

    return matchesStock && matchesSearch;
  });

  return (
    <div className="space-y-8 pb-20 md:pb-0">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-white p-6 rounded-2xl shadow-[0_2px_10px_-3px_rgba(6,81,237,0.1)] border border-slate-100 relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-full bg-gradient-to-l from-primary-50/50 to-transparent pointer-events-none"></div>

        <div className="relative z-10">
          <h1 className="text-2xl font-extrabold text-slate-800 tracking-tight">Inventory Management</h1>
          <p className="text-slate-500 text-sm mt-1 font-medium">Manage spare parts, monitor stock levels, and set alerts.</p>
        </div>

        <div className="flex gap-3 relative z-10 w-full sm:w-auto">
          <button className="flex-1 sm:flex-none flex items-center justify-center gap-2 px-5 py-2.5 bg-white border border-slate-200 text-slate-600 rounded-xl text-sm font-semibold hover:bg-slate-50 hover:border-slate-300 transition-all shadow-sm">
            <Download className="w-4 h-4" />
            Export
          </button>
          <button
            onClick={() => setIsModalOpen(true)}
            className="flex-1 sm:flex-none flex items-center justify-center gap-2 px-5 py-2.5 bg-gradient-to-r from-slate-900 to-slate-800 hover:from-slate-800 hover:to-slate-700 text-white rounded-xl font-bold shadow-md hover:shadow-lg transition-all"
          >
            <Plus className="w-4 h-4" />
            Add Item
          </button>
        </div>
      </div>

      {/* Pending Requests Section */}
      {requests.filter(r => r.status === 'Pending').length > 0 && (
        <div className="bg-amber-50/50 rounded-2xl border border-amber-200/50 overflow-hidden">
          <div className="p-4 border-b border-amber-200/50 bg-amber-100/30 flex items-center gap-2">
            <Clock className="w-5 h-5 text-amber-600" />
            <h2 className="text-label-lg font-bold text-amber-900 uppercase tracking-wider">Pending Staff Requests</h2>
          </div>
          <div className="p-4 grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
            {requests.filter(r => r.status === 'Pending').map(req => (
              <div key={req.id} className="bg-white p-4 rounded-xl border border-amber-200 shadow-sm flex flex-col justify-between">
                <div>
                  <div className="flex justify-between items-start mb-2">
                    <span className="text-body-md font-extrabold text-slate-800">{req.quantity}x {req.partName}</span>
                    <span className="text-[10px] font-bold text-amber-600 bg-amber-100 px-2 py-0.5 rounded uppercase tracking-widest">Pending</span>
                  </div>
                  <div className="flex items-center gap-4 text-xs font-medium text-slate-500 mb-4">
                    <div className="flex items-center gap-1.5"><User className="w-3.5 h-3.5" />{req.staffName}</div>
                    <div className="flex items-center gap-1.5"><Clock className="w-3.5 h-3.5" />{new Date(req.timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</div>
                  </div>
                </div>
                <div className="flex gap-2">
                  <button onClick={() => handleRequestAction(req.id, 'Denied')} className="flex-1 py-2 text-xs font-bold text-red-600 bg-red-50 hover:bg-red-100 rounded-lg flex items-center justify-center gap-1 transition-colors">
                    <X className="w-3.5 h-3.5" /> Deny
                  </button>
                  <button onClick={() => handleRequestAction(req.id, 'Approved')} className="flex-1 py-2 text-xs font-bold text-emerald-600 bg-emerald-50 hover:bg-emerald-100 rounded-lg flex items-center justify-center gap-1 transition-colors">
                    <Check className="w-3.5 h-3.5" /> Approve
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Main Content Box */}
      <div className="bg-white rounded-2xl shadow-[0_4px_20px_-4px_rgba(0,0,0,0.03)] border border-slate-100 overflow-hidden">

        {/* Toolbar (Filters) */}
        <div className="p-6 border-b border-slate-100 bg-slate-50/50 flex flex-col lg:flex-row gap-4 justify-end items-center">
          <div className="flex gap-3 w-full lg:w-auto">
            <div className="flex items-center gap-2 bg-white px-3 py-1.5 rounded-xl border border-slate-300 shadow-sm w-full sm:w-auto">
              <Filter className="w-4 h-4 text-slate-400" />
              <select
                className="bg-transparent text-sm font-bold text-slate-700 outline-none appearance-none cursor-pointer w-full pl-1 pr-6 py-1"
                value={stockFilter}
                onChange={(e) => setStockFilter(e.target.value)}
              >
                <option value="All">All Stock Levels</option>
                <option value="In Stock">In Stock</option>
                <option value="Low Stock">Low Stock</option>
              </select>
            </div>
          </div>
        </div>

        {/* Data Table */}
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse min-w-[800px]">
            <thead>
              <tr className="bg-slate-50/50 border-b border-slate-100">
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">Item Details</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">SKU</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">Unit Price</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">Stock Level</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {filteredInventory.map((item: any) => {
                const isLowStock = item.stock <= item.minStockAlert;

                return (
                  <tr key={item.id} className="hover:bg-slate-50/80 transition-colors group">
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-3">
                        <div className={`p-2 rounded-lg flex items-center justify-center ${isLowStock ? 'bg-red-50 text-red-500' : 'bg-slate-100 text-slate-500'}`}>
                          <Package className="w-5 h-5" />
                        </div>
                        <span className="text-sm font-bold text-slate-800">{item.name}</span>
                      </div>
                    </td>

                    <td className="px-6 py-4">
                      <span className="text-[11px] font-bold text-slate-600 bg-slate-100 px-2.5 py-1 rounded uppercase tracking-wider">
                        {item.sku}
                      </span>
                    </td>

                    <td className="px-6 py-4">
                      <span className="text-sm font-bold text-slate-700">₹{item.price.toLocaleString('en-IN')}</span>
                    </td>

                    <td className="px-6 py-4">
                      <div className="flex flex-col gap-1.5">
                        <div className="flex items-center gap-2">
                          <span className={`text-sm font-extrabold ${isLowStock ? 'text-red-600' : 'text-slate-700'}`}>
                            {item.stock} Units
                          </span>
                          {isLowStock ? (
                            <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded text-[10px] font-bold bg-red-50 text-red-600 uppercase tracking-wider">
                              <AlertTriangle className="w-3 h-3" />
                              Low
                            </span>
                          ) : (
                            <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded text-[10px] font-bold bg-emerald-50 text-emerald-600 uppercase tracking-wider">
                              <CheckCircle2 className="w-3 h-3" />
                              Healthy
                            </span>
                          )}
                        </div>
                        <span className="text-xs font-medium text-slate-400">
                          Min Alert: {item.minStockAlert}
                        </span>
                      </div>
                    </td>

                    <td className="px-6 py-4 text-right">
                      <button className="p-2 text-slate-400 hover:text-primary-600 hover:bg-primary-50 rounded-lg transition-colors">
                        <MoreVertical className="w-5 h-5" />
                      </button>
                    </td>
                  </tr>
                );
              })}

              {filteredInventory.length === 0 && (
                <tr>
                  <td colSpan={5} className="px-6 py-12 text-center text-slate-500 font-medium">
                    No inventory items found matching your criteria.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>

      <InventoryModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onSave={handleSaveItem}
      />
    </div>
  );
};

export default AdminInventory;
