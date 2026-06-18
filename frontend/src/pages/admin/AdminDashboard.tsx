import React from 'react';
import { Activity, Users, AlertTriangle, IndianRupee, MoreVertical, CheckCircle, Clock, Download, ExternalLink } from 'lucide-react';
import customersData from '../../mockData/customers.json';
import inventoryData from '../../mockData/inventory.json';
import tasksData from '../../mockData/tasks.json';

const AdminDashboard: React.FC = () => {
  const totalCustomers = customersData.length;
  const lowStockItems = inventoryData.filter(item => item.stock <= item.minStockAlert).length;
  const openComplaints = tasksData.filter(task => task.type === 'Complaint' && task.status === 'Open').length;

  const stats = [
    { title: 'Total Customers', value: totalCustomers.toString(), icon: Users, color: 'text-blue-600', bg: 'bg-blue-100/50', border: 'border-blue-200/50', glow: 'shadow-blue-500/20' },
    { title: 'Open Complaints', value: openComplaints.toString(), icon: Activity, color: 'text-amber-600', bg: 'bg-amber-100/50', border: 'border-amber-200/50', glow: 'shadow-amber-500/20' },
    { title: 'Low Stock Alerts', value: lowStockItems.toString(), icon: AlertTriangle, color: 'text-red-600', bg: 'bg-red-100/50', border: 'border-red-200/50', glow: 'shadow-red-500/20' },
    { title: "Today's Revenue", value: '₹ 15,400', icon: IndianRupee, color: 'text-primary-600', bg: 'bg-primary-100/50', border: 'border-primary-200/50', glow: 'shadow-primary-500/20' },
  ];

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-white p-6 rounded-2xl shadow-[0_2px_10px_-3px_rgba(6,81,237,0.1)] border border-slate-100 relative overflow-hidden">
        {/* Subtle background element */}
        <div className="absolute top-0 right-0 w-64 h-full bg-gradient-to-l from-primary-50/50 to-transparent pointer-events-none"></div>
        
        <div className="relative z-10">
          <h1 className="text-2xl font-extrabold text-slate-800 tracking-tight">Executive Dashboard</h1>
          <p className="text-slate-500 text-sm mt-1 font-medium">Real-time overview of operations and critical metrics.</p>
        </div>
        <div className="flex gap-3 relative z-10">
          <button className="flex items-center gap-2 px-5 py-2.5 bg-white border border-slate-200 text-slate-600 rounded-xl text-sm font-semibold hover:bg-slate-50 hover:border-slate-300 transition-all shadow-sm">
            <Download className="w-4 h-4" />
            Export
          </button>
          <button className="flex items-center gap-2 px-5 py-2.5 bg-gradient-to-r from-primary-500 to-primary-600 text-white rounded-xl text-sm font-bold hover:from-primary-600 hover:to-primary-700 transition-all shadow-[0_8px_16px_-6px_rgba(0,135,62,0.4)] hover:shadow-[0_8px_20px_-6px_rgba(0,135,62,0.6)] transform hover:-translate-y-0.5">
            <ExternalLink className="w-4 h-4" />
            Generate Report
          </button>
        </div>
      </div>

      {/* Premium KPI Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        {stats.map((stat) => {
          const Icon = stat.icon;
          return (
            <div key={stat.title} className="bg-white p-6 rounded-2xl border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.03)] hover:shadow-[0_8px_30px_-4px_rgba(0,0,0,0.06)] flex items-center gap-5 transition-all duration-300 group cursor-default">
              <div className={`p-3.5 rounded-xl ${stat.bg} ${stat.border} border shadow-lg ${stat.glow} transition-transform duration-300 group-hover:scale-110 group-hover:rotate-3`}>
                <Icon className={`w-6 h-6 ${stat.color}`} />
              </div>
              <div>
                <p className="text-xs font-bold text-slate-400 uppercase tracking-widest mb-1">{stat.title}</p>
                <p className="text-3xl font-extrabold text-slate-800 tracking-tight">{stat.value}</p>
              </div>
            </div>
          );
        })}
      </div>

      {/* Data Tables Area */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        {/* Recent Service Tasks */}
        <div className="lg:col-span-2 bg-white rounded-2xl border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.03)] flex flex-col overflow-hidden">
          <div className="px-6 py-5 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
            <h2 className="text-lg font-bold text-slate-800">Recent Service Tasks</h2>
            <button className="text-primary-600 hover:text-primary-700 text-sm font-semibold bg-primary-50 px-3 py-1 rounded-lg transition-colors">View All</button>
          </div>
          
          <div className="overflow-x-auto">
            <table className="w-full text-sm text-left">
              <thead className="text-xs text-slate-400 bg-white border-b border-slate-100 uppercase tracking-wider">
                <tr>
                  <th className="px-6 py-4 font-bold">Task ID</th>
                  <th className="px-6 py-4 font-bold">Customer</th>
                  <th className="px-6 py-4 font-bold">Type</th>
                  <th className="px-6 py-4 font-bold">Status</th>
                  <th className="px-6 py-4 font-bold text-right">Action</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-50">
                {tasksData.slice(0, 5).map((task) => (
                  <tr key={task.id} className="hover:bg-slate-50/80 transition-colors group">
                    <td className="px-6 py-4 font-bold text-slate-700">{task.id}</td>
                    <td className="px-6 py-4 text-slate-600 font-medium">{customersData.find(c => c.id === task.customerId)?.name || task.customerId}</td>
                    <td className="px-6 py-4">
                      <span className={`inline-flex items-center px-2.5 py-1 rounded-md text-xs font-bold shadow-sm ${
                        task.type === 'Complaint' ? 'bg-gradient-to-r from-amber-50 to-amber-100 text-amber-700 border border-amber-200/60' : 'bg-gradient-to-r from-primary-50 to-primary-100 text-primary-700 border border-primary-200/60'
                      }`}>
                        {task.type}
                      </span>
                    </td>
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-2">
                        {task.status === 'Completed' ? (
                          <CheckCircle className="w-4 h-4 text-emerald-500" />
                        ) : (
                          <Clock className="w-4 h-4 text-amber-500" />
                        )}
                        <span className="text-slate-600 text-xs font-bold">{task.status}</span>
                      </div>
                    </td>
                    <td className="px-6 py-4 text-right">
                      <button className="text-slate-400 hover:text-primary-600 p-1.5 rounded-md hover:bg-primary-50 transition-colors opacity-0 group-hover:opacity-100">
                        <MoreVertical className="w-4 h-4" />
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* Low Stock Alerts */}
        <div className="bg-white rounded-2xl border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.03)] flex flex-col overflow-hidden relative">
          {/* subtle red glow for alerts */}
          <div className="absolute top-0 right-0 w-32 h-32 bg-red-500/5 blur-[50px] pointer-events-none"></div>

          <div className="px-6 py-5 border-b border-slate-100 flex justify-between items-center bg-slate-50/50 relative z-10">
            <h2 className="text-lg font-bold text-slate-800">Inventory Alerts</h2>
            <span className="bg-gradient-to-r from-red-500 to-red-600 text-white text-xs font-bold px-2.5 py-1 rounded-lg shadow-sm">{lowStockItems} Items</span>
          </div>
          
          <div className="p-0 overflow-y-auto max-h-[400px] relative z-10">
            <ul className="divide-y divide-slate-50">
              {inventoryData.filter(i => i.stock <= i.minStockAlert).map(item => (
                <li key={item.id} className="p-6 flex justify-between items-center hover:bg-red-50/30 transition-colors group">
                  <div>
                    <p className="text-sm font-bold text-slate-800 group-hover:text-red-700 transition-colors">{item.name}</p>
                    <p className="text-xs font-medium text-slate-400 mt-1 uppercase tracking-wider">ID: {item.id}</p>
                  </div>
                  <div className="text-right bg-white px-4 py-2 rounded-xl shadow-sm border border-slate-100 group-hover:border-red-200 transition-colors">
                    <p className="text-xl font-extrabold text-red-600 leading-none">{item.stock}</p>
                    <p className="text-[9px] text-slate-400 font-bold uppercase mt-1">Stock Left</p>
                  </div>
                </li>
              ))}
            </ul>
          </div>
        </div>

      </div>
    </div>
  );
};

export default AdminDashboard;
