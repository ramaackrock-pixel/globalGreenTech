import React, { useState, useEffect } from 'react';
import { Award, TrendingUp, DollarSign, Calendar, Target } from 'lucide-react';

const StaffIncentives: React.FC = () => {
  const [dynamicIncentives, setDynamicIncentives] = useState<any[]>([]);
  const [monthlyTarget, setMonthlyTarget] = useState<number>(() => {
    const saved = localStorage.getItem('staff_monthly_target');
    return saved ? Number(saved) : 10000;
  });
  const [isEditingTarget, setIsEditingTarget] = useState(false);
  const [tempTarget, setTempTarget] = useState('');

  useEffect(() => {
    const savedIncentives = localStorage.getItem('staff_incentives');
    if (savedIncentives) {
      const records = JSON.parse(savedIncentives);
      const staffIncentives = records
        .filter((r: any) => r.staffId === 's1')
        .map((r: any) => ({
          id: r.id,
          date: r.date,
          type: r.type,
          amount: Number(r.amount),
          customer: r.description || '-'
        }));
      setDynamicIncentives(staffIncentives);
    }
  }, []);

  const mockIncentives: any[] = [];

  const allIncentives = [...dynamicIncentives, ...mockIncentives];
  const totalEarned = allIncentives.reduce((sum, item) => sum + item.amount, 0);
  const percentage = Math.min(100, Math.round((totalEarned / monthlyTarget) * 100)) || 0;

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 card relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-full bg-gradient-to-l from-primary-container/50 to-transparent pointer-events-none"></div>

        <div className="relative z-10">
          <h1 className="text-headline-lg text-on-surface">My Incentives</h1>
          <p className="text-body-md text-on-surface-variant mt-1">Track your performance bonuses and extra earnings.</p>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {/* Total Earned Card */}
        <div className="card p-6 bg-gradient-to-br from-primary to-primary-container text-white relative overflow-hidden group">
          <div className="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full blur-2xl group-hover:scale-150 transition-transform duration-700"></div>
          <div className="relative z-10">
            <div className="flex justify-between items-start mb-6">
              <div className="p-3 bg-white/20 rounded-xl backdrop-blur-md">
                <DollarSign className="w-6 h-6 text-white" />
              </div>
              <span className="text-label-sm font-bold bg-white/20 px-3 py-1 rounded-full backdrop-blur-md">This Month</span>
            </div>
            <p className="text-label-md uppercase tracking-widest text-white/80 mb-1">Total Incentives</p>
            <h2 className="text-display-lg font-extrabold tracking-tight">₹{totalEarned}</h2>
          </div>
        </div>

        {/* Goal Card */}
        <div className="card p-6 flex flex-col justify-between">
          <div className="flex justify-between items-start mb-4">
            <div className="p-3 bg-tertiary-container text-on-tertiary-container rounded-xl">
              <Target className="w-6 h-6" />
            </div>
            <button 
              onClick={() => { 
                setIsEditingTarget(!isEditingTarget); 
                setTempTarget(monthlyTarget.toString()); 
              }} 
              className="text-label-sm font-bold text-tertiary hover:text-tertiary/80 transition-colors bg-tertiary/10 px-3 py-1.5 rounded-lg"
            >
              {isEditingTarget ? 'Cancel' : 'Edit Target'}
            </button>
          </div>
          <div>
            <div className="flex justify-between items-center text-body-sm font-bold mb-3">
              <span className="text-on-surface">Monthly Target</span>
              {isEditingTarget ? (
                <div className="flex items-center gap-2">
                  <input 
                    type="number" 
                    value={tempTarget} 
                    onChange={e => setTempTarget(e.target.value)} 
                    className="w-24 px-2 py-1 border border-outline-variant rounded-md text-right text-sm outline-none focus:border-tertiary"
                  />
                  <button 
                    onClick={() => {
                      const newTarget = Number(tempTarget);
                      if (newTarget > 0) {
                        setMonthlyTarget(newTarget);
                        localStorage.setItem('staff_monthly_target', newTarget.toString());
                        setIsEditingTarget(false);
                      }
                    }}
                    className="bg-tertiary text-white px-3 py-1 rounded-md text-xs font-bold hover:bg-tertiary/90 transition-colors shadow-sm"
                  >
                    Save
                  </button>
                </div>
              ) : (
                <span className="text-tertiary text-title-md">₹{monthlyTarget.toLocaleString()}</span>
              )}
            </div>
            <div className="w-full bg-surface-container-highest rounded-full h-3 mb-2 overflow-hidden">
              <div className="bg-tertiary h-3 rounded-full relative transition-all duration-500" style={{ width: `${percentage}%` }}>
                <div className="absolute inset-0 bg-white/20 w-full animate-[shimmer_2s_infinite]"></div>
              </div>
            </div>
            <p className="text-label-md text-on-surface-variant">{percentage}% achieved. {percentage >= 100 ? 'Target met! 🎉' : 'Keep going!'}</p>
          </div>
        </div>

        {/* Achievement Card */}
        <div className="card p-6 flex flex-col justify-between">
          <div className="flex justify-between items-start mb-4">
            <div className="p-3 bg-secondary-container text-on-secondary-container rounded-xl">
              <Award className="w-6 h-6" />
            </div>
          </div>
          <div>
            <p className="text-label-md uppercase tracking-widest text-on-surface-variant mb-1">Top Earner Badge</p>
            <h3 className="text-title-lg font-bold text-on-surface">Rising Star</h3>
            <p className="text-body-sm text-on-surface-variant mt-1">Complete 5 more installations to unlock 'Master Tech'.</p>
          </div>
        </div>
      </div>

      {/* Incentives History Table */}
      <div className="card overflow-hidden">
        <div className="p-6 border-b border-surface-container-highest flex justify-between items-center">
          <h2 className="text-title-md font-bold text-on-surface flex items-center gap-2">
            <TrendingUp className="w-5 h-5 text-primary" />
            Recent Earnings
          </h2>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-surface-container-lowest border-b border-surface-container-highest text-label-md text-on-surface-variant uppercase tracking-wider">
                <th className="p-4 font-bold">Date</th>
                <th className="p-4 font-bold">Type</th>
                <th className="p-4 font-bold">Customer / Reference</th>
                <th className="p-4 font-bold text-right">Amount</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-surface-container-highest text-body-sm text-on-surface">
              {allIncentives.map((item) => (
                <tr key={item.id} className="hover:bg-surface-container/50 transition-colors">
                  <td className="p-4 whitespace-nowrap">
                    <div className="flex items-center gap-2">
                      <Calendar className="w-4 h-4 text-outline" />
                      {item.date}
                    </div>
                  </td>
                  <td className="p-4 font-bold">{item.type}</td>
                  <td className="p-4 text-on-surface-variant">{item.customer}</td>
                  <td className="p-4 text-right font-extrabold text-primary text-title-sm">
                    +₹{item.amount}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default StaffIncentives;
