import React, { useState, useEffect } from 'react';
import { MapPin, Navigation, Clock, User, Camera, CalendarDays } from 'lucide-react';
import staffData from '../../mockData/staff.json';

const AdminMap: React.FC = () => {
  const [activeLocations, setActiveLocations] = useState<any[]>([]);
  const [selectedStaffId, setSelectedStaffId] = useState<string | null>(null);

  useEffect(() => {
    // Read staff tasks to find location data
    const saved = localStorage.getItem('staff_tasks');
    if (saved) {
      const tasks = JSON.parse(saved);
      // Filter tasks that have locationData
      const locatedTasks = tasks.filter((t: any) => t.locationData);
      
      // Sort to get the most recent ones first
      locatedTasks.sort((a: any, b: any) => (b.checkInTime || 0) - (a.checkInTime || 0));

      const staffMap = new Map();
      
      locatedTasks.forEach((task: any) => {
        // Only keep the most recent location per staff member
        if (!staffMap.has(task.assignedTo)) {
          const staff = staffData.find(s => s.id === task.assignedTo);
          staffMap.set(task.assignedTo, {
            ...task,
            staffName: staff?.name || task.assignedTo
          });
        }
      });

      setActiveLocations(Array.from(staffMap.values()));
    }
  }, []);

  return (
    <div className="space-y-8 pb-20 md:pb-0">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-white p-6 rounded-2xl shadow-[0_2px_10px_-3px_rgba(6,81,237,0.1)] border border-slate-100 relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-full bg-gradient-to-l from-primary-50/50 to-transparent pointer-events-none"></div>

        <div className="relative z-10">
          <h1 className="text-2xl font-extrabold text-slate-800 tracking-tight">Live Tracking</h1>
          <p className="text-slate-500 text-sm mt-1 font-medium">Monitor field technicians and site verification photos.</p>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        {/* Active Staff List */}
        <div className="lg:col-span-1 space-y-6">
          <h2 className="text-xs font-extrabold text-slate-400 uppercase tracking-widest ml-2">Recent Check-Ins</h2>
          
          <div className="bg-white rounded-2xl shadow-[0_4px_20px_-4px_rgba(0,0,0,0.03)] border border-slate-100 p-6 relative">
            <div className="absolute left-[39px] top-8 bottom-8 w-0.5 bg-slate-100"></div>
            
            <div className="space-y-8 relative">
              {activeLocations.length === 0 ? (
                <div className="text-center py-8">
                  <MapPin className="w-8 h-8 text-slate-300 mx-auto mb-2" />
                  <p className="text-sm font-medium text-slate-500">No staff currently checked-in.</p>
                </div>
              ) : (
                activeLocations.map((loc, index) => (
                  <div 
                    key={loc.id} 
                    className={`flex gap-4 group cursor-pointer transition-all ${selectedStaffId === loc.assignedTo ? 'scale-[1.02]' : ''}`}
                    onClick={() => setSelectedStaffId(loc.assignedTo)}
                  >
                    <div className={`w-8 h-8 rounded-full flex items-center justify-center shrink-0 z-10 text-white shadow-[0_0_0_4px_rgba(6,81,237,0.15)] transition-colors ${selectedStaffId === loc.assignedTo ? 'bg-secondary-500' : 'bg-primary-500'}`}>
                      <User className="w-4 h-4" />
                    </div>
                    
                    <div className={`flex-1 p-4 rounded-xl border transition-all ${selectedStaffId === loc.assignedTo ? 'bg-secondary-50 border-secondary-300 shadow-md ring-1 ring-secondary-300' : 'bg-primary-50/30 border-primary-100 hover:border-primary-300'}`}>
                      <div className="flex justify-between items-start mb-1">
                        <h3 className="font-bold text-slate-800">{loc.staffName}</h3>
                        <span className="text-[10px] font-bold text-slate-500 bg-white px-2 py-0.5 rounded border border-slate-200 uppercase">
                          {new Date(loc.checkInTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                        </span>
                      </div>
                      <p className="text-xs font-medium text-slate-500 mb-3 line-clamp-1">{loc.description}</p>
                      
                      <div className="flex flex-col gap-2 pt-3 border-t border-primary-100">
                        <div className="flex items-center gap-2 text-xs font-bold text-emerald-600">
                          <MapPin className="w-3.5 h-3.5" />
                          {loc.locationData.lat}, {loc.locationData.lng}
                        </div>
                        {loc.locationData.verified && (
                          <div className="flex flex-col gap-2 mt-2">
                            <div className="flex items-center gap-2 text-xs font-bold text-primary-600">
                              <Camera className="w-3.5 h-3.5" />
                              Photo Verified
                            </div>
                            {selectedStaffId === loc.assignedTo && loc.locationData.photoUrl && (
                              <div className="mt-2 animate-in fade-in slide-in-from-top-2 duration-300">
                                <img 
                                  src={loc.locationData.photoUrl} 
                                  alt="Site Verification" 
                                  className="w-full h-32 object-cover rounded-lg border border-slate-200 shadow-sm" 
                                />
                                <p className="text-[9px] text-slate-400 text-center mt-1 uppercase tracking-wider font-bold">Uploaded from site</p>
                              </div>
                            )}
                          </div>
                        )}
                      </div>
                    </div>
                  </div>
                ))
              )}
            </div>
          </div>
        </div>

        {/* Mock Map Visualization */}
        <div className="lg:col-span-2 space-y-4 h-full min-h-[600px]">
          <div className="bg-white rounded-2xl shadow-[0_4px_20px_-4px_rgba(0,0,0,0.03)] border border-slate-100 w-full h-full p-2 relative flex flex-col overflow-hidden">
            
            {/* The "Map" Area */}
            <div className="flex-1 bg-[#f0f4f8] rounded-xl overflow-hidden relative border border-slate-100">
              {(() => {
                const activeLocation = activeLocations.find(l => l.assignedTo === selectedStaffId) || activeLocations[0];
                const mapCenterLat = activeLocation && activeLocation.locationData ? parseFloat(activeLocation.locationData.lat) : 10.7905;
                const mapCenterLng = activeLocation && activeLocation.locationData ? parseFloat(activeLocation.locationData.lng) : 78.7047;

                const minLng = (mapCenterLng - 0.05).toFixed(4);
                const minLat = (mapCenterLat - 0.05).toFixed(4);
                const maxLng = (mapCenterLng + 0.05).toFixed(4);
                const maxLat = (mapCenterLat + 0.05).toFixed(4);
                
                const mapSrc = `https://www.openstreetmap.org/export/embed.html?bbox=${minLng},${minLat},${maxLng},${maxLat}&layer=mapnik&marker=${mapCenterLat},${mapCenterLng}`;

                return (
                  <iframe 
                    key={mapSrc}
                    width="100%" 
                    height="100%" 
                    frameBorder="0" 
                    scrolling="no" 
                    marginHeight={0} 
                    marginWidth={0} 
                    src={mapSrc} 
                    style={{ border: 0, filter: 'grayscale(0.3) contrast(1.1)', pointerEvents: 'none' }}
                    className="absolute inset-0 transition-opacity duration-500"
                  ></iframe>
                );
              })()}
              <div className="absolute inset-0 bg-primary/5 mix-blend-multiply pointer-events-none"></div>
              
              {activeLocations.length === 0 ? (
                 <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
                    <p className="text-slate-400 font-bold uppercase tracking-widest text-sm bg-white/80 px-4 py-2 rounded-xl backdrop-blur-sm">Waiting for GPS signals...</p>
                 </div>
              ) : (
                activeLocations.map((loc, index) => {
                  const lat = loc.locationData ? parseFloat(loc.locationData.lat) : 10.7905;
                  const lng = loc.locationData ? parseFloat(loc.locationData.lng) : 78.7047;
                  
                  // We map the lat/lng relative to the bounding box of the current view to position the pin
                  const activeLocation = activeLocations.find(l => l.assignedTo === selectedStaffId) || activeLocations[0];
                  const mapCenterLat = activeLocation && activeLocation.locationData ? parseFloat(activeLocation.locationData.lat) : 10.7905;
                  const mapCenterLng = activeLocation && activeLocation.locationData ? parseFloat(activeLocation.locationData.lng) : 78.7047;
                  
                  // Calculate percentage position based on a 0.1 degree bounding box (+/- 0.05 from center)
                  const topPos = 50 - ((lat - mapCenterLat) / 0.1) * 100;
                  const leftPos = 50 + ((lng - mapCenterLng) / 0.1) * 100;
                  
                  // Hide if way out of bounds
                  if (topPos < -20 || topPos > 120 || leftPos < -20 || leftPos > 120) return null;
                  
                  const isActive = selectedStaffId === loc.assignedTo;
                  
                  return (
                    <div 
                      key={loc.id} 
                      className={`absolute flex flex-col items-center cursor-pointer transition-all duration-300 ${isActive ? 'z-50 scale-125' : 'z-10 hover:z-40 hover:scale-110'}`} 
                      style={{ top: `${topPos}%`, left: `${leftPos}%`, transform: 'translate(-50%, -50%)' }}
                      onClick={() => setSelectedStaffId(loc.assignedTo)}
                    >
                      <div className={`${isActive ? 'bg-secondary-500' : 'bg-primary-600'} text-white p-2 rounded-full shadow-lg border-2 border-white relative z-10 ${isActive ? 'animate-bounce' : ''}`}>
                        <Navigation className="w-5 h-5 transform rotate-45" />
                      </div>
                      <div className={`bg-white px-3 py-1.5 rounded-lg shadow-md mt-2 border flex flex-col items-center transition-colors ${isActive ? 'border-secondary-400 ring-2 ring-secondary-100' : 'border-slate-200'}`}>
                        <span className="text-xs font-extrabold text-slate-800">{loc.staffName}</span>
                        <span className="text-[9px] font-bold text-slate-500 uppercase tracking-widest mt-0.5">{loc.id}</span>
                      </div>
                    </div>
                  );
                })
              )}
            </div>
          </div>
        </div>

      </div>
    </div>
  );
};

export default AdminMap;
