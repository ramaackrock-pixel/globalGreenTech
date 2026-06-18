import React from 'react';
import { Outlet, Link, useLocation } from 'react-router-dom';
import {
  LayoutDashboard,
  Users,
  Settings,
  Package,
  CalendarClock,
  LogOut,
  Bell,
  Search,
  Menu,
  ShieldCheck
} from 'lucide-react';

const AdminLayout: React.FC = () => {
  const location = useLocation();

  const navigation = [
    { name: 'Dashboard', href: '/admin', icon: LayoutDashboard },
    { name: 'User Accounts', href: '/admin/users', icon: ShieldCheck },
    { name: 'Customers & AMC', href: '/admin/customers', icon: Users },
    { name: 'Service Tasks', href: '/admin/amc', icon: CalendarClock },
    { name: 'Inventory', href: '/admin/inventory', icon: Package },
    { name: 'Settings', href: '/admin/settings', icon: Settings },
  ];

  return (
    <div className="flex h-screen bg-[#f8fafc] text-slate-800 font-sans text-sm selection:bg-primary-500/30 selection:text-primary-900">
      {/* Sidebar - iOS 26 Liquid Glass Theme */}
      <aside className="w-64 hidden md:flex flex-col relative overflow-hidden shadow-[8px_0_40px_rgba(0,135,62,0.08)] z-20 border-r border-white/40">
        {/* Liquid Orbs Layer (Behind the glass) */}
        <div className="absolute inset-0 z-0 overflow-hidden pointer-events-none">
          <div className="absolute -top-10 -left-10 w-64 h-64 bg-[#00873E]/30 rounded-full mix-blend-multiply blur-[50px] animate-liquid"></div>
          <div className="absolute top-40 -right-20 w-72 h-72 bg-emerald-400/30 rounded-full mix-blend-multiply blur-[60px] animate-liquid-slow"></div>
          <div className="absolute -bottom-20 -left-10 w-80 h-80 bg-teal-500/20 rounded-full mix-blend-multiply blur-[60px] animate-liquid"></div>
        </div>

        {/* The actual Frosted Glass layer */}
        <div className="absolute inset-0 bg-white/20 backdrop-blur-3xl shadow-[inset_0_1px_1px_rgba(255,255,255,0.9),inset_1px_0_0_rgba(255,255,255,0.4)] z-0"></div>

        {/* Content */}
        <div className="h-16 flex items-center px-6 border-b border-white/30 relative z-10">
          <div className="flex items-center gap-3">
            <img src="/logo.png" alt="Global Green Tech" className="w-9 h-9 object-contain drop-shadow-sm" />
            <span className="text-slate-800 font-extrabold tracking-wide drop-shadow-[0_1px_1px_rgba(255,255,255,1)]">Green Tech</span>
          </div>
        </div>

        <nav className="flex-1 py-6 overflow-y-auto relative z-10">
          <div className="px-6 mb-3 text-[10px] font-extrabold text-slate-500/80 uppercase tracking-widest drop-shadow-[0_1px_1px_rgba(255,255,255,1)]">Main Menu</div>
          <ul className="space-y-1.5 px-3">
            {navigation.map((item) => {
              const isActive = location.pathname === item.href;
              const Icon = item.icon;
              return (
                <li key={item.name}>
                  <Link
                    to={item.href}
                    className={`flex items-center gap-3 px-3 py-2.5 rounded-2xl transition-all duration-300 ${isActive
                        ? 'bg-white/50 text-[#00873E] font-extrabold border border-white/60 shadow-[0_4px_12px_rgba(0,0,0,0.05),inset_0_1px_0_rgba(255,255,255,0.8)] backdrop-blur-md'
                        : 'hover:bg-white/30 hover:text-slate-900 border border-transparent font-medium text-slate-700'
                      }`}
                  >
                    <Icon className={`w-4 h-4 transition-colors ${isActive ? 'text-[#00873E] drop-shadow-[0_2px_4px_rgba(0,135,62,0.3)]' : 'text-slate-500 group-hover:text-slate-700'}`} />
                    {item.name}
                  </Link>
                </li>
              );
            })}
          </ul>
        </nav>

        <div className="p-4 border-t border-white/30 relative z-10">
          <Link
            to="/login"
            className="flex items-center gap-3 px-3 py-2.5 rounded-2xl text-slate-600 hover:text-slate-900 hover:bg-white/40 transition-all duration-300 border border-transparent hover:border-white/50 hover:shadow-sm font-medium"
          >
            <LogOut className="w-4 h-4" />
            Sign Out
          </Link>
        </div>
      </aside>

      {/* Main Content Area */}
      <main className="flex-1 flex flex-col min-w-0 overflow-hidden relative">
        {/* Top Header */}
        <header className="h-16 bg-white/80 backdrop-blur-xl border-b border-slate-200/60 flex items-center justify-between px-6 z-10 shrink-0 shadow-sm sticky top-0">
          <div className="flex items-center gap-4 flex-1">
            <button className="md:hidden text-slate-500 hover:text-slate-700">
              <Menu className="w-5 h-5" />
            </button>
            <div className="hidden md:flex relative max-w-md w-full group">
              <Search className="w-4 h-4 absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 group-focus-within:text-primary-500 transition-colors" />
              <input
                type="text"
                placeholder="Search customers, tasks, or serial numbers..."
                className="w-full pl-10 pr-4 py-2 bg-white border border-slate-300 shadow-sm rounded-xl text-sm focus:ring-4 focus:ring-primary-500/10 outline-none transition-all"
              />
            </div>
          </div>

          <div className="flex items-center gap-6">
            <button className="relative text-slate-400 hover:text-primary-600 transition-colors p-2 rounded-full hover:bg-primary-50">
              <Bell className="w-5 h-5" />
              <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-red-500 rounded-full border-2 border-white shadow-sm"></span>
            </button>
            <div className="h-8 w-px bg-slate-200/80"></div>
            <div className="flex items-center gap-3 cursor-pointer group p-1.5 pr-3 rounded-full hover:bg-slate-50 border border-transparent hover:border-slate-200 transition-all">
              <div className="w-8 h-8 rounded-full bg-gradient-to-br from-primary-500 to-primary-600 text-white flex items-center justify-center font-bold text-xs shadow-md group-hover:shadow-primary-500/20">
                AU
              </div>
              <div className="text-left hidden sm:block">
                <p className="text-sm font-semibold text-slate-700 leading-none group-hover:text-primary-600 transition-colors">Admin User</p>
                <p className="text-[10px] text-slate-500 mt-1 uppercase font-semibold tracking-wider">Admin</p>
              </div>
            </div>
          </div>
        </header>

        {/* Page Content */}
        <div className="flex-1 overflow-y-auto p-6 lg:p-8 bg-[#00873E]/[0.03]">
          <div className="max-w-7xl mx-auto animate-in fade-in slide-in-from-bottom-4 duration-500">
            <Outlet />
          </div>
        </div>
      </main>
    </div>
  );
};

export default AdminLayout;
