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
import { useSearch } from '../../context/SearchContextProvider';

const AdminLayout: React.FC = () => {
  const location = useLocation();
  const { searchQuery, setSearchQuery } = useSearch();

  const navigation = [
    { name: 'Dashboard', href: '/admin', icon: LayoutDashboard },
    { name: 'User Accounts', href: '/admin/users', icon: ShieldCheck },
    { name: 'Customers & AMC', href: '/admin/customers', icon: Users },
    { name: 'Service Tasks', href: '/admin/amc', icon: CalendarClock },
    { name: 'Inventory', href: '/admin/inventory', icon: Package },
    { name: 'Settings', href: '/admin/settings', icon: Settings },
  ];

  return (
    <div className="flex h-screen bg-background text-on-surface font-sans text-sm selection:bg-primary/30 selection:text-on-primary">
      <aside className="w-64 hidden md:flex flex-col relative overflow-hidden shadow-[8px_0_40px_rgba(0,94,154,0.08)] z-20 border-r border-outline-variant/40 bg-surface-container-lowest">
        <div className="absolute inset-0 z-0 overflow-hidden pointer-events-none">
          <div className="absolute -top-10 -left-10 w-64 h-64 bg-primary/20 rounded-full mix-blend-multiply blur-[50px] animate-liquid"></div>
          <div className="absolute top-40 -right-20 w-72 h-72 bg-secondary/20 rounded-full mix-blend-multiply blur-[60px] animate-liquid-slow"></div>
          <div className="absolute -bottom-20 -left-10 w-80 h-80 bg-tertiary/20 rounded-full mix-blend-multiply blur-[60px] animate-liquid"></div>
        </div>

        <div className="absolute inset-0 bg-surface-container-lowest/40 backdrop-blur-3xl z-0"></div>

        <div className="h-16 flex items-center px-6 border-b border-surface-container-highest relative z-10">
          <div className="flex items-center gap-3">
            <img src="/logo.png" alt="Global Green Tech" className="w-9 h-9 object-contain drop-shadow-sm" />
            <span className="text-on-surface font-extrabold tracking-wide drop-shadow-[0_1px_1px_rgba(255,255,255,1)]">Green Tech</span>
          </div>
        </div>

        <nav className="flex-1 py-6 overflow-y-auto relative z-10">
          <div className="px-6 mb-3 text-label-md text-on-surface-variant uppercase tracking-widest drop-shadow-[0_1px_1px_rgba(255,255,255,1)]">Main Menu</div>
          <ul className="space-y-1.5 px-3">
            {navigation.map((item) => {
              const isActive = location.pathname === item.href;
              const Icon = item.icon;
              return (
                <li key={item.name}>
                  <Link
                    to={item.href}
                    className={`flex items-center gap-3 px-3 py-2.5 rounded-2xl transition-all duration-300 ${isActive
                      ? 'bg-primary-container/10 text-primary font-extrabold border border-primary/20 shadow-sm'
                      : 'hover:bg-surface-container hover:text-on-surface border border-transparent font-medium text-on-surface-variant'
                      }`}
                  >
                    <Icon className={`w-4 h-4 transition-colors ${isActive ? 'text-primary' : 'text-outline group-hover:text-on-surface'}`} />
                    {item.name}
                  </Link>
                </li>
              );
            })}
          </ul>
        </nav>

        <div className="p-4 border-t border-surface-container-highest relative z-10">
          <Link
            to="/login"
            className="flex items-center gap-3 px-3 py-2.5 rounded-2xl text-on-surface-variant hover:text-on-surface hover:bg-surface-container transition-all duration-300 border border-transparent font-medium"
          >
            <LogOut className="w-4 h-4" />
            Sign Out
          </Link>
        </div>
      </aside>

      {/* Main Content Area */}
      <main className="flex-1 flex flex-col min-w-0 overflow-hidden relative">
        {/* Top Header */}
        <header className="h-16 bg-surface-container-lowest/80 backdrop-blur-xl border-b border-surface-container-highest flex items-center justify-between px-6 z-10 shrink-0 shadow-sm sticky top-0">
          <div className="flex items-center gap-4 flex-1">
            <button className="md:hidden text-outline hover:text-on-surface">
              <Menu className="w-5 h-5" />
            </button>
            <div className="hidden md:flex relative max-w-md w-full group">
              <Search className="w-4 h-4 absolute left-3.5 top-1/2 -translate-y-1/2 text-outline group-focus-within:text-primary transition-colors" />
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Search customers, tasks, or inventory..."
                className="input-field pl-10 py-2 rounded-xl"
              />
            </div>
          </div>

          <div className="flex items-center gap-6">
            <button className="relative text-outline hover:text-primary transition-colors p-2 rounded-full hover:bg-primary-fixed">
              <Bell className="w-5 h-5" />
              <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-error rounded-full border-2 border-surface-container-lowest shadow-sm"></span>
            </button>
            <div className="h-8 w-px bg-surface-container-highest"></div>
            <div className="flex items-center gap-3 cursor-pointer group p-1.5 pr-3 rounded-full hover:bg-surface-container border border-transparent transition-all">
              <div className="w-8 h-8 rounded-full bg-primary-container text-on-primary flex items-center justify-center font-bold text-xs shadow-md">
                AU
              </div>
              <div className="text-left hidden sm:block">
                <p className="text-body-sm font-semibold text-on-surface leading-none group-hover:text-primary transition-colors">Admin User</p>
                <p className="text-label-md text-on-surface-variant mt-1">Admin</p>
              </div>
            </div>
          </div>
        </header>

        {/* Page Content */}
        <div className="flex-1 overflow-y-auto p-6 lg:p-8 bg-background">
          <div className="max-w-7xl mx-auto animate-in fade-in slide-in-from-bottom-4 duration-500">
            <Outlet />
          </div>
        </div>
      </main>
    </div>
  );
};

export default AdminLayout;
