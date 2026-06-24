import React, { useState, useEffect } from 'react';
import { X, Package, Clock, ShieldCheck, Info, PenTool, CheckCircle2, UserCheck, Phone, MapPin } from 'lucide-react';
import staffData from '../../mockData/staff.json';

interface AdminCustomerDetailsModalProps {
  customer: any;
  onClose: () => void;
}

const AdminCustomerDetailsModal: React.FC<AdminCustomerDetailsModalProps> = ({ customer, onClose }) => {
  const [activeTab, setActiveTab] = useState<'products' | 'history'>('products');
  const [tasks, setTasks] = useState<any[]>([]);

  useEffect(() => {
    const savedTasks = localStorage.getItem('staff_tasks');
    if (savedTasks) {
      const allTasks = JSON.parse(savedTasks);
      setTasks(allTasks.filter((t: any) => t.customerId === customer.id));
    } else {
      import('../../mockData/tasks.json').then(module => {
        setTasks(module.default.filter((t: any) => t.customerId === customer.id));
      });
    }
  }, [customer.id]);

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
      <div className="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" onClick={onClose}></div>
      <div className="bg-white rounded-3xl shadow-2xl w-full max-w-4xl relative z-10 flex flex-col max-h-[90vh] overflow-hidden animate-in fade-in zoom-in-95 duration-200">
        
        {/* Header */}
        <div className="p-6 border-b border-slate-100 bg-slate-50/50 flex justify-between items-start">
          <div className="flex gap-4 items-start">
            <div className="w-14 h-14 bg-primary-container text-primary rounded-2xl flex items-center justify-center text-xl font-black shadow-inner">
              {customer.name.charAt(0)}
            </div>
            <div>
              <h2 className="text-2xl font-black text-slate-800">{customer.name}</h2>
              <div className="flex flex-wrap items-center gap-3 mt-2 text-sm font-medium text-slate-500">
                <span className="flex items-center gap-1"><UserCheck className="w-4 h-4 text-slate-400"/> ID: {customer.id}</span>
                <span className="flex items-center gap-1"><Phone className="w-4 h-4 text-slate-400"/> {customer.phone}</span>
                <span className="flex items-center gap-1 truncate max-w-[300px]" title={customer.address}><MapPin className="w-4 h-4 text-slate-400"/> {customer.address}</span>
              </div>
            </div>
          </div>
          <button onClick={onClose} className="p-2 text-slate-400 hover:bg-slate-200 hover:text-slate-600 rounded-full transition-colors">
            <X className="w-6 h-6" />
          </button>
        </div>

        {/* Tabs */}
        <div className="flex border-b border-slate-200 bg-white px-6">
          <button 
            onClick={() => setActiveTab('products')}
            className={`px-6 py-4 font-bold text-sm border-b-2 transition-colors ${activeTab === 'products' ? 'border-primary text-primary' : 'border-transparent text-slate-500 hover:text-slate-700'}`}
          >
            Registered Products ({customer.products?.length || 0})
          </button>
          <button 
            onClick={() => setActiveTab('history')}
            className={`px-6 py-4 font-bold text-sm border-b-2 transition-colors ${activeTab === 'history' ? 'border-primary text-primary' : 'border-transparent text-slate-500 hover:text-slate-700'}`}
          >
            Service History ({tasks.length})
          </button>
        </div>

        {/* Content Scroll Area */}
        <div className="flex-1 overflow-y-auto p-6 bg-slate-50/30">
          
          {/* Products Tab */}
          {activeTab === 'products' && (
            <div className="space-y-4">
              {customer.products && customer.products.length > 0 ? (
                customer.products.map((product: any, idx: number) => {
                  const endYear = parseInt(product.warrantyEnd.split('-')[0] || '2000');
                  const isActive = endYear >= new Date().getFullYear();

                  return (
                    <div key={idx} className="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex flex-col md:flex-row gap-6">
                      <div className="w-12 h-12 bg-slate-100 rounded-xl flex items-center justify-center shrink-0">
                        <Package className="w-6 h-6 text-slate-500" />
                      </div>
                      <div className="flex-1 space-y-4">
                        <div className="flex justify-between items-start">
                          <div>
                            <h3 className="text-lg font-bold text-slate-800">{product.name}</h3>
                            <p className="text-xs font-mono font-bold text-slate-500 mt-1">SN: {product.id}</p>
                          </div>
                          {product.price && (
                            <div className="text-right">
                              <p className="text-xs font-bold text-slate-400 uppercase tracking-wider">Sale Price</p>
                              <p className="text-lg font-black text-slate-700">₹{product.price}</p>
                            </div>
                          )}
                        </div>

                        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 bg-slate-50 p-4 rounded-xl border border-slate-100">
                          <div>
                            <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Warranty Status</p>
                            <p className={`text-sm font-bold flex items-center gap-1 mt-1 ${isActive ? 'text-emerald-600' : 'text-red-500'}`}>
                              {isActive ? <ShieldCheck className="w-4 h-4"/> : <Info className="w-4 h-4"/>}
                              {isActive ? 'Active' : 'Expired'}
                            </p>
                            <p className="text-[10px] text-slate-500 mt-0.5">Ends: {product.warrantyEnd}</p>
                          </div>
                          
                          {product.amc && (
                            <>
                              <div>
                                <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">AMC Included</p>
                                <p className="text-sm font-bold text-slate-700 mt-1">{product.amc.included ? 'Yes' : 'No'}</p>
                              </div>
                              {product.amc.included && (
                                <>
                                  <div>
                                    <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Free Services</p>
                                    <p className="text-sm font-bold text-slate-700 mt-1">{product.amc.freeServices} Visits</p>
                                  </div>
                                  <div>
                                    <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Frequency</p>
                                    <p className="text-sm font-bold text-slate-700 mt-1">{product.amc.frequency}</p>
                                  </div>
                                </>
                              )}
                            </>
                          )}
                        </div>
                        
                        {product.coveredItems && product.coveredItems.length > 0 && (
                          <div>
                            <p className="text-xs font-bold text-slate-500 uppercase tracking-wider mb-2">Covered Components</p>
                            <div className="flex flex-wrap gap-2">
                              {product.coveredItems.map((item: string, i: number) => (
                                <span key={i} className="px-2.5 py-1 bg-slate-100 text-slate-600 text-[10px] font-bold uppercase tracking-wider rounded-md border border-slate-200">
                                  {item}
                                </span>
                              ))}
                            </div>
                          </div>
                        )}
                      </div>
                    </div>
                  );
                })
              ) : (
                <div className="text-center py-12 bg-white rounded-2xl border border-dashed border-slate-300">
                  <Package className="w-12 h-12 text-slate-300 mx-auto mb-3" />
                  <p className="text-slate-500 font-medium">No products registered for this customer yet.</p>
                </div>
              )}
            </div>
          )}

          {/* Service History Tab */}
          {activeTab === 'history' && (
            <div className="space-y-4">
              {tasks.length > 0 ? (
                tasks.slice().reverse().map((task: any) => (
                  <div key={task.id} className="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex flex-col md:flex-row gap-6">
                    <div className="w-16 flex flex-col items-center justify-center border-r border-slate-100 pr-6">
                      <p className="text-xs font-bold text-slate-400 uppercase">{new Date(task.date).toLocaleString('default', { month: 'short' })}</p>
                      <p className="text-2xl font-black text-slate-700">{new Date(task.date).getDate()}</p>
                      <p className="text-[10px] font-bold text-slate-400">{new Date(task.date).getFullYear()}</p>
                    </div>
                    <div className="flex-1 space-y-3">
                      <div className="flex justify-between items-start">
                        <div>
                          <span className={`inline-flex items-center gap-1.5 px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-wider border mb-2 ${
                            task.type === 'Complaint' ? 'bg-amber-50 text-amber-600 border-amber-100' :
                            task.type === 'Installation' ? 'bg-blue-50 text-blue-600 border-blue-100' :
                            'bg-purple-50 text-purple-600 border-purple-100'
                          }`}>
                            {task.type}
                          </span>
                          <h3 className="text-sm font-bold text-slate-800">{task.description || 'Routine Service Visit'}</h3>
                          <p className="text-xs font-mono text-slate-500 mt-1">Ticket: {task.id.toUpperCase()}</p>
                        </div>
                        <span className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider border ${
                          task.status === 'Completed' ? 'bg-emerald-50 text-emerald-600 border-emerald-100' :
                          task.status === 'In Progress' ? 'bg-blue-50 text-blue-600 border-blue-100' :
                          task.status === 'Scheduled' ? 'bg-slate-100 text-slate-600 border-slate-200' :
                          'bg-red-50 text-red-600 border-red-100'
                        }`}>
                          {task.status === 'Completed' && <CheckCircle2 className="w-3 h-3" />}
                          {task.status === 'In Progress' && <PenTool className="w-3 h-3" />}
                          {(task.status === 'Open' || task.status === 'Scheduled') && <Clock className="w-3 h-3" />}
                          {task.status}
                        </span>
                      </div>

                      <div className="bg-slate-50 p-3 rounded-lg flex justify-between items-center border border-slate-100">
                        <div className="flex items-center gap-2">
                          <div className="w-6 h-6 rounded-full bg-primary/10 text-primary flex items-center justify-center text-[10px] font-bold">
                            {staffData.find(s => s.id === task.assignedTo)?.name?.charAt(0) || '?'}
                          </div>
                          <p className="text-xs font-bold text-slate-700">
                            Tech: {staffData.find(s => s.id === task.assignedTo)?.name || 'Unassigned'}
                          </p>
                        </div>
                        {task.checkOutTime && (
                          <p className="text-[10px] font-medium text-slate-500">
                            Completed at {new Date(task.checkOutTime).toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})}
                          </p>
                        )}
                      </div>
                    </div>
                  </div>
                ))
              ) : (
                <div className="text-center py-12 bg-white rounded-2xl border border-dashed border-slate-300">
                  <Clock className="w-12 h-12 text-slate-300 mx-auto mb-3" />
                  <p className="text-slate-500 font-medium">No service history found for this customer.</p>
                </div>
              )}
            </div>
          )}

        </div>
      </div>
    </div>
  );
};

export default AdminCustomerDetailsModal;
