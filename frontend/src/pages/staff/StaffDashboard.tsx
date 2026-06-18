import React, { useState } from 'react';
import { Briefcase, MapPin, CheckCircle, Clock, Navigation, AlertCircle, Camera, Check } from 'lucide-react';
import customersData from '../../mockData/customers.json';
import tasksData from '../../mockData/tasks.json';

const StaffDashboard: React.FC = () => {
  // Mock logged-in staff
  const myTasks = tasksData.filter(task => task.assignedTo === 'Rahul Kumar');
  const [tasks, setTasks] = useState(myTasks);

  const handleCheckIn = (taskId: string) => {
    setTasks(tasks.map(t => 
      t.id === taskId ? { ...t, status: 'In Progress' } : t
    ));
    alert(`GPS Location Captured. Checked-in to task ${taskId}`);
  };

  const handleComplete = (taskId: string) => {
    setTasks(tasks.map(t => 
      t.id === taskId ? { ...t, status: 'Completed' } : t
    ));
  };

  return (
    <div className="space-y-8 pb-20 md:pb-0">
      
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-white p-6 rounded-2xl shadow-[0_2px_10px_-3px_rgba(6,81,237,0.1)] border border-slate-100 relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-full bg-gradient-to-l from-primary-50/50 to-transparent pointer-events-none"></div>

        <div className="relative z-10">
          <h1 className="text-2xl font-extrabold text-slate-800 tracking-tight">My Tasks</h1>
          <p className="text-slate-500 text-sm mt-1 font-medium">Your schedule and field routes for today.</p>
        </div>
        <div className="flex gap-6 items-center relative z-10 bg-slate-50 px-6 py-3 rounded-xl border border-slate-100">
          <div className="flex flex-col items-end">
            <span className="text-[10px] text-slate-400 uppercase font-bold tracking-widest">Incentives Earned</span>
            <span className="text-xl font-extrabold text-primary-600 mt-0.5">₹ 1,250</span>
          </div>
          <div className="h-10 w-px bg-slate-200"></div>
          <div className="flex flex-col items-end">
            <span className="text-[10px] text-slate-400 uppercase font-bold tracking-widest">Pending</span>
            <span className="text-xl font-extrabold text-slate-800 mt-0.5">{tasks.filter(t => t.status !== 'Completed').length}</span>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        {/* Main Task List */}
        <div className="lg:col-span-2 space-y-4">
          <h2 className="text-sm font-bold text-slate-800 uppercase tracking-wider ml-2">Today's Itinerary</h2>
          
          {tasks.map((task) => (
            <div key={task.id} className="bg-white border border-slate-100 rounded-2xl shadow-[0_4px_20px_-4px_rgba(0,0,0,0.03)] hover:shadow-[0_8px_30px_-4px_rgba(0,0,0,0.06)] overflow-hidden flex flex-col md:flex-row transition-all duration-300 group">
              {/* Task Status/Priority Strip */}
              <div className={`w-full md:w-3 shrink-0 ${
                task.status === 'Completed' ? 'bg-gradient-to-b from-emerald-400 to-emerald-500' :
                task.status === 'In Progress' ? 'bg-gradient-to-b from-blue-400 to-blue-500' :
                task.type === 'Complaint' ? 'bg-gradient-to-b from-amber-400 to-amber-500' : 'bg-gradient-to-b from-slate-300 to-slate-400'
              }`}></div>
              
              <div className="p-6 flex-1 flex flex-col justify-between">
                <div>
                  <div className="flex justify-between items-start mb-3">
                    <div className="flex items-center gap-2">
                      <span className="text-[10px] font-bold text-slate-500 bg-slate-100 px-2 py-1 rounded-md tracking-wider">{task.id}</span>
                      <span className={`text-[10px] font-bold px-2 py-1 rounded-md border tracking-wider ${
                        task.type === 'Complaint' ? 'bg-amber-50 text-amber-700 border-amber-200' : 'bg-blue-50 text-blue-700 border-blue-200'
                      }`}>
                        {task.type}
                      </span>
                    </div>
                    
                    {/* Status Badge */}
                    <div className="flex items-center gap-1.5 bg-slate-50 px-3 py-1.5 rounded-full border border-slate-100">
                      {task.status === 'Completed' ? <CheckCircle className="w-4 h-4 text-emerald-500" /> : <Clock className="w-4 h-4 text-slate-400" />}
                      <span className={`text-[11px] font-bold uppercase tracking-wider ${
                        task.status === 'Completed' ? 'text-emerald-600' :
                        task.status === 'In Progress' ? 'text-blue-600' : 'text-slate-500'
                      }`}>{task.status}</span>
                    </div>
                  </div>
                  
                  <h3 className="font-extrabold text-slate-800 text-xl mb-1.5">{customersData.find(c => c.id === task.customerId)?.name || task.customerId}</h3>
                  <p className="text-slate-600 text-sm mb-5 leading-relaxed line-clamp-2 pr-4">{task.description}</p>
                </div>
                
                <div className="flex items-center gap-3 text-sm text-slate-600 bg-slate-50/80 p-3 rounded-xl border border-slate-100 group-hover:border-slate-200 transition-colors">
                  <div className="p-1.5 bg-white rounded-lg shadow-sm border border-slate-100">
                    <MapPin className="w-4 h-4 text-primary-600" />
                  </div>
                  <span className="truncate font-medium">123 Business Rd, Tech Park, City</span>
                </div>
              </div>
              
              {/* Action Area */}
              <div className="bg-slate-50/50 border-t md:border-t-0 md:border-l border-slate-100 p-6 flex md:flex-col justify-center items-center gap-3 w-full md:w-56 shrink-0 relative overflow-hidden">
                <button className="flex items-center justify-center gap-2 text-sm font-bold text-primary-600 hover:text-primary-700 w-full py-3 bg-white border border-primary-200 rounded-xl shadow-sm hover:shadow-md transition-all">
                  <Navigation className="w-4 h-4" />
                  Navigate
                </button>
                
                {task.status === 'Open' && (
                  <button 
                    onClick={() => handleCheckIn(task.id)}
                    className="flex items-center justify-center gap-2 text-sm font-bold text-white bg-gradient-to-r from-primary-500 to-primary-600 hover:from-primary-600 hover:to-primary-700 w-full py-3 rounded-xl shadow-[0_4px_12px_-2px_rgba(0,135,62,0.4)] hover:shadow-[0_8px_16px_-4px_rgba(0,135,62,0.6)] transition-all transform hover:-translate-y-0.5"
                  >
                    <MapPin className="w-4 h-4" />
                    Check-In
                  </button>
                )}
                
                {task.status === 'In Progress' && (
                  <button 
                    onClick={() => handleComplete(task.id)}
                    className="flex items-center justify-center gap-2 text-sm font-bold text-white bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 w-full py-3 rounded-xl shadow-[0_4px_12px_-2px_rgba(59,130,246,0.4)] transition-all transform hover:-translate-y-0.5"
                  >
                    <CheckCircle className="w-4 h-4" />
                    Complete Task
                  </button>
                )}

                {task.status === 'Completed' && (
                  <div className="flex items-center justify-center gap-2 text-sm font-bold text-emerald-600 bg-emerald-50 w-full py-3 rounded-xl border border-emerald-100">
                    <Check className="w-5 h-5" />
                    Done
                  </div>
                )}
              </div>
            </div>
          ))}
        </div>

        {/* Quick Actions & Alerts */}
        <div className="lg:col-span-1 space-y-6">
          <div className="bg-white rounded-2xl border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.03)] p-6 relative overflow-hidden">
            <div className="absolute top-0 right-0 w-32 h-32 bg-primary-500/5 blur-[40px] pointer-events-none"></div>

            <h2 className="text-sm font-bold text-slate-800 mb-5 uppercase tracking-wider relative z-10">Field Tools</h2>
            <div className="grid grid-cols-2 gap-4 relative z-10">
              <button className="flex flex-col items-center justify-center p-5 bg-slate-50 border border-slate-100 rounded-2xl hover:bg-white hover:border-primary-200 hover:shadow-md transition-all group">
                <div className="w-12 h-12 bg-white rounded-xl shadow-sm border border-slate-100 flex items-center justify-center mb-3 group-hover:scale-110 transition-transform">
                  <Camera className="w-6 h-6 text-slate-600 group-hover:text-primary-600" />
                </div>
                <span className="text-xs font-bold text-slate-700">Upload Photo</span>
              </button>
              <button className="flex flex-col items-center justify-center p-5 bg-slate-50 border border-slate-100 rounded-2xl hover:bg-white hover:border-primary-200 hover:shadow-md transition-all group">
                <div className="w-12 h-12 bg-white rounded-xl shadow-sm border border-slate-100 flex items-center justify-center mb-3 group-hover:scale-110 transition-transform">
                  <Briefcase className="w-6 h-6 text-slate-600 group-hover:text-primary-600" />
                </div>
                <span className="text-xs font-bold text-slate-700">Request Parts</span>
              </button>
            </div>
          </div>

          <div className="bg-gradient-to-br from-amber-50 to-white rounded-2xl border border-amber-200/60 p-6 shadow-sm relative overflow-hidden">
            <div className="absolute right-0 bottom-0 w-24 h-24 bg-amber-500/10 blur-[30px] pointer-events-none"></div>
            <div className="flex items-start gap-4 relative z-10">
              <div className="p-3 bg-amber-100 text-amber-600 rounded-xl shadow-sm shrink-0">
                <AlertCircle className="w-6 h-6" />
              </div>
              <div>
                <h3 className="text-sm font-bold text-amber-900 tracking-tight">Priority Dispatch Alert</h3>
                <p className="text-xs text-amber-700 mt-1.5 leading-relaxed font-medium">Task TSK-001 has been escalated by the customer. Please attend immediately after current job.</p>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
};

export default StaffDashboard;
