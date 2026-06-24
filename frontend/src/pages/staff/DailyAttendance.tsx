import React, { useState, useEffect } from 'react';
import { LogIn, LogOut, Clock, Calendar } from 'lucide-react';

const DailyAttendance: React.FC = () => {
  const [time, setTime] = useState(new Date());
  const [isCheckedIn, setIsCheckedIn] = useState(false);
  const [shiftLog, setShiftLog] = useState<{ start: Date | null; end: Date | null }>({ start: null, end: null });

  useEffect(() => {
    const timer = setInterval(() => setTime(new Date()), 1000);
    return () => clearInterval(timer);
  }, []);

  useEffect(() => {
    const savedLog = localStorage.getItem('staff_attendance');
    if (savedLog) {
      const logs = JSON.parse(savedLog);
      const today = new Date().toISOString().split('T')[0];
      const todayLog = logs.find((l: any) => l.staffId === 's1' && l.date === today);
      if (todayLog) {
        setIsCheckedIn(!todayLog.end && !!todayLog.start);
        setShiftLog({
          start: todayLog.start ? new Date(todayLog.start) : null,
          end: todayLog.end ? new Date(todayLog.end) : null
        });
      }
    }
  }, []);

  const saveToLocalStorage = (start: Date | null, end: Date | null) => {
    const savedLog = localStorage.getItem('staff_attendance');
    const logs = savedLog ? JSON.parse(savedLog) : [];
    const today = new Date().toISOString().split('T')[0];
    
    const filteredLogs = logs.filter((l: any) => !(l.staffId === 's1' && l.date === today));
    
    filteredLogs.push({
      id: `att-${Date.now()}`,
      staffId: 's1',
      date: today,
      start: start ? start.toISOString() : null,
      end: end ? end.toISOString() : null
    });
    
    localStorage.setItem('staff_attendance', JSON.stringify(filteredLogs));
  };

  const handleCheckIn = () => {
    const now = new Date();
    setIsCheckedIn(true);
    setShiftLog({ start: now, end: null });
    saveToLocalStorage(now, null);
    alert('Shift started! Have a great day.');
  };

  const handleCheckOut = () => {
    const now = new Date();
    setIsCheckedIn(false);
    setShiftLog({ ...shiftLog, end: now });
    saveToLocalStorage(shiftLog.start, now);
    alert('Shift ended. Great work today!');
  };

  return (
    <div className="space-y-8 pb-20 md:pb-0">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 card relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-full bg-gradient-to-l from-primary-container/50 to-transparent pointer-events-none"></div>

        <div className="relative z-10">
          <h1 className="text-headline-lg text-on-surface">Daily Attendance</h1>
          <p className="text-body-md text-on-surface-variant mt-1">Punch in to start your shift, and punch out when you leave.</p>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
        
        {/* Clock & Action Area */}
        <div className="card p-8 flex flex-col items-center justify-center text-center relative overflow-hidden h-full">
          {/* Subtle animated background pulse based on state */}
          <div className={`absolute inset-0 opacity-10 transition-colors duration-1000 pointer-events-none ${
            isCheckedIn ? 'bg-secondary animate-pulse' : 'bg-primary/20'
          }`}></div>

          <div className="relative z-10 space-y-8 w-full max-w-sm mx-auto">
            <div>
              <div className="text-[4rem] md:text-[5rem] font-black text-on-surface tracking-tighter leading-none font-mono tabular-nums">
                {time.toLocaleTimeString([], { hour12: true, hour: '2-digit', minute: '2-digit', second: '2-digit' })}
              </div>
              <p className="text-title-md text-on-surface-variant font-bold mt-2 uppercase tracking-widest">
                {time.toLocaleDateString([], { weekday: 'long', month: 'long', day: 'numeric' })}
              </p>
            </div>

            <div className="pt-4 border-t border-outline-variant/30">
              {!isCheckedIn ? (
                <button 
                  onClick={handleCheckIn}
                  className="w-full flex items-center justify-center gap-3 text-headline-sm font-bold text-on-primary bg-primary hover:bg-primary/90 py-5 rounded-2xl shadow-[0_8px_30px_rgba(0,94,154,0.3)] transition-all transform hover:-translate-y-1"
                >
                  <LogIn className="w-6 h-6" />
                  Start Shift (Check-In)
                </button>
              ) : (
                <button 
                  onClick={handleCheckOut}
                  className="w-full flex items-center justify-center gap-3 text-headline-sm font-bold text-on-secondary bg-secondary hover:bg-secondary/90 py-5 rounded-2xl shadow-[0_8px_30px_rgba(255,107,107,0.3)] transition-all transform hover:-translate-y-1"
                >
                  <LogOut className="w-6 h-6" />
                  End Shift (Check-Out)
                </button>
              )}
            </div>

            <div className="flex justify-center">
              <span className={`inline-flex items-center gap-2 px-4 py-1.5 rounded-full border text-label-md font-bold uppercase tracking-wider ${
                isCheckedIn ? 'bg-secondary-container/20 border-secondary/30 text-secondary' : 'bg-surface-container border-outline-variant text-on-surface-variant'
              }`}>
                <div className={`w-2 h-2 rounded-full ${isCheckedIn ? 'bg-secondary animate-pulse' : 'bg-outline'}`}></div>
                {isCheckedIn ? 'On Duty' : 'Off Duty'}
              </span>
            </div>
          </div>
        </div>

        {/* Today's Shift Log */}
        <div className="card p-0 flex flex-col h-full">
          <div className="p-6 border-b border-outline-variant/30 flex items-center gap-3 bg-surface-container-lowest">
            <Calendar className="w-5 h-5 text-primary" />
            <h2 className="text-title-lg font-bold text-on-surface">Today's Shift Record</h2>
          </div>

          <div className="p-6 flex-1 flex flex-col justify-center space-y-6">
            <div className="flex items-start gap-4 p-5 rounded-2xl bg-surface-container-lowest border border-outline-variant/40 shadow-sm relative overflow-hidden group hover:border-primary/30 transition-colors">
              <div className="absolute top-0 left-0 w-1.5 h-full bg-primary/50"></div>
              <div className="p-3 bg-primary/10 text-primary rounded-xl shrink-0">
                <LogIn className="w-6 h-6" />
              </div>
              <div className="flex-1">
                <p className="text-label-md font-bold text-on-surface-variant uppercase tracking-wider mb-1">Shift Started</p>
                {shiftLog.start ? (
                  <p className="text-title-lg font-black text-on-surface">
                    {shiftLog.start.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                  </p>
                ) : (
                  <p className="text-title-lg font-bold text-outline-variant italic">Not checked in yet</p>
                )}
              </div>
            </div>

            <div className="flex items-start gap-4 p-5 rounded-2xl bg-surface-container-lowest border border-outline-variant/40 shadow-sm relative overflow-hidden group hover:border-secondary/30 transition-colors">
              <div className="absolute top-0 left-0 w-1.5 h-full bg-secondary/50"></div>
              <div className="p-3 bg-secondary/10 text-secondary rounded-xl shrink-0">
                <LogOut className="w-6 h-6" />
              </div>
              <div className="flex-1">
                <p className="text-label-md font-bold text-on-surface-variant uppercase tracking-wider mb-1">Shift Ended</p>
                {shiftLog.end ? (
                  <p className="text-title-lg font-black text-on-surface">
                    {shiftLog.end.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                  </p>
                ) : (
                  <p className="text-title-lg font-bold text-outline-variant italic">
                    {isCheckedIn ? 'In progress...' : 'Not checked out yet'}
                  </p>
                )}
              </div>
            </div>
            
            {shiftLog.start && shiftLog.end && (
              <div className="text-center p-4 bg-surface-container rounded-xl border border-outline-variant/30">
                <p className="text-label-md text-on-surface-variant font-bold uppercase tracking-wider mb-1">Total Shift Duration</p>
                <p className="text-title-lg font-black text-primary">
                  {Math.max(1, Math.floor((shiftLog.end.getTime() - shiftLog.start.getTime()) / 60000))} Minutes
                </p>
              </div>
            )}
          </div>
        </div>

      </div>
    </div>
  );
};

export default DailyAttendance;
