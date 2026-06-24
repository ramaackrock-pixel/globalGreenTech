import React, { useState, useEffect } from 'react';
import { Filter, MoreVertical, ShieldAlert, ShieldCheck, Download, Plus, PackagePlus, X } from 'lucide-react';
import customersData from '../../mockData/customers.json';
import { useSearch } from '../../context/SearchContextProvider'
import CustomerModal from './CustomerModal';
import AdminCustomerDetailsModal from './AdminCustomerDetailsModal';

const AdminCustomers: React.FC = () => {
  const [amcFilter, setAmcFilter] = useState<string>('All');
  const [categoryFilter, setCategoryFilter] = useState<string>('All Categories');
  const [isModalOpen, setIsModalOpen] = useState<boolean>(false);
  const [customers, setCustomers] = useState<any[]>(() => {
    const saved = localStorage.getItem('customers_data');
    if (saved) return JSON.parse(saved);
    return customersData;
  });

  const [addProductModalOpen, setAddProductModalOpen] = useState(false);
  const [selectedCustomerId, setSelectedCustomerId] = useState<string | null>(null);
  const [viewDetailsCustomer, setViewDetailsCustomer] = useState<any | null>(null);
  
  // New Product State
  const [newProductName, setNewProductName] = useState('');
  const [productPrice, setProductPrice] = useState('');
  const [warrantyStart, setWarrantyStart] = useState(new Date().toISOString().split('T')[0]);
  const [warrantyEnd, setWarrantyEnd] = useState('');
  const [coveredItems, setCoveredItems] = useState('Pump, Membrane, Adapter, Filters');
  const [includesAmc, setIncludesAmc] = useState('Yes');
  const [freeServices, setFreeServices] = useState('3');
  const [serviceFrequency, setServiceFrequency] = useState('Quarterly');

  useEffect(() => {
    localStorage.setItem('customers_data', JSON.stringify(customers));
  }, [customers]);

  const { searchQuery } = useSearch();

  const filteredCustomers = customers.filter((customers) => {
    const matchesCategory = categoryFilter === 'All Categories' || customers.category === categoryFilter;
    const matchesFilter = amcFilter === 'All' || customers.amcStatus === amcFilter;

    const searchResults = searchQuery.trim() === '' || customers.name.toLowerCase().includes(searchQuery.toLowerCase());

    return matchesCategory && matchesFilter && searchResults;
  });

  const handleSaveCustomer = (newCustomer: any) => {
    const newId = `c${customers.length + 1}`;
    const customer = {
      id: newId,
      ...newCustomer,
      products: [] // Initialize with empty products array
    };
    
    setIsModalOpen(false);
    setCustomers((prev) => [...prev, customer]);
  };

  const handleAddProduct = (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedCustomerId) return;

    const newProduct = {
      id: `p${Math.floor(Math.random() * 10000)}`,
      name: newProductName,
      price: productPrice,
      warrantyStart: warrantyStart,
      warrantyEnd: warrantyEnd,
      coveredItems: coveredItems.split(',').map(i => i.trim()),
      amc: {
        included: includesAmc === 'Yes',
        freeServices: parseInt(freeServices) || 0,
        frequency: serviceFrequency
      }
    };

    setCustomers(prev => prev.map(c => {
      if (c.id === selectedCustomerId) {
        return { ...c, products: [...c.products, newProduct] };
      }
      return c;
    }));

    setAddProductModalOpen(false);
    setNewProductName('');
    setProductPrice('');
    setWarrantyEnd('');
    setIncludesAmc('Yes');
    setFreeServices('3');
    setServiceFrequency('Quarterly');
    alert('Product and Warranty successfully registered to customer!');
  };

  return (
    <div className="space-y-8 pb-20 md:pb-0">

      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-white p-6 rounded-2xl shadow-[0_2px_10px_-3px_rgba(6,81,237,0.1)] border border-slate-100 relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-full bg-gradient-to-l from-primary-50/50 to-transparent pointer-events-none"></div>

        <div className="relative z-10">
          <h1 className="text-2xl font-extrabold text-slate-800 tracking-tight">Customers & AMC</h1>
          <p className="text-slate-500 text-sm mt-1 font-medium">Manage customer profiles, installed products, and AMC renewals.</p>
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
            New Customer
          </button>
        </div>
      </div>

      {/* Main Content Box */}
      <div className="bg-white rounded-2xl shadow-[0_4px_20px_-4px_rgba(0,0,0,0.03)] border border-slate-100 overflow-hidden">

        {/* Toolbar (Filters) */}
        <div className="p-6 border-b border-slate-100 bg-slate-50/50 flex flex-col lg:flex-row gap-4 justify-end items-center">

          <div className="flex gap-3 w-full lg:w-auto">
            <div className="flex items-center gap-2 bg-white px-3 py-1.5 rounded-xl border border-slate-300 shadow-sm w-full sm:w-auto">
              <Filter className="w-4 h-4 text-slate-400" />
              <select className="bg-transparent text-sm font-bold text-slate-700 outline-none appearance-none cursor-pointer w-full pl-1 pr-6 py-1" value={categoryFilter} onChange={(e) => setCategoryFilter(e.target.value)}>
                <option value="All Categories">All Categories</option>
                <option value="Commercial">Commercial</option>
                <option value="Residential">Residential</option>
              </select>
            </div>

            <div className="flex items-center gap-2 bg-white px-3 py-1.5 rounded-xl border border-slate-300 shadow-sm w-full sm:w-auto">
              <select className="bg-transparent text-sm font-bold text-slate-700 outline-none appearance-none cursor-pointer w-full pl-1 pr-6 py-1" value={amcFilter} onChange={(e) => setAmcFilter(e.target.value)}>
                <option value="All">AMC Status: All</option>
                <option value="Active">AMC: Active</option>
                <option value="Due Soon">AMC: Due Soon</option>
                <option value="Expired">AMC: Expired</option>
              </select>
            </div>
          </div>
        </div>

        {/* Data Table */}
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse min-w-[800px]">
            <thead>
              <tr className="bg-slate-50/50 border-b border-slate-100">
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">Customer Details</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">Contact Info</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">AMC Status</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">Products</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">

              {filteredCustomers.map((customer) => (
                <tr 
                  key={customer.id} 
                  className="hover:bg-slate-50/80 transition-colors group cursor-pointer"
                  onClick={() => setViewDetailsCustomer(customer)}
                >

                  <td className="px-6 py-4">
                    <div className="flex flex-col">
                      <span className="text-sm font-bold text-slate-800">{customer.name}</span>
                      <div className="flex items-center gap-2 mt-1">
                        <span className="text-[10px] font-bold text-slate-500 bg-slate-100 px-2 py-0.5 rounded uppercase tracking-wider">{customer.id}</span>
                        <span className="text-[10px] font-bold text-primary-600 bg-primary-50 px-2 py-0.5 rounded uppercase tracking-wider">{customer.category}</span>
                        {customer.leadSource && (
                          <span className="text-[10px] font-bold text-slate-500 bg-slate-100 px-2 py-0.5 rounded uppercase tracking-wider">Lead: {customer.leadSource}</span>
                        )}
                      </div>
                    </div>
                  </td>

                  <td className="px-6 py-4">
                    <div className="flex flex-col">
                      <span className="text-sm font-medium text-slate-700">{customer.phone}</span>
                      <span className="text-xs text-slate-500 truncate max-w-[200px]" title={customer.address}>{customer.address}</span>
                    </div>
                  </td>

                  <td className="px-6 py-4">
                    <div className="flex flex-col gap-1">
                      <span className={`inline-flex items-center gap-1.5 w-fit px-2.5 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider border ${customer.amcStatus === 'Active' ? 'bg-emerald-50 text-emerald-600 border-emerald-100' :
                        customer.amcStatus === 'Due Soon' ? 'bg-amber-50 text-amber-600 border-amber-100' :
                          'bg-red-50 text-red-600 border-red-100'
                        }`}>
                        {customer.amcStatus === 'Active' ? <ShieldCheck className="w-3 h-3" /> : <ShieldAlert className="w-3 h-3" />}
                        {customer.amcStatus}
                      </span>
                      <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider ml-1">
                        Renewal: {new Date(customer.nextAmcDate).toLocaleDateString('en-GB')}
                      </span>
                      {customer.amcVisitsPerYear && (
                        <span className="text-[10px] font-bold text-slate-500 bg-slate-100 w-fit px-2 py-0.5 rounded uppercase tracking-wider mt-1">
                          Visits: {customer.amcVisitsPerYear}/Year
                        </span>
                      )}
                    </div>
                  </td>

                  <td className="px-6 py-4">
                    <div className="flex flex-col gap-1">
                      <span className="text-sm font-bold text-slate-700">
                        {customer.products.length} {customer.products.length === 1 ? 'Unit' : 'Units'}
                      </span>
                      <span className="text-xs font-medium text-slate-500 truncate max-w-[150px]">
                        {customer.products[0]?.name}
                      </span>
                    </div>
                  </td>

                  <td className="px-6 py-4 text-right">
                    <div className="flex justify-end gap-2">
                      <button 
                        onClick={(e) => {
                          e.stopPropagation(); // Prevent opening details modal
                          setSelectedCustomerId(customer.id);
                          setAddProductModalOpen(true);
                        }}
                        className="p-2 text-emerald-600 hover:text-emerald-700 hover:bg-emerald-50 rounded-lg transition-colors font-bold text-[10px] uppercase tracking-wider flex items-center gap-1"
                        title="Register New Product"
                      >
                        <PackagePlus className="w-4 h-4" /> Add Product
                      </button>
                      <button 
                        onClick={(e) => e.stopPropagation()}
                        className="p-2 text-slate-400 hover:text-primary-600 hover:bg-primary-50 rounded-lg transition-colors"
                      >
                        <MoreVertical className="w-5 h-5" />
                      </button>
                    </div>
                  </td>

                </tr>
              ))}

            </tbody>
          </table>
        </div>
      </div>

      <CustomerModal 
        isOpen={isModalOpen} 
        onClose={() => setIsModalOpen(false)} 
        onSave={handleSaveCustomer} 
      />

      {/* Customer Details Modal */}
      {viewDetailsCustomer && (
        <AdminCustomerDetailsModal 
          customer={viewDetailsCustomer} 
          onClose={() => setViewDetailsCustomer(null)} 
        />
      )}

      {/* Add Product Modal */}
      {addProductModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" onClick={() => setAddProductModalOpen(false)}></div>
          <div className="bg-white rounded-3xl shadow-2xl w-full max-w-lg relative z-10 p-6 overflow-hidden animate-in fade-in zoom-in-95 duration-200">
            <div className="flex justify-between items-start mb-6">
              <div>
                <h2 className="text-xl font-black text-slate-800">Register New Product</h2>
                <p className="text-sm font-medium text-slate-500">Add an RO system to {customers.find(c => c.id === selectedCustomerId)?.name}</p>
              </div>
              <button onClick={() => setAddProductModalOpen(false)} className="p-2 text-slate-400 hover:bg-slate-100 rounded-full transition-colors">
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleAddProduct} className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-bold text-slate-700 uppercase tracking-wide">Product Name / Model</label>
                  <input 
                    type="text" 
                    value={newProductName}
                    onChange={(e) => setNewProductName(e.target.value)}
                    placeholder="e.g. Commercial RO 1000LPH"
                    className="w-full p-3 rounded-xl border border-slate-300 focus:border-primary-500 outline-none"
                    required
                  />
                </div>
                <div className="space-y-1.5">
                  <label className="text-xs font-bold text-slate-700 uppercase tracking-wide">Sale Price (₹)</label>
                  <input 
                    type="number" 
                    value={productPrice}
                    onChange={(e) => setProductPrice(e.target.value)}
                    placeholder="e.g. 25000"
                    className="w-full p-3 rounded-xl border border-slate-300 focus:border-primary-500 outline-none"
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-bold text-slate-700 uppercase tracking-wide">Warranty Start</label>
                  <input 
                    type="date" 
                    value={warrantyStart}
                    onChange={(e) => setWarrantyStart(e.target.value)}
                    className="w-full p-3 rounded-xl border border-slate-300 focus:border-primary-500 outline-none"
                    required
                  />
                </div>
                <div className="space-y-1.5">
                  <label className="text-xs font-bold text-slate-700 uppercase tracking-wide">Warranty End</label>
                  <input 
                    type="date" 
                    value={warrantyEnd}
                    onChange={(e) => setWarrantyEnd(e.target.value)}
                    className="w-full p-3 rounded-xl border border-slate-300 focus:border-primary-500 outline-none"
                    required
                  />
                </div>
              </div>

              <div className="grid grid-cols-3 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-bold text-slate-700 uppercase tracking-wide">AMC Included</label>
                  <select 
                    value={includesAmc}
                    onChange={(e) => setIncludesAmc(e.target.value)}
                    className="w-full p-3 rounded-xl border border-slate-300 focus:border-primary-500 outline-none appearance-none cursor-pointer"
                  >
                    <option value="Yes">Yes</option>
                    <option value="No">No</option>
                  </select>
                </div>
                <div className="space-y-1.5">
                  <label className="text-xs font-bold text-slate-700 uppercase tracking-wide">Free Services</label>
                  <input 
                    type="number" 
                    value={freeServices}
                    onChange={(e) => setFreeServices(e.target.value)}
                    disabled={includesAmc === 'No'}
                    className="w-full p-3 rounded-xl border border-slate-300 focus:border-primary-500 outline-none disabled:bg-slate-100 disabled:text-slate-400"
                  />
                </div>
                <div className="space-y-1.5">
                  <label className="text-xs font-bold text-slate-700 uppercase tracking-wide">Frequency</label>
                  <select 
                    value={serviceFrequency}
                    onChange={(e) => setServiceFrequency(e.target.value)}
                    disabled={includesAmc === 'No'}
                    className="w-full p-3 rounded-xl border border-slate-300 focus:border-primary-500 outline-none appearance-none cursor-pointer disabled:bg-slate-100 disabled:text-slate-400"
                  >
                    <option value="Quarterly">Quarterly</option>
                    <option value="Tri-Annual">Tri-Annual</option>
                    <option value="Bi-Annual">Bi-Annual</option>
                  </select>
                </div>
              </div>

              <div className="space-y-1.5">
                <label className="text-xs font-bold text-slate-700 uppercase tracking-wide">Covered Items (Comma separated)</label>
                <textarea 
                  value={coveredItems}
                  onChange={(e) => setCoveredItems(e.target.value)}
                  className="w-full p-3 rounded-xl border border-slate-300 focus:border-primary-500 outline-none resize-none"
                  rows={2}
                  required
                />
              </div>

              <div className="flex gap-3 pt-4">
                <button type="button" onClick={() => setAddProductModalOpen(false)} className="flex-1 py-3 font-bold text-slate-600 bg-slate-100 hover:bg-slate-200 rounded-xl transition-colors">Cancel</button>
                <button type="submit" className="flex-1 py-3 font-bold text-white bg-gradient-to-r from-[#00873E] to-[#006b31] shadow-[0_4px_12px_-2px_rgba(0,135,62,0.4)] hover:shadow-[0_8px_16px_-4px_rgba(0,135,62,0.5)] rounded-xl transition-all">Register Product</button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default AdminCustomers;

