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
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 card relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-full bg-gradient-to-l from-primary-container/50 to-transparent pointer-events-none"></div>

        <div className="relative z-10">
          <h1 className="text-headline-lg text-on-surface">My Tasks</h1>
          <p className="text-body-md text-on-surface-variant mt-1">Your schedule and field routes for today.</p>
        </div>
        <div className="flex gap-6 items-center relative z-10 bg-surface-container px-6 py-3 rounded-xl border border-outline-variant">
          <div className="flex flex-col items-end">
            <span className="text-label-md text-on-surface-variant uppercase tracking-widest">Incentives Earned</span>
            <span className="text-headline-md font-extrabold text-primary mt-0.5">₹ 1,250</span>
          </div>
          <div className="h-10 w-px bg-outline-variant"></div>
          <div className="flex flex-col items-end">
            <span className="text-label-md text-on-surface-variant uppercase tracking-widest">Pending</span>
            <span className="text-headline-md font-extrabold text-on-surface mt-0.5">{tasks.filter(t => t.status !== 'Completed').length}</span>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        {/* Main Task List */}
        <div className="lg:col-span-2 space-y-4">
          <h2 className="text-label-lg font-bold text-on-surface uppercase tracking-wider ml-2">Today's Itinerary</h2>
          
          {tasks.map((task) => (
            <div key={task.id} className="card !p-0 flex flex-col md:flex-row transition-all duration-300 group">
              {/* Task Status/Priority Strip */}
              <div className={`w-full md:w-3 shrink-0 ${
                task.status === 'Completed' ? 'bg-gradient-to-b from-primary to-primary-container' :
                task.status === 'In Progress' ? 'bg-gradient-to-b from-secondary to-secondary-container' :
                task.type === 'Complaint' ? 'bg-gradient-to-b from-error to-error-container' : 'bg-gradient-to-b from-outline-variant to-outline'
              }`}></div>
              
              <div className="p-6 flex-1 flex flex-col justify-between">
                <div>
                  <div className="flex justify-between items-start mb-3">
                    <div className="flex items-center gap-2">
                      <span className="text-label-sm text-on-surface-variant bg-surface-container px-2 py-1 rounded-md tracking-wider">{task.id}</span>
                      <span className={`badge-${task.type === 'Complaint' ? 'expired' : 'active'}`}>
                        {task.type}
                      </span>
                    </div>
                    
                    {/* Status Badge */}
                    <div className="flex items-center gap-1.5 bg-surface-container px-3 py-1.5 rounded-full border border-outline-variant">
                      {task.status === 'Completed' ? <CheckCircle className="w-4 h-4 text-primary" /> : <Clock className="w-4 h-4 text-on-surface-variant" />}
                      <span className={`text-[11px] font-bold uppercase tracking-wider ${
                        task.status === 'Completed' ? 'text-primary' :
                        task.status === 'In Progress' ? 'text-secondary' : 'text-on-surface-variant'
                      }`}>{task.status}</span>
                    </div>
                  </div>
                  
                  <h3 className="text-title-lg font-extrabold text-on-surface mb-1.5">{customersData.find(c => c.id === task.customerId)?.name || task.customerId}</h3>
                  <p className="text-on-surface-variant text-body-md mb-5 leading-relaxed line-clamp-2 pr-4">{task.description}</p>
                </div>
                
                <div className="flex items-center gap-3 text-body-sm text-on-surface-variant bg-surface-container p-3 rounded-xl border border-outline-variant group-hover:border-outline transition-colors">
                  <div className="p-1.5 bg-surface-container-lowest rounded-lg shadow-sm border border-outline-variant">
                    <MapPin className="w-4 h-4 text-primary" />
                  </div>
                  <span className="truncate font-medium">123 Business Rd, Tech Park, City</span>
                </div>
              </div>
              
              {/* Action Area */}
              <div className="bg-surface-container border-t md:border-t-0 md:border-l border-surface-container-highest p-6 flex md:flex-col justify-center items-center gap-3 w-full md:w-56 shrink-0 relative overflow-hidden">
                <button className="flex items-center justify-center gap-2 text-label-lg font-bold text-primary hover:text-primary-container w-full py-3 bg-surface-container-lowest border border-primary-container rounded-xl shadow-sm hover:shadow-md transition-all">
                  <Navigation className="w-4 h-4" />
                  Navigate
                </button>
                
                {task.status === 'Open' && (
                  <button 
                    onClick={() => handleCheckIn(task.id)}
                    className="btn-primary flex items-center justify-center gap-2 text-label-lg w-full py-3"
                  >
                    <MapPin className="w-4 h-4" />
                    Check-In
                  </button>
                )}
                
                {task.status === 'In Progress' && (
                  <button 
                    onClick={() => handleComplete(task.id)}
                    className="flex items-center justify-center gap-2 text-label-lg font-bold text-on-secondary bg-secondary hover:bg-secondary-container w-full py-3 rounded-xl shadow-md transition-all transform hover:-translate-y-0.5"
                  >
                    <CheckCircle className="w-4 h-4" />
                    Complete Task
                  </button>
                )}

                {task.status === 'Completed' && (
                  <div className="flex items-center justify-center gap-2 text-label-lg font-bold text-primary bg-primary-fixed w-full py-3 rounded-xl border border-primary-container">
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
          <div className="card relative overflow-hidden p-6">
            <div className="absolute top-0 right-0 w-32 h-32 bg-primary/5 blur-[40px] pointer-events-none"></div>

            <h2 className="text-title-md font-bold text-on-surface mb-5 uppercase tracking-wider relative z-10">Field Tools</h2>
            <div className="grid grid-cols-2 gap-4 relative z-10">
              <button className="flex flex-col items-center justify-center p-5 bg-surface-container border border-outline-variant rounded-2xl hover:bg-surface-container-lowest hover:border-primary-container hover:shadow-md transition-all group">
                <div className="w-12 h-12 bg-surface-container-lowest rounded-xl shadow-sm border border-outline-variant flex items-center justify-center mb-3 group-hover:scale-110 transition-transform">
                  <Camera className="w-6 h-6 text-on-surface-variant group-hover:text-primary" />
                </div>
                <span className="text-label-md font-bold text-on-surface">Upload Photo</span>
              </button>
              <button className="flex flex-col items-center justify-center p-5 bg-surface-container border border-outline-variant rounded-2xl hover:bg-surface-container-lowest hover:border-primary-container hover:shadow-md transition-all group">
                <div className="w-12 h-12 bg-surface-container-lowest rounded-xl shadow-sm border border-outline-variant flex items-center justify-center mb-3 group-hover:scale-110 transition-transform">
                  <Briefcase className="w-6 h-6 text-on-surface-variant group-hover:text-primary" />
                </div>
                <span className="text-label-md font-bold text-on-surface">Request Parts</span>
              </button>
            </div>
          </div>

          <div className="bg-error-container text-on-error-container rounded-2xl border border-error/20 p-6 shadow-sm relative overflow-hidden">
            <div className="absolute right-0 bottom-0 w-24 h-24 bg-error/10 blur-[30px] pointer-events-none"></div>
            <div className="flex items-start gap-4 relative z-10">
              <div className="p-3 bg-error text-on-error rounded-xl shadow-sm shrink-0">
                <AlertCircle className="w-6 h-6" />
              </div>
              <div>
                <h3 className="text-title-sm font-bold text-on-error-container tracking-tight">Priority Dispatch Alert</h3>
                <p className="text-body-sm text-on-error-container/80 mt-1.5 leading-relaxed font-medium">Task TSK-001 has been escalated by the customer. Please attend immediately after current job.</p>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
};

export default StaffDashboard;
