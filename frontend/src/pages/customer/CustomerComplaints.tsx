import React, { useState, useEffect } from 'react';
import { AlertTriangle, Clock, CheckCircle, Search, ChevronRight, UserCheck, Wrench, X, FileText, MapPin } from 'lucide-react';
import customersData from '../../mockData/customers.json';
import staffData from '../../mockData/staff.json';

const CustomerComplaints: React.FC = () => {
  const me = customersData[0]; // Acme Corp
  const [complaints, setComplaints] = useState<any[]>([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedComplaint, setSelectedComplaint] = useState<any | null>(null);

  useEffect(() => {
    // Read from shared localStorage to see all tasks/complaints for Acme Corp
    const savedTasks = localStorage.getItem('staff_tasks');
    if (savedTasks) {
      const allTasks = JSON.parse(savedTasks);
      // Filter only tasks for customer and type 'Complaint'
      const myComplaints = allTasks.filter((t: any) => t.customerId === me.id && t.type === 'Complaint');
      setComplaints(myComplaints);
    }
  }, [me.id]);

  const filteredComplaints = complaints.filter(c =>
    c.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
    c.id.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const getStatusDisplay = (status: string, assignedTo: string) => {
    if (status === 'Open' && assignedTo !== 'Unassigned') {
      status = 'Scheduled'; // Auto-correct legacy data
    }
    
    switch(status) {
      case 'Open':
        return { label: 'Requested', icon: Clock, colorClass: 'bg-slate-100 text-slate-700 border-slate-300' };
      case 'Scheduled':
        return { label: 'Assigned', icon: UserCheck, colorClass: 'bg-blue-50 text-blue-700 border-blue-200' };
      case 'In Progress':
        return { label: 'Working On', icon: Wrench, colorClass: 'bg-amber-50 text-amber-700 border-amber-200' };
      case 'Completed':
        return { label: 'Completed', icon: CheckCircle, colorClass: 'bg-emerald-50 text-emerald-700 border-emerald-200' };
      default:
        return { label: status, icon: Clock, colorClass: 'bg-slate-100 text-slate-700 border-slate-300' };
    }
  };

  return (
    <div className="space-y-6 pb-20 md:pb-0">

      {/* Page Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-surface-container-lowest p-6 rounded-3xl border border-outline-variant/30 shadow-sm">
        <div>
          <h1 className="text-headline-sm font-black text-on-surface flex items-center gap-2">
            <AlertTriangle className="w-8 h-8 text-error" />
            My Complaints
          </h1>
          <p className="text-label-lg text-on-surface-variant mt-1">Track the status of your active and past service requests.</p>
        </div>
        <div className="relative w-full sm:w-auto">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-on-surface-variant" />
          <input
            type="text"
            placeholder="Search tickets..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full sm:w-64 pl-9 pr-4 py-2 bg-surface-container border border-outline-variant rounded-xl focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none text-sm font-medium"
          />
        </div>
      </div>

      <div className="bg-white rounded-3xl border border-outline-variant/30 shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="border-b border-surface-container-highest bg-surface-container-lowest/50 text-label-md text-on-surface-variant uppercase tracking-wider">
                <th className="py-4 px-6 font-bold">Ticket ID</th>
                <th className="py-4 px-6 font-bold">Date Raised</th>
                <th className="py-4 px-6 font-bold">Issue Description</th>
                <th className="py-4 px-6 font-bold">Status</th>
                <th className="py-4 px-6 font-bold text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-surface-container-highest">
              {filteredComplaints.length === 0 ? (
                <tr>
                  <td colSpan={5} className="py-12 text-center text-on-surface-variant">
                    <CheckCircle className="w-12 h-12 mx-auto mb-3 text-emerald-500/50" />
                    <p className="text-body-lg font-medium text-on-surface">No complaints found.</p>
                    <p className="text-label-md mt-1">Your systems are running smoothly!</p>
                  </td>
                </tr>
              ) : (
                filteredComplaints.map(complaint => (
                  <tr key={complaint.id} className="hover:bg-surface-container/30 transition-colors">
                    <td className="py-4 px-6">
                      <span className="text-label-md font-bold text-on-surface bg-surface-container px-2.5 py-1 rounded-md">{complaint.id}</span>
                    </td>
                    <td className="py-4 px-6 text-body-sm font-medium text-on-surface">
                      {complaint.date || new Date().toISOString().split('T')[0]}
                    </td>
                    <td className="py-4 px-6">
                      <p className="text-body-sm text-on-surface line-clamp-2 max-w-sm">{complaint.description}</p>
                    </td>
                    <td className="py-4 px-6">
                      {(() => {
                        const { label, icon: StatusIcon, colorClass } = getStatusDisplay(complaint.status, complaint.assignedTo || 'Unassigned');
                        return (
                          <span className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider border ${colorClass}`}>
                            <StatusIcon className="w-3 h-3" />
                            {label}
                          </span>
                        );
                      })()}
                    </td>
                    <td className="py-4 px-6 text-right">
                      <button 
                        onClick={() => setSelectedComplaint(complaint)}
                        className="text-primary hover:bg-primary-fixed p-2 rounded-lg transition-colors font-bold text-xs inline-flex items-center gap-1"
                      >
                        View Details <ChevronRight className="w-3 h-3" />
                      </button>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* View Details Modal */}
      {selectedComplaint && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" onClick={() => setSelectedComplaint(null)}></div>
          <div className="bg-white rounded-3xl shadow-2xl w-full max-w-lg relative z-10 p-6 overflow-hidden animate-in fade-in zoom-in-95 duration-200">
            <div className="flex justify-between items-start mb-6">
              <div>
                <div className="flex items-center gap-2 mb-1">
                  <h2 className="text-title-lg font-black text-on-surface">Ticket #{selectedComplaint.id}</h2>
                  {(() => {
                    const { label, colorClass } = getStatusDisplay(selectedComplaint.status, selectedComplaint.assignedTo || 'Unassigned');
                    return (
                      <span className={`px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-wider border ${colorClass}`}>
                        {label}
                      </span>
                    );
                  })()}
                </div>
                <p className="text-label-md text-on-surface-variant">Created on {selectedComplaint.date || new Date().toISOString().split('T')[0]}</p>
              </div>
              <button onClick={() => setSelectedComplaint(null)} className="p-2 text-on-surface-variant hover:bg-surface-container rounded-full transition-colors">
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="space-y-6">
              <div>
                <h3 className="text-label-sm font-bold text-on-surface-variant uppercase tracking-wider mb-2 flex items-center gap-2"><FileText className="w-4 h-4" /> Issue Description</h3>
                <div className="bg-surface-container-lowest border border-outline-variant/50 p-4 rounded-xl text-body-md text-on-surface">
                  {selectedComplaint.description}
                </div>
              </div>

              <div>
                <h3 className="text-label-sm font-bold text-on-surface-variant uppercase tracking-wider mb-2 flex items-center gap-2"><UserCheck className="w-4 h-4" /> Assigned Technician</h3>
                <div className="bg-surface-container-lowest border border-outline-variant/50 p-4 rounded-xl flex items-center gap-3 text-body-md text-on-surface font-medium">
                  {selectedComplaint.assignedTo && selectedComplaint.assignedTo !== 'Unassigned' ? (
                    <>
                      <div className="w-8 h-8 rounded-full bg-primary/10 text-primary flex items-center justify-center font-bold">
                        {staffData.find(s => s.id === selectedComplaint.assignedTo)?.name?.charAt(0) || 'T'}
                      </div>
                      <div>
                        <p>{staffData.find(s => s.id === selectedComplaint.assignedTo)?.name || selectedComplaint.assignedTo}</p>
                        <p className="text-xs text-on-surface-variant">Global Green Tech Expert</p>
                      </div>
                    </>
                  ) : (
                    <span className="text-on-surface-variant italic">A technician will be assigned shortly.</span>
                  )}
                </div>
              </div>

              {selectedComplaint.checkInTime && (
                <div>
                  <h3 className="text-label-sm font-bold text-on-surface-variant uppercase tracking-wider mb-2 flex items-center gap-2"><MapPin className="w-4 h-4" /> Service Timeline</h3>
                  <div className="bg-surface-container-lowest border border-outline-variant/50 p-4 rounded-xl space-y-3">
                    <div className="flex justify-between items-center text-sm">
                      <span className="text-on-surface-variant">Check-In:</span>
                      <span className="font-bold text-on-surface">{new Date(selectedComplaint.checkInTime).toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})}</span>
                    </div>
                    {selectedComplaint.checkOutTime && (
                      <div className="flex justify-between items-center text-sm pt-3 border-t border-outline-variant/30">
                        <span className="text-on-surface-variant">Check-Out:</span>
                        <span className="font-bold text-on-surface">{new Date(selectedComplaint.checkOutTime).toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})}</span>
                      </div>
                    )}
                  </div>
                </div>
              )}
            </div>

            <div className="mt-8 pt-4 border-t border-surface-container-highest">
              <button 
                onClick={() => setSelectedComplaint(null)}
                className="w-full py-3 font-bold text-slate-600 bg-slate-100 hover:bg-slate-200 rounded-xl transition-colors"
              >
                Close Details
              </button>
            </div>
          </div>
        </div>
      )}

    </div>
  );
};

export default CustomerComplaints;
