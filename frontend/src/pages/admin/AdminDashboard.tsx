import React from 'react';
import { Activity, Users, AlertTriangle, IndianRupee, MoreVertical, CheckCircle, Clock, Download, ExternalLink, TrendingUp, CalendarDays } from 'lucide-react';
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
      {/* Minimal Aesthetic Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-6 pb-2">
        <div>
          <h1 className="text-3xl font-bold tracking-tight text-on-surface">Dashboard</h1>
          <p className="text-on-surface-variant text-sm font-medium mt-1">Welcome back, here is what's happening today.</p>
        </div>
        <div className="flex gap-3">
          {/* Kept existing buttons but removed borders/shadows to match clean aesthetic */}
          <button className="btn-ghost text-on-surface-variant hover:text-on-surface px-4 py-2">
            <Download className="w-4 h-4" />
            Export Data
          </button>
          <button className="btn-primary px-5 py-2.5 shadow-none rounded-lg">
            <ExternalLink className="w-4 h-4" />
            Generate Report
          </button>
        </div>
      </div>

      {/* Minimal KPI Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        {stats.map((stat) => {
          const Icon = stat.icon;
          return (
            <div key={stat.title} className="card p-6 flex flex-col justify-start h-40 cursor-default hover:-translate-y-1 hover:shadow-md hover:border-primary/30 transition-all duration-300">
              <div className={`w-11 h-11 rounded-xl flex items-center justify-center ${stat.bg} ${stat.color} mb-6 border border-outline-variant/10`}>
                <Icon className="w-5 h-5" />
              </div>
              <div className="flex flex-col gap-1.5">
                <p className="text-[11px] font-bold text-on-surface-variant uppercase tracking-wider">{stat.title}</p>
                <p className="text-3xl font-bold text-on-surface tracking-tight">{stat.value}</p>
              </div>
            </div>
          );
        })}
      </div>

      {/* Data Tables Area */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        {/* Recent Service Tasks */}
        <div className="lg:col-span-2 card flex flex-col overflow-hidden !p-0 hover:-translate-y-1 hover:shadow-md hover:border-primary/30 transition-all duration-300">
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
        <div className="card flex flex-col overflow-hidden relative !p-0 hover:-translate-y-1 hover:shadow-md hover:border-primary/30 transition-all duration-300">
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

      {/* Financial & Forecasting Reports */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        
        {/* Profitability Report (Req 12) */}
        <div className="card flex flex-col relative overflow-hidden hover:-translate-y-1 hover:shadow-md hover:border-primary/30 transition-all duration-300">
          <div className="absolute top-0 right-0 w-32 h-32 bg-primary/10 blur-[50px] pointer-events-none"></div>
          <div className="flex justify-between items-start mb-6">
            <div>
              <h2 className="text-title-lg text-on-surface flex items-center gap-2">
                <TrendingUp className="w-5 h-5 text-primary" />
                Profitability Report
              </h2>
              <p className="text-body-sm text-on-surface-variant mt-1">Monthly Revenue vs. Costs Overview</p>
            </div>
            <div className="select-wrapper py-1 px-2">
              <select className="bg-transparent text-label-md font-bold text-on-surface outline-none appearance-none cursor-pointer pr-4">
                <option>This Month</option>
                <option>Last Month</option>
                <option>Year to Date</option>
              </select>
            </div>
          </div>

          <div className="flex-1 flex flex-col justify-between space-y-4">
            <div className="flex gap-4">
              <div className="flex-1 bg-surface-container-lowest p-4 rounded-xl border border-outline-variant/40 shadow-sm">
                <p className="text-label-sm text-on-surface-variant uppercase">Total Revenue</p>
                <p className="text-title-lg font-bold text-primary mt-1">₹ 4,25,000</p>
              </div>
              <div className="flex-1 bg-surface-container-lowest p-4 rounded-xl border border-outline-variant/40 shadow-sm">
                <p className="text-label-sm text-on-surface-variant uppercase">Total Costs</p>
                <p className="text-title-lg font-bold text-error mt-1">₹ 1,85,500</p>
              </div>
            </div>

            {/* CSS Bar Chart */}
            <div className="flex-1 bg-surface-container p-4 rounded-xl border border-outline-variant/30 flex flex-col">
              <div className="flex justify-between text-label-sm font-bold text-on-surface-variant mb-4 uppercase tracking-wider">
                <span>Revenue vs Costs (6 Mo)</span>
                <div className="flex gap-3">
                  <div className="flex items-center gap-1.5"><div className="w-2 h-2 rounded-full bg-primary"></div> Revenue</div>
                  <div className="flex items-center gap-1.5"><div className="w-2 h-2 rounded-full bg-error"></div> Costs</div>
                </div>
              </div>
              <div className="flex-1 flex items-end gap-3 min-h-[120px] w-full">
                {[
                  { month: 'Jan', rev: 50, cost: 30 },
                  { month: 'Feb', rev: 65, cost: 35 },
                  { month: 'Mar', rev: 60, cost: 40 },
                  { month: 'Apr', rev: 80, cost: 45 },
                  { month: 'May', rev: 75, cost: 50 },
                  { month: 'Jun', rev: 100, cost: 45 }
                ].map((data, idx) => (
                  <div key={idx} className="flex-1 flex flex-col justify-end h-full relative group">
                    <div className="w-full flex gap-1 items-end justify-center h-full">
                      <div className="w-full bg-primary rounded-t-md hover:brightness-110 transition-all cursor-pointer" style={{ height: `${data.rev}%` }}></div>
                      <div className="w-full bg-error rounded-t-md hover:brightness-110 transition-all cursor-pointer" style={{ height: `${data.cost}%` }}></div>
                    </div>
                    <span className="text-[10px] font-bold text-on-surface-variant text-center mt-2 uppercase">{data.month}</span>
                  </div>
                ))}
              </div>
            </div>

            <div className="bg-primary-container px-5 py-3.5 rounded-xl border border-primary/20 flex justify-between items-center">
              <div>
                <p className="text-label-sm text-on-primary-container font-bold uppercase tracking-widest">Net Profit Margin</p>
                <p className="text-title-lg font-black text-on-surface mt-0.5">₹ 2,39,500</p>
              </div>
              <div className="bg-surface-container-lowest px-3 py-1 rounded-lg border border-outline-variant/30 text-primary font-bold shadow-sm text-sm">
                +56.3%
              </div>
            </div>
          </div>
        </div>

        {/* AMC Renewal Forecast (Req 11) */}
        <div className="card flex flex-col relative overflow-hidden p-6 hover:-translate-y-1 hover:shadow-md hover:border-primary/30 transition-all duration-300">
          <div className="flex justify-between items-start mb-6 relative z-10">
            <div>
              <h2 className="text-title-lg text-on-surface flex items-center gap-2">
                <CalendarDays className="w-5 h-5 text-secondary" />
                AMC Renewal Forecast
              </h2>
              <p className="text-body-sm text-on-surface-variant mt-1">Upcoming renewals for the next 30 days</p>
            </div>
            <button className="text-primary hover:text-primary-container text-label-md bg-primary-fixed px-3 py-1 rounded-lg transition-colors">
              Send Reminders
            </button>
          </div>

          <div className="flex-1 flex flex-col justify-between space-y-4">
            <div className="flex gap-4">
              <div className="flex-1 bg-surface-container-lowest p-4 rounded-xl border border-outline-variant/40 shadow-sm">
                <p className="text-label-sm text-on-surface-variant uppercase">Accounts Renewing</p>
                <p className="text-title-lg font-bold text-on-surface mt-1">42</p>
              </div>
              <div className="flex-1 bg-surface-container-lowest p-4 rounded-xl border border-outline-variant/40 shadow-sm">
                <p className="text-label-sm text-on-surface-variant uppercase">Projected Value</p>
                <p className="text-title-lg font-bold text-secondary mt-1">₹ 84,000</p>
              </div>
            </div>

            <div className="flex-1 bg-surface-container p-4 rounded-xl border border-outline-variant/30 flex flex-col justify-center">
              <p className="text-label-sm font-bold text-on-surface-variant mb-4 uppercase tracking-wider">High Value Renewals Pipeline</p>
              <div className="space-y-2.5 flex-1 flex flex-col justify-center">
                <div className="flex justify-between items-center bg-surface-container-lowest px-3 py-2.5 rounded-lg border border-outline-variant/30 shadow-sm hover:border-secondary/30 transition-colors cursor-pointer">
                  <div>
                    <p className="text-label-md font-bold text-on-surface">TechCorp Industries</p>
                    <p className="text-[10px] text-on-surface-variant font-medium mt-0.5 uppercase tracking-wider">Expires in 5 days</p>
                  </div>
                  <span className="text-label-md font-black text-secondary">₹ 15,000</span>
                </div>
                <div className="flex justify-between items-center bg-surface-container-lowest px-3 py-2.5 rounded-lg border border-outline-variant/30 shadow-sm hover:border-secondary/30 transition-colors cursor-pointer">
                  <div>
                    <p className="text-label-md font-bold text-on-surface">Global Retailers Ltd</p>
                    <p className="text-[10px] text-on-surface-variant font-medium mt-0.5 uppercase tracking-wider">Expires in 12 days</p>
                  </div>
                  <span className="text-label-md font-black text-secondary">₹ 12,500</span>
                </div>
                <div className="flex justify-between items-center bg-surface-container-lowest px-3 py-2.5 rounded-lg border border-outline-variant/30 shadow-sm hover:border-secondary/30 transition-colors cursor-pointer">
                  <div>
                    <p className="text-label-md font-bold text-on-surface">Apex Manufacturing</p>
                    <p className="text-[10px] text-on-surface-variant font-medium mt-0.5 uppercase tracking-wider">Expires in 18 days</p>
                  </div>
                  <span className="text-label-md font-black text-secondary">₹ 10,000</span>
                </div>
              </div>
            </div>

            <div className="bg-secondary-container px-5 py-3.5 rounded-xl border border-secondary/20 flex justify-between items-center cursor-pointer hover:bg-secondary/20 transition-colors">
              <div>
                <p className="text-label-sm text-on-secondary-container font-bold uppercase tracking-widest">Action Required</p>
                <p className="text-title-lg font-black text-on-surface mt-0.5">12 Overdue</p>
              </div>
              <div className="bg-surface-container-lowest px-3 py-1 rounded-lg border border-outline-variant text-secondary font-bold shadow-sm text-sm flex items-center gap-2">
                Send All
                <CalendarDays className="w-4 h-4" />
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
};

export default AdminDashboard;
