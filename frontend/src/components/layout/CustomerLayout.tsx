import React from 'react';
import { Outlet, Link, useLocation } from 'react-router-dom';
import { 
  Home, 
  Settings, 
  ShieldCheck, 
  Gift, 
  LogOut,
  Bell,
  Menu
} from 'lucide-react';

const CustomerLayout: React.FC = () => {
  const location = useLocation();

  const navigation = [
    { name: 'My Dashboard', href: '/customer', icon: Home },
    { name: 'Warranties & Products', href: '/customer/warranties', icon: ShieldCheck },
    { name: 'Referrals', href: '/customer/referrals', icon: Gift },
    { name: 'Account Settings', href: '/customer/settings', icon: Settings },
  ];

  return (
    <div className="flex h-screen bg-[#f8fafc] text-slate-800 font-sans text-sm selection:bg-primary-500/30">
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
          <div className="px-6 mb-3 text-[10px] font-extrabold text-slate-500/80 uppercase tracking-widest drop-shadow-[0_1px_1px_rgba(255,255,255,1)]">Client Portal</div>
          <ul className="space-y-1.5 px-3">
            {navigation.map((item) => {
              const isActive = location.pathname === item.href;
              const Icon = item.icon;
              return (
                <li key={item.name}>
                  <Link
                    to={item.href}
                    className={`flex items-center gap-3 px-3 py-2.5 rounded-2xl transition-all duration-300 ${
                      isActive 
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

      {/* Main Content */}
      <main className="flex-1 flex flex-col min-w-0 overflow-hidden relative">
        {/* Top Header */}
        <header className="h-16 bg-white/80 backdrop-blur-xl border-b border-slate-200/60 flex items-center justify-between px-6 z-10 shrink-0 sticky top-0 shadow-sm">
          <div className="flex items-center gap-4">
            <button className="md:hidden text-slate-500 hover:text-slate-700">
              <Menu className="w-5 h-5" />
            </button>
            <h2 className="text-sm font-bold text-slate-700 hidden sm:block bg-slate-100 px-3 py-1 rounded-full border border-slate-200">Customer Portal</h2>
          </div>
          
          <div className="flex items-center gap-6">
            <button className="relative text-slate-400 hover:text-primary-600 transition-colors p-2 rounded-full hover:bg-primary-50">
              <Bell className="w-5 h-5" />
              <span className="absolute top-2 right-2 w-2 h-2 bg-red-500 rounded-full border-2 border-white"></span>
            </button>
            <div className="h-8 w-px bg-slate-200/80"></div>
            <div className="flex items-center gap-3 cursor-pointer group p-1.5 pr-4 rounded-full hover:bg-white border border-transparent hover:border-slate-200 hover:shadow-sm transition-all">
              <div className="w-8 h-8 rounded-full bg-gradient-to-br from-slate-800 to-slate-900 text-white flex items-center justify-center font-bold text-xs shadow-md">
                AC
              </div>
              <span className="text-sm font-bold text-slate-700 hidden sm:block group-hover:text-primary-600 transition-colors">Acme Corp</span>
            </div>
          </div>
        </header>

        {/* Page Content */}
        <div className="flex-1 overflow-y-auto p-6 lg:p-8 bg-[#00873E]/[0.03]">
          <div className="max-w-6xl mx-auto animate-in fade-in slide-in-from-bottom-4 duration-500">
            <Outlet />
          </div>
        </div>
      </main>

      {/* Bottom Navigation for Mobile */}
      <nav className="md:hidden bg-white/90 backdrop-blur-md border-t border-slate-200 fixed bottom-0 w-full flex justify-around p-2 pb-safe z-20 shadow-[0_-4px_20px_rgba(0,0,0,0.05)]">
        {navigation.slice(0,4).map((item) => {
          const isActive = location.pathname === item.href;
          const Icon = item.icon;
          return (
            <Link
              key={item.name}
              to={item.href}
              className={`flex flex-col items-center gap-1 p-2 rounded-xl transition-all ${
                isActive ? 'text-primary-600 bg-primary-50' : 'text-slate-500 hover:bg-slate-50'
              }`}
            >
              <Icon className={`w-5 h-5 ${isActive ? 'text-primary-600' : 'text-slate-400'}`} />
              <span className="text-[10px] font-bold">{item.name.split(' ')[0]}</span>
            </Link>
          );
        })}
      </nav>
    </div>
  );
};

export default CustomerLayout;
