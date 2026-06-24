import React, { useState } from 'react';
import { ShieldCheck, Info, Package, Search, Download } from 'lucide-react';
import customersData from '../../mockData/customers.json';

const CustomerWarranties: React.FC = () => {
  const [searchTerm, setSearchTerm] = useState('');
  
  const [me, setMe] = useState<any>(() => {
    const saved = localStorage.getItem('customers_data');
    if (saved) {
      const parsed = JSON.parse(saved);
      return parsed.find((c: any) => c.id === 'c1') || customersData[0];
    }
    return customersData[0];
  });

  const filteredProducts = me.products.filter((p: any) => 
    p.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    p.id.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="space-y-6 pb-20 md:pb-0">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-surface-container-lowest p-6 rounded-3xl border border-outline-variant/30 shadow-sm">
        <div>
          <h1 className="text-headline-sm font-black text-on-surface flex items-center gap-2">
            <ShieldCheck className="w-8 h-8 text-primary" />
            Warranties & Products
          </h1>
          <p className="text-label-lg text-on-surface-variant mt-1">Manage your registered systems and view warranty coverage.</p>
        </div>
        <div className="relative w-full sm:w-auto">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-on-surface-variant" />
          <input 
            type="text" 
            placeholder="Search by serial or name..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full sm:w-64 pl-9 pr-4 py-2 bg-surface-container border border-outline-variant rounded-xl focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none text-sm font-medium"
          />
        </div>
      </div>

      <div className="grid grid-cols-1 xl:grid-cols-2 gap-6">
        {filteredProducts.map(product => {
          // Mock some logic for active/expired
          const endYear = parseInt(product.warrantyEnd.split('-')[0]);
          const isActive = endYear >= new Date().getFullYear();

          return (
            <div key={product.id} className="bg-white rounded-3xl border border-outline-variant/30 shadow-sm overflow-hidden flex flex-col hover:border-primary/30 transition-all group">
              <div className="p-6 border-b border-surface-container-highest bg-surface-container-lowest flex justify-between items-start">
                <div className="flex items-start gap-4">
                  <div className="w-12 h-12 rounded-xl bg-primary-container text-on-primary flex items-center justify-center shrink-0">
                    <Package className="w-6 h-6" />
                  </div>
                  <div>
                    <h2 className="text-title-lg font-black text-on-surface">{product.name}</h2>
                    <p className="text-label-sm font-mono font-bold text-on-surface-variant mt-1 bg-surface-container px-2 py-0.5 rounded w-fit">SN: {product.id}</p>
                  </div>
                </div>
                <button className="p-2 text-outline hover:text-primary hover:bg-primary-fixed rounded-lg transition-colors" title="Download Warranty Certificate">
                  <Download className="w-5 h-5" />
                </button>
              </div>

              <div className="p-6 flex-1 flex flex-col gap-6">
                
                {/* Status Bar */}
                <div className={`p-4 rounded-xl border flex items-center justify-between ${isActive ? 'bg-emerald-50 border-emerald-200' : 'bg-error/10 border-error/20'}`}>
                  <div className="flex items-center gap-3">
                    {isActive ? <ShieldCheck className="w-6 h-6 text-emerald-600" /> : <Info className="w-6 h-6 text-error" />}
                    <div>
                      <p className={`text-label-md font-bold uppercase tracking-wider ${isActive ? 'text-emerald-700' : 'text-error'}`}>
                        {isActive ? 'Warranty Active' : 'Warranty Expired'}
                      </p>
                      <p className={`text-xs font-medium ${isActive ? 'text-emerald-600/80' : 'text-error/80'}`}>Valid until {product.warrantyEnd}</p>
                    </div>
                  </div>
                </div>

                {/* Covered Items */}
                <div>
                  <h3 className="text-xs font-bold text-on-surface-variant uppercase tracking-widest mb-3 border-b border-surface-container-highest pb-2">Covered Under Warranty</h3>
                  <div className="grid grid-cols-2 gap-y-2 gap-x-4">
                    {product.coveredItems.map((item, idx) => (
                      <div key={idx} className="flex items-center gap-2">
                        <div className="w-1.5 h-1.5 rounded-full bg-primary"></div>
                        <span className="text-sm font-medium text-on-surface">{item}</span>
                      </div>
                    ))}
                  </div>
                </div>

                <div className="mt-auto pt-4 flex gap-3">
                  <button className="flex-1 py-2.5 font-bold text-primary bg-primary-fixed hover:bg-primary-container rounded-xl transition-colors">
                    Request Service
                  </button>
                  <button className="flex-1 py-2.5 font-bold text-on-surface-variant bg-surface-container hover:bg-surface-container-highest rounded-xl transition-colors">
                    View Manual
                  </button>
                </div>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
};

export default CustomerWarranties;
