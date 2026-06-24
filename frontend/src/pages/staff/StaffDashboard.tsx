import React, { useState, useEffect } from 'react';
import { Briefcase, MapPin, CheckCircle, Clock, Navigation, AlertCircle, Camera, Check, LogOut, ClipboardList } from 'lucide-react';
import customersData from '../../mockData/customers.json';
import tasksData from '../../mockData/tasks.json';

const StaffDashboard: React.FC = () => {
  // Mock logged-in staff
  const myTasks = tasksData.filter(task => task.assignedTo === 's1');
  const [tasks, setTasks] = useState<any[]>(() => {
    const saved = localStorage.getItem('staff_tasks');
    if (saved) return JSON.parse(saved);
    return myTasks;
  });

  const [showCheckInModal, setShowCheckInModal] = useState(false);
  const [activeTaskId, setActiveTaskId] = useState<string | null>(null);
  const [locationFetched, setLocationFetched] = useState<{lat: number, lng: number} | null>(null);
  const [photoUploaded, setPhotoUploaded] = useState(false);
  const [showRequestModal, setShowRequestModal] = useState(false);
  const [requestPart, setRequestPart] = useState('');
  const [requestQty, setRequestQty] = useState('1');

  // Job Photos Modal State
  const [showPhotoModal, setShowPhotoModal] = useState(false);
  const [photoFile, setPhotoFile] = useState<File | null>(null);
  const [photoDesc, setPhotoDesc] = useState('');
  const [photoTaskId, setPhotoTaskId] = useState('');
  const [photoType, setPhotoType] = useState('Before Work');

  // Payment Link Modal State
  const [showPaymentModal, setShowPaymentModal] = useState(false);
  const [paymentAmount, setPaymentAmount] = useState('');
  const [paymentTaskId, setPaymentTaskId] = useState<string | null>(null);

  // Service Checklist State
  const [serviceReports, setServiceReports] = useState<any[]>(() => {
    return JSON.parse(localStorage.getItem('service_reports') || '[]');
  });
  const [showChecklistModal, setShowChecklistModal] = useState(false);
  const [checklistTaskId, setChecklistTaskId] = useState<string | null>(null);
  const [checklistData, setChecklistData] = useState({
    rawTds: '',
    roTds: '',
    phLevel: '',
    flowRate: '',
    pressure: '',
    spunFilter: false,
    mediumFilter: false,
    woundFilter: false,
    antiscalant: false,
    softener: false
  });

  useEffect(() => {
    localStorage.setItem('staff_tasks', JSON.stringify(tasks));
  }, [tasks]);

  const [totalIncentives, setTotalIncentives] = useState(0);

  useEffect(() => {
    const savedIncentives = localStorage.getItem('staff_incentives');
    if (savedIncentives) {
      const records = JSON.parse(savedIncentives);
      const dynamicSum = records
        .filter((r: any) => r.staffId === 's1')
        .reduce((sum: number, r: any) => sum + Number(r.amount), 0);
      setTotalIncentives(dynamicSum);
    }
  }, []);

  const openCheckInModal = (taskId: string) => {
    setActiveTaskId(taskId);
    setLocationFetched(null);
    setPhotoUploaded(false);
    setShowCheckInModal(true);
  };

  const fetchLocation = () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          setLocationFetched({ lat: position.coords.latitude, lng: position.coords.longitude });
        },
        (error) => {
          console.error("Error fetching location", error);
          // Fallback to Trichy if blocked
          setLocationFetched({ lat: 10.7905, lng: 78.7047 });
        }
      );
    } else {
      setLocationFetched({ lat: 10.7905, lng: 78.7047 });
    }
  };

  const handleCheckIn = () => {
    if (activeTaskId) {
      setTasks(tasks.map(t =>
        t.id === activeTaskId ? { 
           ...t, 
           status: 'In Progress', 
           checkInTime: new Date().getTime(),
           locationData: { 
             lat: locationFetched?.lat.toFixed(4) || '10.7905', 
             lng: locationFetched?.lng.toFixed(4) || '78.7047', 
             verified: true,
             photoUrl: 'https://images.unsplash.com/photo-1581092921461-eab62e97a780?q=80&w=400&auto=format&fit=crop'
           } 
        } : t
      ));
      setShowCheckInModal(false);
      setActiveTaskId(null);
    }
  };

  const handleCheckOut = (taskId: string) => {
    setPaymentTaskId(taskId);
    setPaymentAmount('');
    setShowPaymentModal(true);
  };

  const submitPaymentAndComplete = () => {
    if (paymentTaskId && paymentAmount) {
      setTasks(tasks.map(t =>
        t.id === paymentTaskId ? { ...t, status: 'Completed', checkOutTime: new Date().getTime(), price: Number(paymentAmount) } : t
      ));
      alert(`Payment Link (₹${paymentAmount}) and Review Link successfully generated and sent to customer via WhatsApp!`);
      setShowPaymentModal(false);
      setPaymentTaskId(null);
    }
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
            <span className="text-headline-md font-extrabold text-primary mt-0.5">₹ {totalIncentives.toLocaleString()}</span>
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
        <div className="lg:col-span-2">
          <h2 className="text-label-lg font-bold text-on-surface uppercase tracking-wider ml-2 mb-4">Today's Itinerary</h2>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
            {tasks.map((task) => (
              <div key={task.id} className="card flex flex-col transition-all duration-300 group h-full relative">
                {/* Task Status/Priority Top Strip */}
                <div className={`absolute top-0 left-0 w-full h-1.5 ${task.status === 'Completed' ? 'bg-gradient-to-r from-primary to-primary-container' :
                    task.status === 'In Progress' ? 'bg-gradient-to-r from-secondary to-secondary-container' :
                      task.type === 'Complaint' ? 'bg-gradient-to-r from-error to-error-container' : 'bg-gradient-to-r from-outline-variant to-outline'
                  }`}></div>

                <div className="p-6 flex-1 flex flex-col justify-between pt-8">
                  <div>
                    <div className="flex justify-between items-start mb-4">
                      <div className="flex items-center gap-2">
                        <span className="text-label-sm font-bold text-on-surface-variant bg-surface-container px-2.5 py-1 rounded-md tracking-wider">{task.id}</span>
                      </div>

                      {/* Status Badge */}
                      <div className={`flex items-center gap-1.5 px-3 py-1 rounded-full border ${task.status === 'Completed' ? 'bg-primary-container/20 border-primary/30 text-primary' :
                          task.status === 'In Progress' ? 'bg-secondary-container/20 border-secondary/30 text-secondary' : 'bg-surface-container border-outline-variant text-on-surface-variant'
                        }`}>
                        {task.status === 'Completed' ? <CheckCircle className="w-3.5 h-3.5" /> : <Clock className="w-3.5 h-3.5" />}
                        <span className="text-[11px] font-bold uppercase tracking-wider">{task.status}</span>
                      </div>
                    </div>

                    <h3 className="text-title-lg font-extrabold text-on-surface mb-1">{customersData.find(c => c.id === task.customerId)?.name || task.customerId}</h3>
                    <span className={`inline-block mb-3 badge-${task.type === 'Complaint' ? 'expired' : 'active'} !py-0.5 !px-2 !text-[10px]`}>
                      {task.type}
                    </span>
                    <p className="text-on-surface-variant text-body-sm mb-5 leading-relaxed line-clamp-2">{task.description}</p>
                  </div>

                  <div className="flex flex-col gap-4">
                    <div className="flex items-center gap-3 text-body-sm text-on-surface-variant bg-surface-container/50 p-2.5 rounded-xl border border-outline-variant/50">
                      <div className="p-1.5 bg-surface-container-lowest rounded-lg shadow-sm border border-outline-variant/50">
                        <MapPin className="w-4 h-4 text-primary" />
                      </div>
                      <span className="truncate font-medium">123 Business Rd, Tech Park</span>
                    </div>

                    {/* Action Area integrated in grid card */}
                    <div className="grid grid-cols-2 gap-3 pt-2 border-t border-surface-container-highest">
                      <button className="flex items-center justify-center gap-2 text-label-md font-bold text-on-surface-variant hover:text-primary w-full py-2.5 bg-surface-container hover:bg-surface-container-lowest border border-outline-variant hover:border-primary-container rounded-xl transition-all">
                        <Navigation className="w-4 h-4" />
                        Nav
                      </button>

                      {['Open', 'Scheduled'].includes(task.status) && (
                        <button
                          onClick={() => openCheckInModal(task.id)}
                          className="btn-primary flex items-center justify-center gap-2 text-label-md w-full !py-2.5"
                        >
                          <MapPin className="w-4 h-4" />
                          Check-In
                        </button>
                      )}

                      {task.status === 'In Progress' && (
                        <>
                          <button
                            onClick={() => {
                              const existingReport = serviceReports.find(r => r.taskId === task.id);
                              if (existingReport) {
                                setChecklistData(existingReport.data);
                              } else {
                                setChecklistData({
                                  rawTds: '', roTds: '', phLevel: '', flowRate: '', pressure: '',
                                  spunFilter: false, mediumFilter: false, woundFilter: false, antiscalant: false, softener: false
                                });
                              }
                              setChecklistTaskId(task.id);
                              setShowChecklistModal(true);
                            }}
                            className={`flex items-center justify-center gap-2 text-label-md font-bold w-full py-2.5 rounded-xl shadow-sm transition-all border ${
                              serviceReports.some(r => r.taskId === task.id) 
                                ? 'bg-emerald-50 text-emerald-700 border-emerald-200' 
                                : 'bg-surface-container hover:bg-surface-container-lowest border-outline-variant hover:border-primary-container text-on-surface-variant hover:text-primary'
                            }`}
                          >
                            {serviceReports.some(r => r.taskId === task.id) ? <Check className="w-4 h-4" /> : <ClipboardList className="w-4 h-4" />}
                            {serviceReports.some(r => r.taskId === task.id) ? 'Checklist Done' : 'Checklist'}
                          </button>

                          <button
                            onClick={() => handleCheckOut(task.id)}
                            className="col-span-2 flex items-center justify-center gap-2 text-label-md font-bold text-on-secondary bg-secondary hover:bg-secondary-container w-full py-2.5 rounded-xl shadow-md transition-all transform hover:-translate-y-0.5"
                          >
                            <LogOut className="w-4 h-4" />
                            Check-Out
                          </button>
                        </>
                      )}

                      {task.status === 'Completed' && (
                        <div className="flex flex-col items-center justify-center gap-0.5 w-full bg-surface-container-lowest py-1.5 rounded-xl border border-outline-variant/30">
                          <div className="flex items-center gap-1 text-label-sm font-bold text-primary">
                            <Check className="w-3.5 h-3.5" /> Done
                          </div>
                          {task.checkInTime && task.checkOutTime && (
                            <span className="text-[10px] text-on-surface-variant font-bold">
                              {Math.max(1, Math.floor((task.checkOutTime - task.checkInTime) / 60000))}m serviced
                            </span>
                          )}
                        </div>
                      )}
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Quick Actions & Alerts */}
        <div className="lg:col-span-1 space-y-6">
          <div className="card relative overflow-hidden p-6">
            <div className="absolute top-0 right-0 w-32 h-32 bg-primary/5 blur-[40px] pointer-events-none"></div>

            <h2 className="text-title-md font-bold text-on-surface mb-5 uppercase tracking-wider relative z-10">Field Tools</h2>
            <div className="grid grid-cols-2 gap-4 relative z-10">
              
              {/* Upload Photo Button */}
              <button 
                onClick={() => setShowPhotoModal(true)}
                className="flex flex-col items-center justify-center p-5 bg-surface-container border border-outline-variant rounded-2xl hover:bg-surface-container-lowest hover:border-primary-container hover:shadow-md transition-all group"
              >
                <div className="w-12 h-12 bg-surface-container-lowest rounded-xl shadow-sm border border-outline-variant flex items-center justify-center mb-3 group-hover:scale-110 transition-transform">
                  <Camera className="w-6 h-6 text-on-surface-variant group-hover:text-primary" />
                </div>
                <span className="text-label-md font-bold text-on-surface">Job Photos</span>
              </button>
              
              {/* Request Parts Button */}
              <button 
                onClick={() => setShowRequestModal(true)}
                className="flex flex-col items-center justify-center p-5 bg-surface-container border border-outline-variant rounded-2xl hover:bg-surface-container-lowest hover:border-primary-container hover:shadow-md transition-all group"
              >
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

      {showCheckInModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" onClick={() => setShowCheckInModal(false)}></div>
          <div className="bg-white rounded-3xl shadow-2xl w-full max-w-sm relative z-10 p-6 overflow-hidden animate-in fade-in zoom-in-95 duration-200">
            <h2 className="text-title-lg font-bold text-on-surface mb-2">Site Verification</h2>
            <p className="text-body-sm text-on-surface-variant mb-6">Please verify your location and upload a site photo to check in.</p>
            
            <div className="space-y-4 mb-8">
              <button 
                onClick={fetchLocation}
                className={`w-full p-4 rounded-xl border flex items-center justify-between transition-all ${locationFetched ? 'bg-primary/10 border-primary text-primary' : 'bg-surface-container border-outline-variant hover:border-primary/50'}`}
              >
                <div className="flex items-center gap-3">
                  <MapPin className="w-5 h-5" />
                  <span className="font-bold">{locationFetched ? `${locationFetched.lat.toFixed(4)}° N, ${locationFetched.lng.toFixed(4)}° E` : 'Fetch GPS Location'}</span>
                </div>
                {locationFetched && <CheckCircle className="w-5 h-5" />}
              </button>

              <button 
                onClick={() => setPhotoUploaded(true)}
                className={`w-full p-4 rounded-xl border flex items-center justify-between transition-all ${photoUploaded ? 'bg-primary/10 border-primary text-primary' : 'bg-surface-container border-outline-variant hover:border-primary/50'}`}
              >
                <div className="flex items-center gap-3">
                  <Camera className="w-5 h-5" />
                  <span className="font-bold">{photoUploaded ? 'photo_site_12.jpg' : 'Take Site Photo'}</span>
                </div>
                {photoUploaded && <CheckCircle className="w-5 h-5" />}
              </button>
            </div>

            <div className="flex gap-3">
              <button onClick={() => setShowCheckInModal(false)} className="flex-1 py-3 font-bold text-slate-600 bg-slate-100 hover:bg-slate-200 rounded-xl transition-colors">Cancel</button>
              <button 
                onClick={handleCheckIn}
                disabled={!locationFetched || !photoUploaded}
                className="flex-1 py-3 font-bold text-white bg-primary rounded-xl disabled:opacity-50 disabled:cursor-not-allowed hover:bg-primary/90 transition-colors shadow-md disabled:shadow-none"
              >
                Confirm
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Request Parts Modal */}
      {showRequestModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" onClick={() => setShowRequestModal(false)}></div>
          <div className="bg-white rounded-3xl shadow-2xl w-full max-w-sm relative z-10 p-6 overflow-hidden animate-in fade-in zoom-in-95 duration-200">
            <h2 className="text-title-lg font-bold text-on-surface mb-2">Request Spare Parts</h2>
            <p className="text-body-sm text-on-surface-variant mb-6">Submit an inventory request to the Admin for approval.</p>
            
            <div className="space-y-4 mb-8">
              <div className="space-y-1.5">
                <label className="text-label-md font-bold text-on-surface uppercase tracking-wide">Select Part</label>
                <select 
                  value={requestPart}
                  onChange={(e) => setRequestPart(e.target.value)}
                  className="w-full p-3 rounded-xl border border-outline-variant focus:border-primary outline-none"
                >
                  <option value="">-- Choose Part --</option>
                  <option value="RO Membrane">RO Membrane (75 GPD)</option>
                  <option value="Carbon Filter">Carbon Filter</option>
                  <option value="Sediment Filter">Sediment Filter</option>
                  <option value="Booster Pump">Booster Pump</option>
                </select>
              </div>

              <div className="space-y-1.5">
                <label className="text-label-md font-bold text-on-surface uppercase tracking-wide">Quantity</label>
                <input 
                  type="number" 
                  min="1"
                  value={requestQty}
                  onChange={(e) => setRequestQty(e.target.value)}
                  className="w-full p-3 rounded-xl border border-outline-variant focus:border-primary outline-none"
                />
              </div>
            </div>

            <div className="flex gap-3">
              <button onClick={() => setShowRequestModal(false)} className="flex-1 py-3 font-bold text-slate-600 bg-slate-100 hover:bg-slate-200 rounded-xl transition-colors">Cancel</button>
              <button 
                onClick={() => {
                  if (!requestPart) return;
                  
                  const existingReqs = JSON.parse(localStorage.getItem('inventory_requests') || '[]');
                  const newReq = {
                    id: Math.random().toString(36).substring(7),
                    partName: requestPart,
                    quantity: requestQty,
                    staffId: 's1',
                    staffName: 'Rahul Kumar',
                    status: 'Pending',
                    timestamp: new Date().getTime()
                  };
                  localStorage.setItem('inventory_requests', JSON.stringify([newReq, ...existingReqs]));

                  alert(`Successfully requested ${requestQty}x ${requestPart} from Admin.`);
                  setShowRequestModal(false);
                  setRequestPart('');
                  setRequestQty('1');
                }}
                disabled={!requestPart}
                className="flex-1 py-3 font-bold text-white bg-primary rounded-xl disabled:opacity-50 hover:bg-primary/90 transition-colors shadow-md"
              >
                Submit Request
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Job Photos Modal */}
      {showPhotoModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" onClick={() => setShowPhotoModal(false)}></div>
          <div className="bg-white rounded-3xl shadow-2xl w-full max-w-md relative z-10 p-6 overflow-hidden animate-in fade-in zoom-in-95 duration-200">
            <h2 className="text-title-lg font-bold text-on-surface mb-2">Upload Job Photo</h2>
            <p className="text-body-sm text-on-surface-variant mb-6">Attach a before/after photo or defect report to a task.</p>
            
            <div className="space-y-4 mb-8">
              <div className="space-y-1.5">
                <label className="text-label-md font-bold text-on-surface uppercase tracking-wide">Select Photo</label>
                <input 
                  type="file" 
                  accept="image/*"
                  onChange={(e) => {
                    if (e.target.files && e.target.files.length > 0) {
                      setPhotoFile(e.target.files[0]);
                    }
                  }}
                  className="w-full text-sm text-slate-500 file:mr-4 file:py-2.5 file:px-4 file:rounded-xl file:border-0 file:text-sm file:font-bold file:bg-primary-50 file:text-primary hover:file:bg-primary-100 cursor-pointer border border-outline-variant rounded-xl"
                />
              </div>

              <div className="space-y-1.5">
                <label className="text-label-md font-bold text-on-surface uppercase tracking-wide">Related Task</label>
                <select 
                  value={photoTaskId}
                  onChange={(e) => setPhotoTaskId(e.target.value)}
                  className="w-full p-3 rounded-xl border border-outline-variant focus:border-primary outline-none"
                >
                  <option value="">-- General / No Task --</option>
                  {tasks.map(t => (
                    <option key={t.id} value={t.id}>{t.id} - {t.type}</option>
                  ))}
                </select>
              </div>

              <div className="space-y-1.5">
                <label className="text-label-md font-bold text-on-surface uppercase tracking-wide">Photo Type</label>
                <select 
                  value={photoType}
                  onChange={(e) => setPhotoType(e.target.value)}
                  className="w-full p-3 rounded-xl border border-outline-variant focus:border-primary outline-none"
                >
                  <option value="Before Work">Before Work</option>
                  <option value="After Work">After Work</option>
                  <option value="Defect / Damage">Defect / Damage</option>
                  <option value="Receipt / Expense">Receipt / Expense</option>
                  <option value="Other">Other</option>
                </select>
              </div>

              <div className="space-y-1.5">
                <label className="text-label-md font-bold text-on-surface uppercase tracking-wide">Description</label>
                <textarea 
                  rows={3}
                  value={photoDesc}
                  onChange={(e) => setPhotoDesc(e.target.value)}
                  placeholder="E.g., Scratches on the front panel before service..."
                  className="w-full p-3 rounded-xl border border-outline-variant focus:border-primary outline-none resize-none"
                />
              </div>
            </div>

            <div className="flex gap-3">
              <button onClick={() => setShowPhotoModal(false)} className="flex-1 py-3 font-bold text-slate-600 bg-slate-100 hover:bg-slate-200 rounded-xl transition-colors">Cancel</button>
              <button 
                onClick={() => {
                  const savePhotoData = (url: string) => {
                    const existingPhotos = JSON.parse(localStorage.getItem('job_photos') || '[]');
                    const newPhoto = {
                      id: Math.random().toString(36).substring(7),
                      taskId: photoTaskId || 'General',
                      staffId: 's1',
                      staffName: 'Rahul Kumar',
                      photoUrl: url,
                      photoType: photoType,
                      description: photoDesc || 'No description provided.',
                      timestamp: new Date().getTime()
                    };
                    localStorage.setItem('job_photos', JSON.stringify([newPhoto, ...existingPhotos]));
                    
                    alert('Photo saved successfully!');
                    setShowPhotoModal(false);
                    setPhotoFile(null);
                    setPhotoDesc('');
                    setPhotoTaskId('');
                    setPhotoType('Before Work');
                  };

                  if (photoFile) {
                    const reader = new FileReader();
                    reader.onloadend = () => {
                      savePhotoData(reader.result as string);
                    };
                    reader.readAsDataURL(photoFile);
                  } else {
                    savePhotoData('https://images.unsplash.com/photo-1581092921461-eab62e97a780?q=80&w=400&auto=format&fit=crop');
                  }
                }}
                disabled={!photoFile && photoDesc === ''}
                className="flex-1 py-3 font-bold text-white bg-primary rounded-xl disabled:opacity-50 hover:bg-primary/90 transition-colors shadow-md"
              >
                Upload & Save
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Payment Link Modal */}
      {showPaymentModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" onClick={() => setShowPaymentModal(false)}></div>
          <div className="bg-white rounded-3xl shadow-2xl w-full max-w-sm relative z-10 p-6 overflow-hidden animate-in fade-in zoom-in-95 duration-200">
            <h2 className="text-title-lg font-bold text-on-surface mb-2">Service Completed</h2>
            <p className="text-body-sm text-on-surface-variant mb-6">Enter the final service amount to generate and send a Payment & Review link via WhatsApp.</p>
            
            <div className="space-y-4 mb-8">
              <div className="space-y-1.5">
                <label className="text-label-md font-bold text-on-surface uppercase tracking-wide">Final Bill Amount (₹)</label>
                <div className="relative">
                  <span className="absolute left-4 top-1/2 -translate-y-1/2 text-on-surface-variant font-bold">₹</span>
                  <input 
                    type="number" 
                    min="1"
                    placeholder="e.g. 1500"
                    value={paymentAmount}
                    onChange={(e) => setPaymentAmount(e.target.value)}
                    className="w-full pl-8 p-3 rounded-xl border border-outline-variant focus:border-primary outline-none font-bold text-on-surface"
                  />
                </div>
              </div>
            </div>

            <div className="flex gap-3">
              <button onClick={() => setShowPaymentModal(false)} className="flex-1 py-3 font-bold text-slate-600 bg-slate-100 hover:bg-slate-200 rounded-xl transition-colors">Cancel</button>
              <button 
                onClick={submitPaymentAndComplete}
                disabled={!paymentAmount}
                className="flex-1 py-3 px-2 font-bold text-white bg-[#25D366] rounded-xl disabled:opacity-50 hover:bg-[#128C7E] transition-colors shadow-md flex items-center justify-center text-[12px] leading-tight text-center"
              >
                Send Payment & Review Link
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Service Checklist Modal */}
      {showChecklistModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" onClick={() => setShowChecklistModal(false)}></div>
          <div className="bg-white rounded-3xl shadow-2xl w-full max-w-xl relative z-10 p-6 overflow-hidden animate-in fade-in zoom-in-95 duration-200 max-h-[90vh] overflow-y-auto">
            <div className="flex items-center gap-3 mb-2">
              <div className="p-2 bg-primary/10 rounded-lg text-primary"><ClipboardList className="w-6 h-6" /></div>
              <div>
                <h2 className="text-title-lg font-bold text-on-surface">Service Checklist</h2>
                <p className="text-label-md text-on-surface-variant">Task: {checklistTaskId}</p>
              </div>
            </div>
            
            <div className="mt-6 space-y-6">
              {/* Section 1: Water Quality */}
              <div>
                <h3 className="text-label-lg font-bold text-on-surface mb-4 uppercase tracking-widest border-b border-surface-container-highest pb-2">1. Water Quality Metrics</h3>
                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-1.5">
                    <label className="text-label-sm font-bold text-on-surface-variant">Raw Water TDS (ppm)</label>
                    <input type="number" value={checklistData.rawTds} onChange={(e) => setChecklistData({...checklistData, rawTds: e.target.value})} className="w-full p-2.5 rounded-lg border border-outline-variant focus:border-primary outline-none" />
                  </div>
                  <div className="space-y-1.5">
                    <label className="text-label-sm font-bold text-on-surface-variant">RO Water TDS (ppm)</label>
                    <input type="number" value={checklistData.roTds} onChange={(e) => setChecklistData({...checklistData, roTds: e.target.value})} className="w-full p-2.5 rounded-lg border border-outline-variant focus:border-primary outline-none" />
                  </div>
                  <div className="space-y-1.5">
                    <label className="text-label-sm font-bold text-on-surface-variant">pH Level</label>
                    <input type="number" step="0.1" value={checklistData.phLevel} onChange={(e) => setChecklistData({...checklistData, phLevel: e.target.value})} className="w-full p-2.5 rounded-lg border border-outline-variant focus:border-primary outline-none" />
                  </div>
                  <div className="space-y-1.5">
                    <label className="text-label-sm font-bold text-on-surface-variant">Flow Rate (LPH)</label>
                    <input type="number" value={checklistData.flowRate} onChange={(e) => setChecklistData({...checklistData, flowRate: e.target.value})} className="w-full p-2.5 rounded-lg border border-outline-variant focus:border-primary outline-none" />
                  </div>
                  <div className="space-y-1.5 col-span-2 sm:col-span-1">
                    <label className="text-label-sm font-bold text-on-surface-variant">Pressure (PSI)</label>
                    <input type="number" value={checklistData.pressure} onChange={(e) => setChecklistData({...checklistData, pressure: e.target.value})} className="w-full p-2.5 rounded-lg border border-outline-variant focus:border-primary outline-none" />
                  </div>
                </div>
              </div>

              {/* Section 2: Maintenance Actions */}
              <div>
                <h3 className="text-label-lg font-bold text-on-surface mb-4 uppercase tracking-widest border-b border-surface-container-highest pb-2">2. Preventive Maintenance</h3>
                <div className="space-y-3">
                  {[
                    { id: 'spunFilter', label: 'Spun Filter Replaced' },
                    { id: 'mediumFilter', label: 'Medium Filter Replaced' },
                    { id: 'woundFilter', label: 'Wound Filter Replaced' },
                    { id: 'antiscalant', label: 'Antiscalant Dispatched' },
                    { id: 'softener', label: 'Softener Regenerated' },
                  ].map(item => (
                    <label key={item.id} className="flex items-center gap-3 p-3 rounded-xl border border-outline-variant/50 hover:bg-surface-container-lowest cursor-pointer transition-colors">
                      <input 
                        type="checkbox" 
                        checked={checklistData[item.id as keyof typeof checklistData] as boolean}
                        onChange={(e) => setChecklistData({...checklistData, [item.id]: e.target.checked})}
                        className="w-5 h-5 rounded border-outline-variant text-primary focus:ring-primary"
                      />
                      <span className="text-body-md font-bold text-on-surface">{item.label}</span>
                    </label>
                  ))}
                </div>
              </div>
            </div>

            <div className="flex gap-3 mt-8 pt-4 border-t border-surface-container-highest">
              <button onClick={() => setShowChecklistModal(false)} className="flex-1 py-3 font-bold text-slate-600 bg-slate-100 hover:bg-slate-200 rounded-xl transition-colors">Cancel</button>
              <button 
                onClick={() => {
                  const newReport = {
                    taskId: checklistTaskId,
                    staffId: 's1',
                    timestamp: new Date().getTime(),
                    data: checklistData
                  };
                  const updatedReports = [newReport, ...serviceReports.filter(r => r.taskId !== checklistTaskId)];
                  setServiceReports(updatedReports);
                  localStorage.setItem('service_reports', JSON.stringify(updatedReports));
                  
                  alert('Service Checklist saved securely!');
                  setShowChecklistModal(false);
                }}
                className="flex-1 py-3 px-2 font-bold text-white bg-primary rounded-xl hover:bg-primary/90 transition-colors shadow-md"
              >
                Save Report
              </button>
            </div>
          </div>
        </div>
      )}

    </div>
  );
};

export default StaffDashboard;
