import React, { useState, useEffect } from 'react';
import { MapPin, Clock, LogIn, LogOut, Briefcase, Building2, Timer } from 'lucide-react';
import tasksData from '../../mockData/tasks.json';
import customersData from '../../mockData/customers.json';

const StaffActivityLog: React.FC = () => {
  const [logs, setLogs] = useState<any[]>([]);

  useEffect(() => {
    const saved = localStorage.getItem('staff_tasks');
    const tasks = saved ? JSON.parse(saved) : tasksData.filter(t => t.assignedTo === 's1');
    
    let extractedLogs: any[] = [];
    
    tasks.forEach((task: any) => {
      const customer = customersData.find(c => c.id === task.customerId);
      const location = customer?.address || '123 Business Rd, Tech Park';
      const companyName = customer?.name || task.customerId;
      
      if (task.checkInTime || task.checkOutTime) {
        let checkInStr = task.checkInTime ? new Date(task.checkInTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : '--';
        let checkOutStr = task.checkOutTime ? new Date(task.checkOutTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : '--';
        let durationStr = '--';
        
        if (task.checkInTime && task.checkOutTime) {
           const mins = Math.max(1, Math.floor((task.checkOutTime - task.checkInTime) / 60000));
           durationStr = `${mins} mins`;
        }

        extractedLogs.push({
          task: task.id,
          companyName: companyName,
          location: location,
          checkIn: checkInStr,
          checkOut: checkOutStr,
          duration: durationStr,
          timestamp: task.checkInTime || task.checkOutTime
        });
      }
    });

    // Sort descending by latest action timestamp
    extractedLogs.sort((a, b) => b.timestamp - a.timestamp);
    
    setLogs(extractedLogs);
  }, []);

  return (
    <div className="space-y-8 pb-20 md:pb-0">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 card relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-full bg-gradient-to-l from-primary-container/50 to-transparent pointer-events-none"></div>

        <div className="relative z-10">
          <h1 className="text-headline-lg text-on-surface">Activity Log</h1>
          <p className="text-body-md text-on-surface-variant mt-1">Detailed timesheet of your check-ins and check-outs.</p>
        </div>
      </div>

      <div className="card p-0 overflow-hidden">
        <div className="p-6 border-b border-outline-variant/30 flex items-center gap-3 bg-surface-container-lowest">
          <Clock className="w-5 h-5 text-primary" />
          <h2 className="text-title-lg font-bold text-on-surface">Today's Timesheet</h2>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-surface-container/50 text-label-md text-on-surface-variant uppercase tracking-wider border-b border-outline-variant/30">
                <th className="p-4 pl-6 font-bold">Task ID</th>
                <th className="p-4 font-bold">Company</th>
                <th className="p-4 font-bold">Location</th>
                <th className="p-4 font-bold">Check-In</th>
                <th className="p-4 font-bold">Check-Out</th>
                <th className="p-4 pr-6 font-bold">Duration</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-outline-variant/20">
              {logs.length === 0 ? (
                <tr>
                  <td colSpan={6} className="p-8 text-center text-on-surface-variant">
                    No activity recorded yet today.
                  </td>
                </tr>
              ) : (
                logs.map((log, index) => (
                  <tr key={index} className="hover:bg-surface-container-lowest transition-colors">
                    <td className="p-4 pl-6">
                      <div className="flex items-center gap-2 text-body-sm font-medium text-on-surface-variant">
                        <Briefcase className="w-4 h-4 text-outline" />
                        {log.task}
                      </div>
                    </td>
                    <td className="p-4">
                      <div className="flex items-center gap-2 text-body-sm font-bold text-on-surface">
                        <Building2 className="w-4 h-4 text-primary/70" />
                        {log.companyName}
                      </div>
                    </td>
                    <td className="p-4">
                      <div className="flex items-center gap-2 text-body-sm text-on-surface-variant">
                        <MapPin className="w-4 h-4 text-outline" />
                        <span className="truncate max-w-[150px]" title={log.location}>{log.location}</span>
                      </div>
                    </td>
                    <td className="p-4">
                      {log.checkIn !== '--' ? (
                        <div className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md border border-primary/20 bg-primary/5 text-primary text-label-sm font-bold">
                          <LogIn className="w-3.5 h-3.5" />
                          {log.checkIn}
                        </div>
                      ) : (
                        <span className="text-outline-variant font-medium">--</span>
                      )}
                    </td>
                    <td className="p-4">
                      {log.checkOut !== '--' ? (
                        <div className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md border border-secondary/20 bg-secondary/5 text-secondary text-label-sm font-bold">
                          <LogOut className="w-3.5 h-3.5" />
                          {log.checkOut}
                        </div>
                      ) : (
                        <span className="text-outline-variant font-medium">--</span>
                      )}
                    </td>
                    <td className="p-4 pr-6">
                      {log.duration !== '--' ? (
                        <div className="flex items-center gap-2 text-body-sm font-bold text-on-surface">
                          <Timer className="w-4 h-4 text-primary" />
                          {log.duration}
                        </div>
                      ) : (
                        <span className="text-outline-variant font-medium text-sm">In Progress</span>
                      )}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default StaffActivityLog;
