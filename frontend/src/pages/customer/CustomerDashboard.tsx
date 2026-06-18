import React from 'react';
import { AlertCircle, Wrench, ShieldCheck, CalendarCheck, MoreHorizontal, FileText, Download, ChevronRight } from 'lucide-react';
import customersData from '../../mockData/customers.json';

const CustomerDashboard: React.FC = () => {
  const me = customersData[0]; // Acme Corp

  return (
    <div className="space-y-8 pb-20 md:pb-0">
      
      {/* Page Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-white p-6 rounded-2xl shadow-[0_2px_10px_-3px_rgba(6,81,237,0.1)] border border-slate-100 relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-full bg-gradient-to-l from-primary-50/50 to-transparent pointer-events-none"></div>

        <div className="relative z-10">
          <h1 className="text-2xl font-extrabold text-slate-800 tracking-tight">Dashboard</h1>
          <p className="text-slate-500 text-sm mt-1 font-medium">Welcome back, <span className="text-slate-700 font-bold">{me.name}</span>. Here is your account overview.</p>
        </div>
        <button className="relative z-10 flex items-center gap-2 bg-gradient-to-r from-primary-500 to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white px-5 py-2.5 rounded-xl text-sm font-bold transition-all shadow-[0_8px_16px_-6px_rgba(0,135,62,0.4)] hover:shadow-[0_8px_20px_-6px_rgba(0,135,62,0.6)] transform hover:-translate-y-0.5">
          <Wrench className="w-4 h-4" />
          Raise Service Request
        </button>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        {/* Left Column - Details */}
        <div className="lg:col-span-1 space-y-8">
          
          {/* AMC Status Card */}
          <div className="bg-white rounded-2xl border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.03)] overflow-hidden relative group">
            <div className={`absolute top-0 right-0 w-32 h-32 blur-[50px] pointer-events-none transition-all duration-700 ${me.amcStatus === 'Active' ? 'bg-emerald-500/10 group-hover:bg-emerald-500/20' : 'bg-amber-500/10 group-hover:bg-amber-500/20'}`}></div>

            <div className="px-6 py-5 border-b border-slate-100 bg-slate-50/50 relative z-10">
              <h2 className="text-sm font-bold text-slate-800 uppercase tracking-wider">Contract Status</h2>
            </div>
            <div className="p-6 relative z-10">
              <div className="flex items-center gap-5 mb-5">
                <div className={`p-4 rounded-2xl shadow-lg transition-transform duration-300 group-hover:scale-110 group-hover:rotate-3 ${me.amcStatus === 'Active' ? 'bg-gradient-to-br from-emerald-400 to-emerald-600 text-white shadow-emerald-500/30' : 'bg-gradient-to-br from-amber-400 to-amber-600 text-white shadow-amber-500/30'}`}>
                  {me.amcStatus === 'Active' ? <CalendarCheck className="w-7 h-7" /> : <AlertCircle className="w-7 h-7" />}
                </div>
                <div>
                  <p className="text-[10px] text-slate-400 uppercase tracking-widest font-bold mb-1">Current AMC</p>
                  <p className="text-2xl font-extrabold text-slate-800 tracking-tight">{me.amcStatus}</p>
                </div>
              </div>
              
              <div className="bg-slate-50/80 backdrop-blur-sm rounded-xl p-4 border border-slate-100 group-hover:border-emerald-100 transition-colors">
                <div className="flex justify-between items-center text-sm">
                  <span className="text-slate-500 font-medium">Next Scheduled Visit</span>
                  <span className="font-bold text-slate-800 bg-white px-2 py-1 rounded-md shadow-sm border border-slate-100">{me.nextAmcDate}</span>
                </div>
              </div>
            </div>
          </div>

          {/* Account Summary */}
          <div className="bg-white rounded-2xl border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.03)] overflow-hidden">
            <div className="px-6 py-5 border-b border-slate-100 bg-slate-50/50">
              <h2 className="text-sm font-bold text-slate-800 uppercase tracking-wider">Account Details</h2>
            </div>
            <div className="p-0">
              <ul className="divide-y divide-slate-50 text-sm">
                <li className="flex flex-col p-5 hover:bg-slate-50/50 transition-colors">
                  <span className="text-[10px] uppercase font-bold tracking-widest text-slate-400 mb-1">Client ID</span>
                  <span className="font-bold text-slate-800">{me.id}</span>
                </li>
                <li className="flex flex-col p-5 hover:bg-slate-50/50 transition-colors">
                  <span className="text-[10px] uppercase font-bold tracking-widest text-slate-400 mb-1">Contact Phone</span>
                  <span className="font-bold text-slate-800">{me.phone}</span>
                </li>
                <li className="flex flex-col p-5 hover:bg-slate-50/50 transition-colors">
                  <span className="text-[10px] uppercase font-bold tracking-widest text-slate-400 mb-1">Service Address</span>
                  <span className="font-bold text-slate-800 leading-relaxed">{me.address}</span>
                </li>
              </ul>
            </div>
          </div>
        </div>

        {/* Right Column - Data Tables */}
        <div className="lg:col-span-2 space-y-8">
          
          {/* Registered Systems Table */}
          <div className="bg-white rounded-2xl border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.03)] flex flex-col overflow-hidden">
            <div className="px-6 py-5 border-b border-slate-100 bg-slate-50/50 flex justify-between items-center">
              <h2 className="text-sm font-bold text-slate-800 uppercase tracking-wider">Registered Systems <span className="ml-2 bg-primary-100 text-primary-700 px-2 py-0.5 rounded-full text-xs">{me.products.length}</span></h2>
              <button className="text-xs font-bold text-primary-600 hover:text-primary-700 bg-primary-50 px-3 py-1.5 rounded-lg transition-colors flex items-center gap-1">
                Register New <ChevronRight className="w-3 h-3" />
              </button>
            </div>
            
            <div className="overflow-x-auto">
              <table className="w-full text-sm text-left">
                <thead className="text-[10px] text-slate-400 bg-white border-b border-slate-100 uppercase tracking-widest">
                  <tr>
                    <th className="px-6 py-4 font-bold">Product Details</th>
                    <th className="px-6 py-4 font-bold">Serial ID</th>
                    <th className="px-6 py-4 font-bold">Warranty Exp.</th>
                    <th className="px-6 py-4 font-bold text-right">Actions</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-50">
                  {me.products.map(product => (
                    <tr key={product.id} className="hover:bg-slate-50/80 transition-colors group">
                      <td className="px-6 py-5">
                        <div className="font-bold text-slate-800 mb-1">{product.name}</div>
                        <div className="text-[11px] font-medium text-slate-500 max-w-[200px] truncate">
                          {product.coveredItems.join(', ')}
                        </div>
                      </td>
                      <td className="px-6 py-5 text-slate-600 font-mono text-xs font-medium bg-slate-50/50">{product.id}</td>
                      <td className="px-6 py-5">
                        <span className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-emerald-50 text-emerald-700 border border-emerald-100 text-[11px] font-bold shadow-sm group-hover:border-emerald-200 transition-colors">
                          <ShieldCheck className="w-3.5 h-3.5 text-emerald-500" />
                          {product.warrantyEnd}
                        </span>
                      </td>
                      <td className="px-6 py-5 text-right">
                        <div className="flex items-center justify-end gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                          <button className="p-2 bg-white border border-slate-200 text-slate-400 hover:text-primary-600 hover:border-primary-200 rounded-lg shadow-sm transition-all" title="Download Manual">
                            <Download className="w-4 h-4" />
                          </button>
                          <button className="p-2 bg-white border border-slate-200 text-slate-400 hover:text-slate-700 hover:border-slate-300 rounded-lg shadow-sm transition-all">
                            <MoreHorizontal className="w-4 h-4" />
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>

          {/* Recent Service History - Placeholder Table */}
          <div className="bg-white rounded-2xl border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.03)] flex flex-col overflow-hidden">
            <div className="px-6 py-5 border-b border-slate-100 bg-slate-50/50 flex justify-between items-center">
              <h2 className="text-sm font-bold text-slate-800 uppercase tracking-wider">Recent Service History</h2>
              <button className="text-xs font-bold text-slate-500 hover:text-slate-800 flex items-center gap-1.5 bg-white border border-slate-200 px-3 py-1.5 rounded-lg shadow-sm transition-all">
                <FileText className="w-3.5 h-3.5" />
                View Invoices
              </button>
            </div>
            
            <div className="p-12 text-center bg-slate-50/30">
              <div className="w-16 h-16 bg-white rounded-2xl flex items-center justify-center mx-auto mb-4 border border-slate-100 shadow-sm">
                <FileText className="w-8 h-8 text-slate-300" />
              </div>
              <p className="text-sm font-bold text-slate-700 mb-1">No recent service history found.</p>
              <p className="text-xs font-medium text-slate-400">Past AMC visits and completed repairs will appear here.</p>
            </div>
          </div>

        </div>
      </div>
    </div>
  );
};

export default CustomerDashboard;
