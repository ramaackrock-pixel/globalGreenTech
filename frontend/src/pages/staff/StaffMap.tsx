import React, { useState, useEffect } from 'react';
import { MapPin, Navigation, Clock, CheckCircle } from 'lucide-react';
import tasksData from '../../mockData/tasks.json';
import customersData from '../../mockData/customers.json';

const StaffMap: React.FC = () => {
  const [tasks, setTasks] = useState(tasksData);
  const [customers, setCustomers] = useState(customersData);

  useEffect(() => {
    const savedTasks = localStorage.getItem('staff_tasks');
    if (savedTasks) {
      setTasks(JSON.parse(savedTasks));
    }
    const savedCustomers = localStorage.getItem('customers_data');
    if (savedCustomers) {
      setCustomers(JSON.parse(savedCustomers));
    }
  }, []);

  // Mock logged-in staff
  const myTasks = tasks.filter(task => task.assignedTo === 's1'); // Assuming 's1' is Rahul Kumar or similar
  
  // Create a timeline of stops
  const stops = myTasks.map((task, index) => {
    const customer = customers.find(c => c.id === task.customerId);
    return {
      ...task,
      customerName: customer?.name || task.customerId,
      address: customer?.address || '123 Business Rd, Tech Park, City', // Fallback address
      order: index + 1
    };
  });

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 card relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-full bg-gradient-to-l from-primary-container/50 to-transparent pointer-events-none"></div>

        <div className="relative z-10">
          <h1 className="text-headline-lg text-on-surface">Route Map</h1>
          <p className="text-body-md text-on-surface-variant mt-1">Your optimized field route for today.</p>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        {/* Route Timeline */}
        <div className="lg:col-span-1 space-y-6">
          <h2 className="text-label-lg font-bold text-on-surface uppercase tracking-wider ml-2">Today's Stops</h2>
          
          <div className="card p-6 relative">
            <div className="absolute left-[39px] top-8 bottom-8 w-0.5 bg-outline-variant/30"></div>
            
            <div className="space-y-8 relative">
              {stops.map((stop, index) => {
                const isCompleted = stop.status === 'Completed';
                const isCurrent = stop.status === 'In Progress' || (stop.status === 'Open' && index === 0);
                
                return (
                  <div key={stop.id} className="flex gap-4 group">
                    <div className={`w-8 h-8 rounded-full flex items-center justify-center shrink-0 z-10 ${
                      isCompleted ? 'bg-primary text-on-primary' :
                      isCurrent ? 'bg-secondary text-on-secondary shadow-[0_0_0_4px_rgba(6,182,212,0.2)]' :
                      'bg-surface-container-highest text-on-surface-variant'
                    }`}>
                      {isCompleted ? <CheckCircle className="w-4 h-4" /> : <span className="text-label-md">{stop.order}</span>}
                    </div>
                    
                    <div className={`flex-1 p-4 rounded-xl border transition-all ${
                      isCurrent ? 'bg-secondary/5 border-secondary hover:shadow-md' : 
                      'bg-surface-container-lowest border-outline-variant/40 hover:border-outline'
                    }`}>
                      <div className="flex justify-between items-start mb-1">
                        <h3 className={`font-bold ${isCurrent ? 'text-secondary' : 'text-on-surface'}`}>
                          {stop.customerName}
                        </h3>
                        <span className="text-label-sm text-on-surface-variant">{stop.date}</span>
                      </div>
                      <p className="text-body-sm text-on-surface-variant mb-3">{stop.address}</p>
                      
                      {isCurrent && (
                        <button className="flex items-center justify-center gap-2 text-label-md font-bold text-white bg-primary hover:bg-primary-container w-full py-2 rounded-lg transition-all">
                          <Navigation className="w-4 h-4" />
                          Start Navigation
                        </button>
                      )}
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        </div>

        {/* Mock Map Visualization */}
        <div className="lg:col-span-2 space-y-4 h-full min-h-[500px]">
          <div className="card w-full h-full p-2 relative flex flex-col">
            {/* Toolbar inside map */}
            <div className="absolute top-6 left-6 z-10 flex gap-2">
              <div className="bg-surface-container-lowest/90 backdrop-blur-md px-4 py-2 rounded-lg border border-outline-variant/50 shadow-sm flex items-center gap-2 text-body-sm font-bold text-on-surface">
                <Clock className="w-4 h-4 text-primary" />
                Est. Total Time: 4h 30m
              </div>
            </div>
            
            {/* The "Map" Area - using a stylized background to look like a map placeholder */}
            <div className="flex-1 bg-[#e5e9ec] rounded-xl overflow-hidden relative border border-outline-variant/20">
              <iframe 
                width="100%" 
                height="100%" 
                frameBorder="0" 
                scrolling="no" 
                marginHeight={0} 
                marginWidth={0} 
                src="https://www.openstreetmap.org/export/embed.html?bbox=77.50,12.90,77.70,13.05&amp;layer=mapnik" 
                style={{ border: 0, filter: 'grayscale(0.3) contrast(1.1)', pointerEvents: 'none' }}
                className="absolute inset-0"
              ></iframe>
              <div className="absolute inset-0 bg-primary/5 mix-blend-multiply pointer-events-none"></div>
              

              
              {/* Map Pins */}
              {stops.map((stop, index) => {
                // Predefined mock positions for visual presentation
                const positions = [
                  { top: '30%', left: '20%' },
                  { top: '40%', left: '60%' },
                  { top: '70%', left: '80%' },
                  { top: '20%', left: '80%' },
                  { top: '80%', left: '30%' }
                ];
                const pos = positions[index % positions.length];
                const isCompleted = stop.status === 'Completed';
                const isCurrent = stop.status === 'In Progress' || (stop.status === 'Open' && index === 0) || stop.status === 'Scheduled';

                return (
                  <div key={stop.id} className="absolute -translate-x-1/2 -translate-y-1/2 flex flex-col items-center transition-all duration-500" style={{ top: pos.top, left: pos.left }}>
                    <div className={`p-2 rounded-full shadow-lg border-2 border-white relative z-10 ${
                      isCurrent ? 'bg-primary text-white animate-bounce' : 
                      isCompleted ? 'bg-emerald-500 text-white' : 
                      'bg-surface-container-highest text-on-surface-variant'
                    }`}>
                      <MapPin className={isCurrent ? "w-6 h-6" : "w-5 h-5"} />
                    </div>
                    <div className={`bg-surface-container-lowest px-3 py-1 rounded-md text-label-sm font-bold shadow-sm mt-1 border border-outline-variant/50 ${!isCurrent && 'opacity-70'}`}>
                      Stop {index + 1}
                    </div>
                  </div>
                );
              })}

            </div>
          </div>
        </div>

      </div>
    </div>
  );
};

export default StaffMap;
