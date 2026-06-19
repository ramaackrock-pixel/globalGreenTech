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
    { title: 'Total Customers', value: totalCustomers.toString(), icon: Users, color: 'text-secondary', bg: 'bg-secondary-container/50', border: 'border-secondary-container', glow: 'shadow-secondary/20' },
    { title: 'Open Complaints', value: openComplaints.toString(), icon: Activity, color: 'text-tertiary', bg: 'bg-tertiary-container/50', border: 'border-tertiary-container', glow: 'shadow-tertiary/20' },
    { title: 'Low Stock Alerts', value: lowStockItems.toString(), icon: AlertTriangle, color: 'text-error', bg: 'bg-error-container/50', border: 'border-error-container', glow: 'shadow-error/20' },
    { title: "Today's Revenue", value: '₹ 15,400', icon: IndianRupee, color: 'text-primary', bg: 'bg-primary-container/50', border: 'border-primary-container', glow: 'shadow-primary/20' },
  ];

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 card p-6 relative overflow-hidden">
        {/* Subtle background element */}
        <div className="absolute top-0 right-0 w-64 h-full bg-gradient-to-l from-primary-container/50 to-transparent pointer-events-none"></div>
        
        <div className="relative z-10">
          <h1 className="text-headline-lg text-on-surface">Executive Dashboard</h1>
          <p className="text-body-md text-on-surface-variant mt-1">Real-time overview of operations and critical metrics.</p>
        </div>
        <div className="flex gap-3 relative z-10">
          <button className="flex items-center gap-2 px-5 py-2.5 bg-surface-container-lowest border border-outline-variant text-on-surface-variant rounded-xl text-label-lg hover:bg-surface-container hover:text-on-surface transition-all shadow-sm">
            <Download className="w-4 h-4" />
            Export
          </button>
          <button className="btn-primary flex items-center gap-2 px-5 py-2.5">
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
            <div key={stat.title} className="card p-6 flex items-center gap-5 transition-all duration-300 group cursor-default">
              <div className={`p-3.5 rounded-xl ${stat.bg} ${stat.border} border shadow-lg ${stat.glow} transition-transform duration-300 group-hover:scale-110 group-hover:rotate-3`}>
                <Icon className={`w-6 h-6 ${stat.color}`} />
              </div>
              <div>
                <p className="text-label-md text-on-surface-variant uppercase mb-1">{stat.title}</p>
                <p className="text-display-sm text-on-surface">{stat.value}</p>
              </div>
            </div>
          );
        })}
      </div>

      {/* Data Tables Area */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        {/* Recent Service Tasks */}
        <div className="lg:col-span-2 card flex flex-col overflow-hidden !p-0">
          <div className="px-6 py-5 border-b border-surface-container-highest flex justify-between items-center bg-surface-container-lowest">
            <h2 className="text-title-lg text-on-surface">Recent Service Tasks</h2>
            <button className="text-primary hover:text-primary-container text-label-md bg-primary-fixed px-3 py-1 rounded-lg transition-colors">View All</button>
          </div>
          
          <div className="overflow-x-auto">
            <table className="w-full text-left">
              <thead className="text-label-md text-on-surface-variant bg-surface-container-lowest border-b border-surface-container-highest uppercase">
                <tr>
                  <th className="px-6 py-4">Task ID</th>
                  <th className="px-6 py-4">Customer</th>
                  <th className="px-6 py-4">Type</th>
                  <th className="px-6 py-4">Status</th>
                  <th className="px-6 py-4 text-right">Action</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-surface-container-highest">
                {tasksData.slice(0, 5).map((task) => (
                  <tr key={task.id} className="hover:bg-surface-container/50 transition-colors group">
                    <td className="px-6 py-4 font-bold text-on-surface">{task.id}</td>
                    <td className="px-6 py-4 text-on-surface-variant font-medium">{customersData.find(c => c.id === task.customerId)?.name || task.customerId}</td>
                    <td className="px-6 py-4">
                      <span className={`badge-${task.type === 'Complaint' ? 'expired' : 'active'}`}>
                        {task.type}
                      </span>
                    </td>
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-2">
                        {task.status === 'Completed' ? (
                          <CheckCircle className="w-4 h-4 text-primary" />
                        ) : (
                          <Clock className="w-4 h-4 text-secondary" />
                        )}
                        <span className="text-on-surface-variant text-label-md">{task.status}</span>
                      </div>
                    </td>
                    <td className="px-6 py-4 text-right">
                      <button className="text-outline hover:text-primary p-1.5 rounded-md hover:bg-primary-fixed transition-colors opacity-0 group-hover:opacity-100">
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
        <div className="card flex flex-col overflow-hidden relative !p-0">
          {/* subtle red glow for alerts */}
          <div className="absolute top-0 right-0 w-32 h-32 bg-error/10 blur-[50px] pointer-events-none"></div>

          <div className="px-6 py-5 border-b border-surface-container-highest flex justify-between items-center bg-surface-container-lowest relative z-10">
            <h2 className="text-title-lg text-on-surface">Inventory Alerts</h2>
            <span className="bg-error text-on-error text-label-md px-2.5 py-1 rounded-lg shadow-sm">{lowStockItems} Items</span>
          </div>
          
          <div className="p-0 overflow-y-auto max-h-[400px] relative z-10">
            <ul className="divide-y divide-surface-container-highest">
              {inventoryData.filter(i => i.stock <= i.minStockAlert).map(item => (
                <li key={item.id} className="p-6 flex justify-between items-center hover:bg-error-container/30 transition-colors group">
                  <div>
                    <p className="text-body-md font-bold text-on-surface group-hover:text-error transition-colors">{item.name}</p>
                    <p className="text-label-md text-on-surface-variant mt-1 uppercase">ID: {item.id}</p>
                  </div>
                  <div className="text-right bg-surface-container-lowest px-4 py-2 rounded-xl shadow-sm border border-outline-variant group-hover:border-error transition-colors">
                    <p className="text-headline-md text-error leading-none">{item.stock}</p>
                    <p className="text-label-sm text-on-surface-variant uppercase mt-1">Stock Left</p>
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
