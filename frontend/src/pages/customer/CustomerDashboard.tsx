import React, { useState } from 'react';
import { AlertCircle, Wrench, ShieldCheck, CalendarCheck, MoreHorizontal, FileText, Download, ChevronRight, X } from 'lucide-react';
import customersData from '../../mockData/customers.json';

const CustomerDashboard: React.FC = () => {
  const [me, setMe] = useState<any>(() => {
    const saved = localStorage.getItem('customers_data');
    if (saved) {
      const parsed = JSON.parse(saved);
      return parsed.find((c: any) => c.id === 'c1') || customersData[0];
    }
    return customersData[0];
  });
  
  const [showComplaintModal, setShowComplaintModal] = React.useState(false);
  const [complaintText, setComplaintText] = React.useState('');
  
  const handleRaiseComplaint = (e: React.FormEvent) => {
    e.preventDefault();
    if (!complaintText.trim()) return;

    const savedTasks = localStorage.getItem('staff_tasks');
    let tasks = savedTasks ? JSON.parse(savedTasks) : [];
    
    // Also merge with mock tasks if empty for simulation
    if (tasks.length === 0) {
      // we could import mockData, but let's just append
    }

    const newTask = {
      id: `CMPT-${Math.floor(Math.random() * 1000)}`,
      customerId: me.id,
      type: 'Complaint',
      status: 'Open',
      assignedTo: 'Unassigned',
      date: new Date().toISOString().split('T')[0],
      description: complaintText
    };

    tasks.push(newTask);
    localStorage.setItem('staff_tasks', JSON.stringify(tasks));
    
    setComplaintText('');
    setShowComplaintModal(false);
    alert('Your service request has been submitted. A technician will be assigned shortly.');
  };

  return (
    <div className="space-y-8 pb-20 md:pb-0">
      
      {/* Page Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 card relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-full bg-gradient-to-l from-primary-container/50 to-transparent pointer-events-none"></div>

        <div className="relative z-10">
          <h1 className="text-headline-lg text-on-surface">Dashboard</h1>
          <p className="text-body-md text-on-surface-variant mt-1">Welcome back, <span className="text-on-surface font-bold">{me.name}</span>. Here is your account overview.</p>
        </div>
        <button 
          onClick={() => setShowComplaintModal(true)}
          className="relative z-10 flex items-center gap-2 btn-primary px-5 py-2.5"
        >
          <Wrench className="w-4 h-4" />
          Raise Service Request
        </button>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        {/* Left Column - Details */}
        <div className="lg:col-span-1 space-y-8">
          
          {/* AMC Status Card */}
          <div className="card relative overflow-hidden group !p-0">
            <div className={`absolute top-0 right-0 w-32 h-32 blur-[50px] pointer-events-none transition-all duration-700 ${me.amcStatus === 'Active' ? 'bg-primary/10 group-hover:bg-primary/20' : 'bg-error/10 group-hover:bg-error/20'}`}></div>

            <div className="px-6 py-5 border-b border-outline-variant bg-surface-container relative z-10">
              <h2 className="text-label-lg font-bold text-on-surface uppercase tracking-wider">Contract Status</h2>
            </div>
            <div className="p-6 relative z-10">
              <div className="flex items-center gap-5 mb-5">
                <div className={`p-4 rounded-2xl shadow-lg transition-transform duration-300 group-hover:scale-110 group-hover:rotate-3 ${me.amcStatus === 'Active' ? 'bg-gradient-to-br from-primary to-primary-container text-on-primary shadow-primary/30' : 'bg-gradient-to-br from-error to-error-container text-on-error shadow-error/30'}`}>
                  {me.amcStatus === 'Active' ? <CalendarCheck className="w-7 h-7" /> : <AlertCircle className="w-7 h-7" />}
                </div>
                <div>
                  <p className="text-label-sm text-on-surface-variant uppercase tracking-widest font-bold mb-1">Current AMC</p>
                  <p className="text-headline-md font-extrabold text-on-surface tracking-tight">{me.amcStatus}</p>
                </div>
              </div>
              
              <div className="bg-surface-container-lowest backdrop-blur-sm rounded-xl p-4 border border-outline-variant group-hover:border-primary transition-colors">
                <div className="flex justify-between items-center text-sm">
                  <span className="text-on-surface-variant font-medium">Next Scheduled Visit</span>
                  <span className="font-bold text-on-surface bg-background px-2 py-1 rounded-md shadow-sm border border-outline-variant">{me.nextAmcDate}</span>
                </div>
              </div>
            </div>
          </div>

          {/* Account Summary */}
          <div className="card !p-0 overflow-hidden">
            <div className="px-6 py-5 border-b border-surface-container-highest bg-surface-container-lowest">
              <h2 className="text-label-lg font-bold text-on-surface uppercase tracking-wider">Account Details</h2>
            </div>
            <div className="p-0">
              <ul className="divide-y divide-surface-container-highest text-sm">
                <li className="flex flex-col p-5 hover:bg-surface-container/50 transition-colors">
                  <span className="text-[10px] uppercase font-bold tracking-widest text-on-surface-variant mb-1">Client ID</span>
                  <span className="font-bold text-on-surface">{me.id}</span>
                </li>
                <li className="flex flex-col p-5 hover:bg-surface-container/50 transition-colors">
                  <span className="text-[10px] uppercase font-bold tracking-widest text-on-surface-variant mb-1">Contact Phone</span>
                  <span className="font-bold text-on-surface">{me.phone}</span>
                </li>
                <li className="flex flex-col p-5 hover:bg-surface-container/50 transition-colors">
                  <span className="text-[10px] uppercase font-bold tracking-widest text-on-surface-variant mb-1">Service Address</span>
                  <span className="font-bold text-on-surface leading-relaxed">{me.address}</span>
                </li>
              </ul>
            </div>
          </div>
        </div>

        {/* Right Column - Data Tables */}
        <div className="lg:col-span-2 space-y-8">
          
          {/* Registered Systems Table */}
          <div className="card !p-0 flex flex-col overflow-hidden">
            <div className="px-6 py-5 border-b border-surface-container-highest bg-surface-container-lowest flex justify-between items-center">
              <h2 className="text-label-lg font-bold text-on-surface uppercase tracking-wider">Registered Systems <span className="ml-2 bg-primary-fixed text-primary px-2 py-0.5 rounded-full text-xs">{me.products.length}</span></h2>
              <button className="text-xs font-bold text-primary hover:text-primary-container bg-primary-fixed px-3 py-1.5 rounded-lg transition-colors flex items-center gap-1">
                Register New <ChevronRight className="w-3 h-3" />
              </button>
            </div>
            
            <div className="overflow-x-auto">
              <table className="w-full text-sm text-left">
                <thead className="text-label-sm text-on-surface-variant bg-surface-container-lowest border-b border-surface-container-highest uppercase tracking-widest">
                  <tr>
                    <th className="px-6 py-4 font-bold">Product Details</th>
                    <th className="px-6 py-4 font-bold">Serial ID</th>
                    <th className="px-6 py-4 font-bold">Warranty Exp.</th>
                    <th className="px-6 py-4 font-bold text-right">Actions</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-surface-container-highest">
                  {me.products.map(product => (
                    <tr key={product.id} className="hover:bg-surface-container/50 transition-colors group">
                      <td className="px-6 py-5">
                        <div className="font-bold text-on-surface mb-1">{product.name}</div>
                        <div className="text-label-md font-medium text-on-surface-variant max-w-[200px] truncate">
                          {product.coveredItems.join(', ')}
                        </div>
                      </td>
                      <td className="px-6 py-5 text-on-surface-variant font-mono text-xs font-medium bg-surface-container/50">{product.id}</td>
                      <td className="px-6 py-5">
                        <span className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-primary-fixed text-primary border border-primary-container text-[11px] font-bold shadow-sm group-hover:border-primary transition-colors">
                          <ShieldCheck className="w-3.5 h-3.5 text-primary" />
                          {product.warrantyEnd}
                        </span>
                      </td>
                      <td className="px-6 py-5 text-right">
                        <div className="flex items-center justify-end gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                          <button className="p-2 bg-surface-container-lowest border border-outline-variant text-outline hover:text-primary hover:border-primary-container rounded-lg shadow-sm transition-all" title="Download Manual">
                            <Download className="w-4 h-4" />
                          </button>
                          <button className="p-2 bg-surface-container-lowest border border-outline-variant text-outline hover:text-on-surface hover:border-outline rounded-lg shadow-sm transition-all">
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
          <div className="card !p-0 flex flex-col overflow-hidden">
            <div className="px-6 py-5 border-b border-surface-container-highest bg-surface-container-lowest flex justify-between items-center">
              <h2 className="text-label-lg font-bold text-on-surface uppercase tracking-wider">Recent Service History</h2>
              <button className="text-xs font-bold text-on-surface-variant hover:text-on-surface flex items-center gap-1.5 bg-surface-container-lowest border border-outline-variant px-3 py-1.5 rounded-lg shadow-sm transition-all">
                <FileText className="w-3.5 h-3.5" />
                View Invoices
              </button>
            </div>
            
            <div className="p-12 text-center bg-background">
              <div className="w-16 h-16 bg-surface-container-lowest rounded-2xl flex items-center justify-center mx-auto mb-4 border border-outline-variant shadow-sm">
                <FileText className="w-8 h-8 text-outline-variant" />
              </div>
              <p className="text-sm font-bold text-on-surface mb-1">No recent service history found.</p>
              <p className="text-xs font-medium text-on-surface-variant">Past AMC visits and completed repairs will appear here.</p>
            </div>
          </div>

        </div>
      </div>

      {/* Raise Complaint Modal */}
      {showComplaintModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" onClick={() => setShowComplaintModal(false)}></div>
          <div className="bg-white rounded-3xl shadow-2xl w-full max-w-lg relative z-10 p-6 overflow-hidden animate-in fade-in zoom-in-95 duration-200">
            <div className="flex items-center justify-between mb-6">
              <div className="flex items-center gap-3">
                <div className="p-2 bg-error/10 rounded-lg text-error"><AlertCircle className="w-6 h-6" /></div>
                <div>
                  <h2 className="text-title-lg font-bold text-on-surface">Raise Service Request</h2>
                  <p className="text-label-md text-on-surface-variant">Describe the issue you are facing.</p>
                </div>
              </div>
              <button onClick={() => setShowComplaintModal(false)} className="p-2 text-on-surface-variant hover:bg-surface-container rounded-full transition-colors">
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleRaiseComplaint} className="space-y-5">
              <div>
                <label className="text-label-md font-bold text-on-surface mb-2 block">Issue Description</label>
                <textarea 
                  value={complaintText}
                  onChange={(e) => setComplaintText(e.target.value)}
                  placeholder="E.g., Water pressure is very low, strange noise from the pump..."
                  className="w-full p-4 bg-surface-container-lowest border border-outline-variant rounded-xl focus:border-error focus:ring-2 focus:ring-error/20 outline-none text-sm font-medium resize-none h-32"
                  required
                ></textarea>
              </div>

              <div className="flex justify-end gap-3 pt-4 border-t border-surface-container-highest">
                <button 
                  type="button"
                  onClick={() => setShowComplaintModal(false)}
                  className="px-6 py-2.5 font-bold text-slate-600 bg-slate-100 hover:bg-slate-200 rounded-xl transition-colors"
                >
                  Cancel
                </button>
                <button 
                  type="submit"
                  className="px-6 py-2.5 font-bold text-white bg-error hover:bg-error/90 rounded-xl transition-colors shadow-md"
                >
                  Submit Ticket
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default CustomerDashboard;
