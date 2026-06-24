import React, { useState, useEffect } from 'react';
import { CalendarClock, CheckCircle, Clock } from 'lucide-react';
import staffData from '../../mockData/staff.json';
import { useSearch } from '../../context/SearchContextProvider';

const AdminAttendance: React.FC = () => {
  const { searchQuery } = useSearch();
  const [logs, setLogs] = useState<any[]>([]);

  useEffect(() => {
    const savedLog = localStorage.getItem('staff_attendance');
    if (savedLog) {
      // Sort newest first
      const parsed = JSON.parse(savedLog).sort((a: any, b: any) => new Date(b.date).getTime() - new Date(a.date).getTime());
      setLogs(parsed);
    }
  }, []);

  const filteredLogs = logs.filter((log) => {
    const staffName = staffData.find(s => s.id === log.staffId)?.name || log.staffId;
    return searchQuery.trim() === '' || staffName.toLowerCase().includes(searchQuery.toLowerCase());
  });

  return (
    <div className="space-y-8 pb-20 md:pb-0">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-white p-6 rounded-2xl shadow-[0_2px_10px_-3px_rgba(6,81,237,0.1)] border border-slate-100 relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-full bg-gradient-to-l from-primary-50/50 to-transparent pointer-events-none"></div>
        <div className="relative z-10">
          <h1 className="text-2xl font-extrabold text-slate-800 tracking-tight">Staff Attendance</h1>
          <p className="text-slate-500 text-sm mt-1 font-medium">Track daily check-ins, check-outs, and shift durations.</p>
        </div>
      </div>

      <div className="bg-white rounded-2xl shadow-[0_4px_20px_-4px_rgba(0,0,0,0.03)] border border-slate-100 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse min-w-[900px]">
            <thead>
              <tr className="bg-slate-50/50 border-b border-slate-100">
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">Date</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">Staff Member</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">Check In</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">Check Out</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">Duration</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {filteredLogs.length === 0 ? (
                <tr>
                  <td colSpan={6} className="px-6 py-8 text-center text-slate-500 font-medium">No attendance records found.</td>
                </tr>
              ) : (
                filteredLogs.map((log) => {
                  const staffName = staffData.find(s => s.id === log.staffId)?.name || log.staffId;
                  const isWorking = !log.end;
                  let durationStr = "In Progress";
                  
                  if (log.start && log.end) {
                    const start = new Date(log.start);
                    const end = new Date(log.end);
                    const diffMs = end.getTime() - start.getTime();
                    const diffHrs = Math.floor(diffMs / 3600000);
                    const diffMins = Math.floor((diffMs % 3600000) / 60000);
                    durationStr = `${diffHrs}h ${diffMins}m`;
                  }

                  return (
                    <tr key={log.id} className="hover:bg-slate-50/80 transition-colors group">
                      <td className="px-6 py-4">
                        <span className="text-sm font-bold text-slate-800">{new Date(log.date).toLocaleDateString('en-GB')}</span>
                      </td>
                      <td className="px-6 py-4">
                        <span className="text-sm font-bold text-slate-700">{staffName}</span>
                      </td>
                      <td className="px-6 py-4">
                        {log.start ? (
                           <span className="text-sm font-bold text-emerald-600">
                             {new Date(log.start).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                           </span>
                        ) : '-'}
                      </td>
                      <td className="px-6 py-4">
                        {log.end ? (
                           <span className="text-sm font-bold text-slate-600">
                             {new Date(log.end).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                           </span>
                        ) : <span className="text-sm font-medium text-slate-400 italic">Not checked out</span>}
                      </td>
                      <td className="px-6 py-4">
                        <span className="text-sm font-bold text-slate-700">{durationStr}</span>
                      </td>
                      <td className="px-6 py-4">
                        <span className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider border ${
                          isWorking ? 'bg-amber-50 text-amber-600 border-amber-100' : 'bg-emerald-50 text-emerald-600 border-emerald-100'
                        }`}>
                          {isWorking ? <Clock className="w-3 h-3" /> : <CheckCircle className="w-3 h-3" />}
                          {isWorking ? 'On Duty' : 'Completed'}
                        </span>
                      </td>
                    </tr>
                  );
                })
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default AdminAttendance;
