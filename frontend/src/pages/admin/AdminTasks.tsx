import React, { useState } from 'react';
import { Filter, MoreVertical, PenTool, CheckCircle2, Clock, CalendarDays, Plus, CalendarClock, MessageCircle, FileCheck } from 'lucide-react';
import tasksData from '../../mockData/tasks.json';
import customersData from '../../mockData/customers.json';
import { useSearch } from '../../context/SearchContextProvider';
import staffData from '../../mockData/staff.json'

const AdminTasks: React.FC = () => {
  const { searchQuery } = useSearch();

  // Local filter states
  const [statusFilter, setStatusFilter] = useState('All');
  const [typeFilter, setTypeFilter] = useState('All');
  const [showModel, setshowModel] = useState(false);

  // ADD Task
  const [customerId, setCustomerId] = useState('');
  const [taskDate, setTaskDate] = useState('');
  const [taskType, setTaskType] = useState('AMC');
  const [assignTo, setAssignTo] = useState('');
  const [initialStatus, setInitialStatus] = useState('Open')
  const [description, setDescription] = useState('')

  const [tasks, setTasks] = useState(tasksData);

  const filteredTasks = tasks.filter((task) => {
    const filteredTypes = typeFilter === 'All' || task.type === typeFilter;

    const filteredStatus = statusFilter == 'All' || task.status === statusFilter;

    const searchResults = (searchQuery.trim() === '' || task.id.includes(searchQuery))

    return filteredTypes && filteredStatus && searchResults;
  })

  function handleAddAdminTasks(e: React.FormEvent, customerName?: string) {
    e.preventDefault();

    const id = `T${tasks.length + 1}`;

    const fetchedAssignedto = staffData.find((staff) => staff.name === assignTo)?.id || assignTo;
    const cid = customersData.find((customer) => customer.id === customerId)?.id || customerId
    
    console.log('cid',cid)

    const newTask = {
      id,
      customerId: cid,
      type: taskType,
      status: initialStatus,
      assignedTo: fetchedAssignedto,
      date: taskDate,
      description: description,
    }

    console.log(newTask)

    setTasks(prev => [...prev, newTask])

    setCustomerId('')
    setTaskDate('')
    setTaskType('')
    setAssignTo('')
    setInitialStatus('')
    setDescription('')

    setshowModel(false)

  }





  return (
    <div className="space-y-8 pb-20 md:pb-0">

      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-white p-6 rounded-2xl shadow-[0_2px_10px_-3px_rgba(6,81,237,0.1)] border border-slate-100 relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-full bg-gradient-to-l from-primary-50/50 to-transparent pointer-events-none"></div>

        <div className="relative z-10">
          <h1 className="text-2xl font-extrabold text-slate-800 tracking-tight">Service Tasks & AMC</h1>
          <p className="text-slate-500 text-sm mt-1 font-medium">Assign, track, and manage all field service operations.</p>
        </div>

        <button
          onClick={() => setshowModel(true)}
          className="relative z-10 flex-1 sm:flex-none flex items-center justify-center gap-2 px-5 py-2.5 bg-gradient-to-r from-slate-900 to-slate-800 hover:from-slate-800 hover:to-slate-700 text-white rounded-xl font-bold shadow-md hover:shadow-lg transition-all"
        >
          <Plus className="w-4 h-4" />
          Create Task
        </button>
      </div>

      {/* Main Content Box */}
      <div className="bg-white rounded-2xl shadow-[0_4px_20px_-4px_rgba(0,0,0,0.03)] border border-slate-100 overflow-hidden">

        {/* Toolbar (Filters) */}
        <div className="p-6 border-b border-slate-100 bg-slate-50/50 flex flex-col lg:flex-row gap-4 justify-end items-center">
          <div className="flex gap-3 w-full lg:w-auto">

            <div className="flex items-center gap-2 bg-white px-3 py-1.5 rounded-xl border border-slate-300 shadow-sm w-full sm:w-auto">
              <Filter className="w-4 h-4 text-slate-400" />
              <select
                className="bg-transparent text-sm font-bold text-slate-700 outline-none appearance-none cursor-pointer w-full pl-1 pr-6 py-1"
                value={typeFilter}
                onChange={(e) => setTypeFilter(e.target.value)}
              >
                <option value="All">All Types</option>
                <option value="AMC">AMC Visit</option>
                <option value="Complaint">Complaint</option>
                <option value="Installation">Installation</option>
              </select>
            </div>

            <div className="flex items-center gap-2 bg-white px-3 py-1.5 rounded-xl border border-slate-300 shadow-sm w-full sm:w-auto">
              <select
                className="bg-transparent text-sm font-bold text-slate-700 outline-none appearance-none cursor-pointer w-full pl-1 pr-6 py-1"
                value={statusFilter}
                onChange={(e) => setStatusFilter(e.target.value)}
              >
                <option value="All">Status: All</option>
                <option value="Open">Open</option>
                <option value="Scheduled">Scheduled</option>
                <option value="In Progress">In Progress</option>
                <option value="Completed">Completed</option>
              </select>
            </div>

          </div>
        </div>

        {/* Data Table */}
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse min-w-[900px]">
            <thead>
              <tr className="bg-slate-50/50 border-b border-slate-100">
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">Task Info</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">Customer</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">Type & Status</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">Schedule & Tech</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">

              {/* YOU WILL CHANGE THIS TO filteredTasks.map(...) */}
              {filteredTasks.map((task) => (
                <tr key={task.id} className="hover:bg-slate-50/80 transition-colors group">

                  <td className="px-6 py-4">
                    <div className="flex flex-col">
                      <span className="text-sm font-bold text-slate-800">#{task.id.toUpperCase()}</span>
                      <span className="text-xs text-slate-500 mt-1 line-clamp-1 max-w-[200px]" title={task.description}>
                        {task.description}
                      </span>
                    </div>
                  </td>

                  <td className="px-6 py-4">
                    <div className="flex flex-col">
                      <span className="text-sm font-bold text-slate-700">
                        {customersData.find(c => c.id === task.customerId)?.name || task.customerId}
                      </span>
                      <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider mt-1">
                        ID: {task.customerId}
                      </span>
                    </div>
                  </td>

                  <td className="px-6 py-4">
                    <div className="flex flex-col gap-2 items-start">
                      <span className={`inline-flex items-center gap-1.5 px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-wider border ${task.type === 'Complaint' ? 'bg-amber-50 text-amber-600 border-amber-100' :
                        task.type === 'Installation' ? 'bg-blue-50 text-blue-600 border-blue-100' :
                          'bg-purple-50 text-purple-600 border-purple-100'
                        }`}>
                        {task.type}
                      </span>

                      <span className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider border ${task.status === 'Completed' ? 'bg-emerald-50 text-emerald-600 border-emerald-100' :
                        task.status === 'In Progress' ? 'bg-blue-50 text-blue-600 border-blue-100' :
                          task.status === 'Scheduled' ? 'bg-slate-100 text-slate-600 border-slate-200' :
                            'bg-red-50 text-red-600 border-red-100'
                        }`}>
                        {task.status === 'Completed' && <CheckCircle2 className="w-3 h-3" />}
                        {task.status === 'In Progress' && <PenTool className="w-3 h-3" />}
                        {(task.status === 'Open' || task.status === 'Scheduled') && <Clock className="w-3 h-3" />}
                        {task.status}
                      </span>
                    </div>
                  </td>

                  <td className="px-6 py-4">
                    <div className="flex flex-col gap-1.5">
                      <div className="flex items-center gap-1.5 text-xs font-bold text-slate-600">
                        <CalendarDays className="w-3.5 h-3.5 text-slate-400" />
                        {new Date(task.date).toLocaleDateString('en-GB')}
                      </div>
                      <span className="text-[10px] font-bold text-primary-600 bg-primary-50 w-fit px-2 py-0.5 rounded uppercase tracking-wider">
                        Tech: {task.assignedTo}
                      </span>
                    </div>
                  </td>

                  <td className="px-6 py-4 text-right">
                    <div className="flex justify-end gap-2">
                      {task.type === 'AMC' && task.status === 'Open' && (
                        <button className="p-2 text-primary hover:text-primary-container hover:bg-primary-fixed rounded-lg transition-colors" title="Auto Schedule via WhatsApp">
                          <MessageCircle className="w-5 h-5" />
                        </button>
                      )}
                      {task.status === 'Completed' && (
                        <button className="p-2 text-secondary hover:text-secondary-container hover:bg-secondary-fixed rounded-lg transition-colors" title="Generate Commissioning Report">
                          <FileCheck className="w-5 h-5" />
                        </button>
                      )}
                      <button className="p-2 text-slate-400 hover:text-primary-600 hover:bg-primary-50 rounded-lg transition-colors">
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

      {/* Create Task Modal (UI Only) */}
      {showModel && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" onClick={() => setshowModel(false)}></div>
          <div className="bg-white rounded-3xl shadow-2xl w-full max-w-lg relative z-10 overflow-hidden animate-in fade-in zoom-in-95 duration-200">
            <div className="p-6 border-b border-slate-100 bg-slate-50/50 flex items-center gap-3">
              <div className="w-10 h-10 bg-white rounded-xl shadow-sm border border-slate-100 flex items-center justify-center">
                <CalendarClock className="w-5 h-5 text-primary-600" />
              </div>
              <div>
                <h2 className="text-lg font-extrabold text-slate-800">Assign New Task</h2>
                <p className="text-xs font-medium text-slate-500">Schedule a new service call or installation.</p>
              </div>
            </div>

            <form className="p-6 space-y-5" onSubmit={handleAddAdminTasks}>
              <div className="space-y-1.5">
                <label className="text-xs font-bold text-slate-700 uppercase tracking-wide">Customer</label>
                <select className="w-full px-4 py-3 rounded-xl border border-slate-300 bg-white shadow-sm focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 outline-none transition-all font-medium text-slate-800 appearance-none cursor-pointer" value={customerId} onChange={(e)=>setCustomerId(e.target.value)}>
                  <option value="">Select a customer...</option>
                  {customersData.map(c => (
                    <option key={c.id} value={c.id}>{c.name} ({c.id})</option>
                  ))}
                </select>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-bold text-slate-700 uppercase tracking-wide">Task Type</label>
                  <select className="w-full px-4 py-3 rounded-xl border border-slate-300 bg-white shadow-sm focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 outline-none transition-all font-bold text-slate-800 appearance-none cursor-pointer" value={taskType} onChange={(e) => setTaskType(e.target.value)}>
                    <option value="AMC">AMC</option>
                    <option value="Complaint">Complaint</option>
                    <option value="Installation">Installation</option>
                  </select>
                </div>
                <div className="space-y-1.5">
                  <label className="text-xs font-bold text-slate-700 uppercase tracking-wide">Schedule Date</label>
                  <input
                    type="date"
                    className="w-full px-4 py-3 rounded-xl border border-slate-300 bg-white shadow-sm focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 outline-none transition-all font-medium text-slate-800"
                    value={taskDate}
                    onChange={(e) => setTaskDate(e.target.value)}
                  />

                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-bold text-slate-700 uppercase tracking-wide">Assign To Tech</label>
                  <select className="w-full px-4 py-3 rounded-xl border border-slate-300 bg-white shadow-sm focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 outline-none transition-all font-medium text-slate-800 appearance-none cursor-pointer" value={assignTo} onChange={(e) => setAssignTo(e.target.value)}>
                    <option value="">Select Technician...</option>
                    <option value="s1">Rahul Kumar (s1)</option>
                    <option value="s2">Amit Singh (s2)</option>
                  </select>
                </div>
                <div className="space-y-1.5">
                  <label className="text-xs font-bold text-slate-700 uppercase tracking-wide">Initial Status</label>
                  <select className="w-full px-4 py-3 rounded-xl border border-slate-300 bg-white shadow-sm focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 outline-none transition-all font-medium text-slate-800 appearance-none cursor-pointer" value={initialStatus} onChange={(e) => setInitialStatus(e.target.value)}>
                    <option value="Open">Open</option>
                    <option value="Scheduled">Scheduled</option>
                  </select>
                </div>
              </div>

              <div className="space-y-1.5">
                <label className="text-xs font-bold text-slate-700 uppercase tracking-wide">Problem / Description</label>
                <textarea
                  rows={3}
                  placeholder="E.g., Customer reported low water pressure..."
                  className="w-full px-4 py-3 rounded-xl border border-slate-300 bg-white shadow-sm focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 outline-none transition-all font-medium text-slate-800 resize-none"
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                ></textarea>
              </div>

              <div className="pt-4 flex gap-3">
                <button
                  type="button"
                  onClick={() => setshowModel(false)}
                  className="flex-1 px-4 py-3 rounded-xl font-bold text-slate-600 bg-slate-100 hover:bg-slate-200 transition-colors"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="flex-1 px-4 py-3 rounded-xl font-bold text-white bg-gradient-to-r from-[#00873E] to-[#006b31] shadow-[0_4px_12px_-2px_rgba(0,135,62,0.4)] hover:shadow-[0_8px_16px_-4px_rgba(0,135,62,0.5)] transition-all"
                >
                  Add Task
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default AdminTasks;

/*
====================================================================
TASKS FOR USER TO COMPLETE:
====================================================================

1. FILTER LOGIC:
   - Create a `filteredTasks` array using `tasksData.filter()`.
   - Check if the task matches `typeFilter` (or if filter is 'All').
   - Check if the task matches `statusFilter` (or if filter is 'All').
   - Check if the task matches `searchQuery` from your Context!
     (Hint: you might want to search against `task.id`, `task.description`, or lookup the customer name and search against that).

2. RENDERING:
   - Update `{tasksData.map((task) => (` inside the `<tbody>` to use your new `{filteredTasks.map((task) => (` array!

3. CREATE TASK MODAL (Optional):
   - Add a `showModel` state.
   - Attach it to the "Create Task" button in the header.
   - Build out a form to insert a new task into the array.

====================================================================
*/
