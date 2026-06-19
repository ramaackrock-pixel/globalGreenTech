import React, { useState, useEffect } from 'react';
import { Search, Filter, MoreVertical, Banknote, CalendarDays, CheckCircle2, IndianRupee, Plus, AlertCircle, FileText } from 'lucide-react';
import payrollData from '../../mockData/payroll.json';
import staffData from '../../mockData/staff.json';
import { useSearch } from '../../context/SearchContextProvider';

const AdminPayroll: React.FC = () => {
  const { searchQuery } = useSearch();
  const [payroll, setPayroll] = useState(payrollData);
  const [statusFilter, setStatusFilter] = useState('All');
  
  // Modal State
  const [showModal, setShowModal] = useState(false);
  const [selectedStaff, setSelectedStaff] = useState('');
  const [paymentMonth, setPaymentMonth] = useState('');
  const [baseSalary, setBaseSalary] = useState(0);
  const [pf, setPf] = useState(0);
  const [esi, setEsi] = useState(0);
  const [allowances, setAllowances] = useState(0);
  const [leaves, setLeaves] = useState(0);
  const [salaryAdvance, setSalaryAdvance] = useState(0);
  const [netSalary, setNetSalary] = useState(0);

  // Auto-calculate Net Salary whenever inputs change
  useEffect(() => {
    // Basic logic: Base + Allowances - PF - ESI - (Leaves * 500) - Salary Advance
    const leaveDeduction = leaves * 500; // Assuming 500 per leave for mock purposes
    const calculatedNet = Number(baseSalary) + Number(allowances) - Number(pf) - Number(esi) - leaveDeduction - Number(salaryAdvance);
    setNetSalary(calculatedNet > 0 ? calculatedNet : 0);
  }, [baseSalary, pf, esi, allowances, leaves, salaryAdvance]);

  // Filter Logic
  const filteredPayroll = payroll.filter((record) => {
    const matchesStatus = statusFilter === 'All' || record.status === statusFilter;
    
    // Look up the staff name so we can search by it
    const staffName = staffData.find(s => s.id === record.staffId)?.name || record.staffId;
    
    const matchesSearch = searchQuery.trim() === '' || 
                          staffName.toLowerCase().includes(searchQuery.toLowerCase()) ||
                          record.staffId.toLowerCase().includes(searchQuery.toLowerCase());
                          
    return matchesStatus && matchesSearch;
  });

  const handleProcessPayroll = (e: React.FormEvent) => {
    e.preventDefault();
    
    // Format the month from 'YYYY-MM' to 'Month YYYY'
    const dateObj = new Date(paymentMonth + '-01');
    const formattedMonth = dateObj.toLocaleDateString('en-US', { month: 'long', year: 'numeric' });

    // 1. Construct the new payroll record object
    const newRecord = {
      id: `p${payroll.length + 1}`,
      staffId: selectedStaff,
      month: formattedMonth,
      baseSalary: Number(baseSalary),
      pf: Number(pf),
      esi: Number(esi),
      allowances: Number(allowances),
      leaves: Number(leaves),
      salaryAdvance: Number(salaryAdvance),
      netSalary: netSalary,
      status: 'Paid',
      paymentDate: new Date().toISOString().split('T')[0]
    };

    // 2. Add it to our state array
    setPayroll(prev => [newRecord, ...prev]);

    // 3. Reset the form fields back to empty
    setSelectedStaff('');
    setPaymentMonth('');
    setBaseSalary(0);
    setPf(0);
    setEsi(0);
    setAllowances(0);
    setLeaves(0);
    setSalaryAdvance(0);
    
    alert("Payroll processed successfully!");
    setShowModal(false);
  };

  return (
    <div className="space-y-8 pb-20 md:pb-0">
      
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 card p-6 relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-full bg-gradient-to-l from-primary-container/50 to-transparent pointer-events-none"></div>

        <div className="relative z-10">
          <h1 className="text-headline-lg text-on-surface">Payroll & Salary</h1>
          <p className="text-body-md text-on-surface-variant mt-1">Manage staff compensation, PF, ESI, and allowances.</p>
        </div>
        
        <button 
          onClick={() => setShowModal(true)}
          className="relative z-10 btn-primary flex items-center gap-2 px-5 py-3"
        >
          <Plus className="w-5 h-5" />
          Process Payroll
        </button>
      </div>

      {/* Main Content Box */}
      <div className="card !p-0 overflow-hidden">
        
        {/* Toolbar (Filters) */}
        <div className="p-6 border-b border-surface-container-highest flex flex-col sm:flex-row gap-4 justify-between items-start sm:items-center bg-surface-container-lowest">
          <h2 className="text-label-lg font-bold text-on-surface uppercase tracking-wider">Payroll History</h2>
          
          <div className="flex items-center gap-3 w-full sm:w-auto">
            <label className="text-label-md font-bold text-on-surface-variant uppercase tracking-wider hidden sm:block">Filter by Status:</label>
            <select 
              className="input-field w-full sm:w-auto px-4 py-2.5 cursor-pointer appearance-none"
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
            >
              <option value="All">All Statuses</option>
              <option value="Paid">Paid</option>
              <option value="Pending">Pending</option>
            </select>
          </div>
        </div>

        {/* Data Table */}
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse min-w-[900px]">
            <thead>
              <tr className="bg-slate-50/50 border-b border-slate-100">
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">Staff Member</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">Month & Base</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">Deductions (PF/ESI)</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">Net Salary</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">Status</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {filteredPayroll.map((record) => (
                <tr key={record.id} className="hover:bg-slate-50/80 transition-colors group">
                  <td className="px-6 py-4">
                    <div className="flex flex-col">
                      <span className="text-sm font-bold text-slate-800">
                        {staffData.find(s => s.id === record.staffId)?.name || record.staffId}
                      </span>
                      <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider mt-1">
                        ID: {record.staffId}
                      </span>
                    </div>
                  </td>

                  <td className="px-6 py-4">
                    <div className="flex flex-col">
                      <span className="text-sm font-bold text-slate-700">{record.month}</span>
                      <span className="text-xs font-medium text-slate-500 mt-1">
                        ₹{record.baseSalary.toLocaleString('en-IN')} Base
                      </span>
                    </div>
                  </td>
                  
                  <td className="px-6 py-4">
                    <div className="flex flex-col gap-1">
                      <span className="text-xs font-medium text-error">- ₹{record.pf.toLocaleString('en-IN')} (PF)</span>
                      <span className="text-xs font-medium text-error">- ₹{record.esi.toLocaleString('en-IN')} (ESI)</span>
                      {(record.leaves > 0 || record.salaryAdvance > 0) && (
                         <span className="text-[10px] font-bold text-error uppercase tracking-wider">
                           Leaves/Adv: ₹{((record.leaves || 0) * 500 + (record.salaryAdvance || 0)).toLocaleString('en-IN')}
                         </span>
                      )}
                    </div>
                  </td>
                  
                  <td className="px-6 py-4">
                    <div className="flex flex-col gap-1">
                      <span className="text-sm font-extrabold text-emerald-600">
                        ₹{record.netSalary.toLocaleString('en-IN')}
                      </span>
                      {record.allowances > 0 && (
                        <span className="text-[10px] font-bold text-blue-500 uppercase tracking-wider">
                          Includes ₹{record.allowances} Allowance
                        </span>
                      )}
                    </div>
                  </td>

                  <td className="px-6 py-4">
                    <span className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider border ${
                      record.status === 'Paid' ? 'bg-emerald-50 text-emerald-600 border-emerald-100' : 
                      'bg-amber-50 text-amber-600 border-amber-100'
                    }`}>
                      {record.status === 'Paid' ? <CheckCircle2 className="w-3 h-3" /> : <AlertCircle className="w-3 h-3" />}
                      {record.status}
                    </span>
                  </td>
                  
                  <td className="px-6 py-4 text-right">
                    <div className="flex justify-end gap-2">
                      {record.status === 'Paid' && (
                        <button className="p-2 text-primary hover:text-primary-container hover:bg-primary-fixed rounded-lg transition-colors" title="Generate PDF">
                          <FileText className="w-5 h-5" />
                        </button>
                      )}
                      <button className="p-2 text-outline hover:text-primary hover:bg-primary-fixed rounded-lg transition-colors">
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

      {/* Process Payroll Modal */}
      {showModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-inverse-surface/60 backdrop-blur-sm" onClick={() => setShowModal(false)}></div>
          <div className="bg-surface-container-lowest rounded-3xl shadow-2xl w-full max-w-2xl relative z-10 overflow-hidden animate-in fade-in zoom-in-95 duration-200">
            <div className="p-6 border-b border-surface-container-highest bg-surface-container flex items-center gap-3">
              <div className="w-10 h-10 bg-surface-container-lowest rounded-xl shadow-sm border border-outline-variant flex items-center justify-center">
                <Banknote className="w-5 h-5 text-primary" />
              </div>
              <div>
                <h2 className="text-title-lg font-extrabold text-on-surface">Process Salary Payment</h2>
                <p className="text-label-md font-medium text-on-surface-variant">Calculate net salary by adjusting PF, ESI, and allowances.</p>
              </div>
            </div>

            <form className="p-6 space-y-6" onSubmit={handleProcessPayroll}>
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-label-md font-bold text-on-surface uppercase tracking-wide">Staff Member</label>
                  <select 
                    className="input-field appearance-none cursor-pointer"
                    value={selectedStaff}
                    onChange={(e) => setSelectedStaff(e.target.value)}
                    required
                  >
                    <option value="">Select Staff...</option>
                    {staffData.map(s => (
                      <option key={s.id} value={s.id}>{s.name} ({s.role})</option>
                    ))}
                  </select>
                </div>
                <div className="space-y-1.5">
                  <label className="text-label-md font-bold text-on-surface uppercase tracking-wide">Payment Month</label>
                  <input
                    type="month"
                    required
                    className="input-field"
                    value={paymentMonth}
                    onChange={(e) => setPaymentMonth(e.target.value)}
                  />
                </div>
              </div>

              <div className="bg-surface-container p-5 rounded-2xl border border-surface-container-highest space-y-4">
                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-1.5">
                    <label className="text-label-md font-bold text-on-surface uppercase tracking-wide">Base Salary (₹)</label>
                    <input
                      type="number"
                      required
                      min="0"
                      className="input-field"
                      value={baseSalary || ''}
                      onChange={(e) => setBaseSalary(Number(e.target.value))}
                    />
                  </div>
                  <div className="space-y-1.5">
                    <label className="text-label-md font-bold text-on-surface uppercase tracking-wide">Allowances / Bonus (₹)</label>
                    <input
                      type="number"
                      min="0"
                      className="input-field"
                      value={allowances || ''}
                      onChange={(e) => setAllowances(Number(e.target.value))}
                    />
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-1.5">
                    <label className="text-label-md font-bold text-error uppercase tracking-wide">PF Deduction (₹)</label>
                    <input
                      type="number"
                      min="0"
                      className="input-field text-error font-bold bg-error-container/30 border-error/20 focus:border-error focus:ring-error/20"
                      value={pf || ''}
                      onChange={(e) => setPf(Number(e.target.value))}
                    />
                  </div>
                  <div className="space-y-1.5">
                    <label className="text-label-md font-bold text-error uppercase tracking-wide">ESI Deduction (₹)</label>
                    <input
                      type="number"
                      min="0"
                      className="input-field text-error font-bold bg-error-container/30 border-error/20 focus:border-error focus:ring-error/20"
                      value={esi || ''}
                      onChange={(e) => setEsi(Number(e.target.value))}
                    />
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-1.5">
                    <label className="text-label-md font-bold text-error uppercase tracking-wide">Leaves Taken (Days)</label>
                    <input
                      type="number"
                      min="0"
                      className="input-field text-error font-bold bg-error-container/30 border-error/20 focus:border-error focus:ring-error/20"
                      value={leaves || ''}
                      onChange={(e) => setLeaves(Number(e.target.value))}
                    />
                  </div>
                  <div className="space-y-1.5">
                    <label className="text-label-md font-bold text-error uppercase tracking-wide">Salary Advance (₹)</label>
                    <input
                      type="number"
                      min="0"
                      className="input-field text-error font-bold bg-error-container/30 border-error/20 focus:border-error focus:ring-error/20"
                      value={salaryAdvance || ''}
                      onChange={(e) => setSalaryAdvance(Number(e.target.value))}
                    />
                  </div>
                </div>
              </div>

              {/* Net Salary Calculation Block */}
              <div className="bg-primary-container/20 border border-primary/20 rounded-2xl p-5 flex items-center justify-between">
                <div>
                  <h3 className="text-title-sm font-extrabold text-on-surface uppercase tracking-wide">Final Net Salary</h3>
                  <p className="text-label-md font-medium text-on-surface-variant mt-0.5">Base + Allowances - PF - ESI - Leaves - Adv</p>
                </div>
                <div className="text-display-sm font-black text-primary tracking-tight">
                  ₹{netSalary.toLocaleString('en-IN')}
                </div>
              </div>

              <div className="pt-2 flex gap-3">
                <button
                  type="button"
                  onClick={() => setShowModal(false)}
                  className="flex-1 px-4 py-3 rounded-xl font-bold text-on-surface-variant bg-surface-container hover:bg-surface-container-highest transition-colors"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="btn-primary flex-1 px-4 py-3"
                >
                  Confirm & Process
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default AdminPayroll;
