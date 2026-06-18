import React, { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { Droplet, User, Lock, ArrowRight, ShieldCheck } from 'lucide-react';

const Login: React.FC = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const navigate = useNavigate();

  const handleLogin = (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    // Hardcoded credentials logic
    if (email === 'admin@gmail.com' && password === 'admin123') {
      navigate('/admin');
    } else if (email === 'staff@gmail.com' && password === 'staff123') {
      navigate('/staff');
    } else if (email === 'customer@gmail.com' && password === 'customer123') {
      navigate('/customer');
    } else {
      setError('Invalid email or password.');
    }
  };

  return (
    <div className="min-h-screen bg-slate-900 flex items-center justify-center p-4 relative overflow-hidden">
      {/* Dynamic Background Gradients */}
      <div className="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] bg-emerald-600/30 blur-[120px] rounded-full pointer-events-none"></div>
      <div className="absolute bottom-[-10%] right-[-10%] w-[40%] h-[40%] bg-green-600/30 blur-[120px] rounded-full pointer-events-none"></div>

      <div className="max-w-4xl w-full flex bg-white/10 backdrop-blur-xl rounded-3xl shadow-2xl overflow-hidden border border-white/20 relative z-10">

        {/* Left Side Branding */}
        <div className="hidden lg:flex flex-col justify-between w-1/2 p-12 bg-gradient-to-br from-[#00873E]/95 to-[#004d23]/95 text-white relative overflow-hidden">
          <div className="absolute inset-0 bg-[url('https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?q=80&w=2070&auto=format&fit=crop')] mix-blend-overlay opacity-20 bg-cover bg-center"></div>

          <div className="relative z-10">
            <div className="flex items-center mb-12">
              <img src="/logo.png" alt="Global Green Tech" className="h-16 w-auto object-contain drop-shadow-xl" />
            </div>

            <h1 className="text-4xl font-bold leading-tight mb-6">
              Reaping Green <br /> Futures
            </h1>
            <p className="text-emerald-100/80 text-lg max-w-md">
              Streamline operations, track technicians in real-time, and provide exceptional customer service all in one premium portal.
            </p>
          </div>

          <div className="relative z-10 flex items-center gap-4 text-sm font-medium text-emerald-200 bg-black/20 p-4 rounded-2xl backdrop-blur-sm border border-white/10">
            <ShieldCheck className="w-8 h-8 text-emerald-400" />
            <p>Enterprise-grade security. <br /> Access restricted by assigned roles.</p>
          </div>
        </div>

        {/* Right Side Form */}
        <div className="w-full lg:w-1/2 p-8 sm:p-12 bg-white">
          <div className="lg:hidden flex items-center mb-8">
            <img src="/logo.png" alt="Global Green Tech" className="h-12 w-auto object-contain" />
          </div>

          <div className="mb-10">
            <h2 className="text-3xl font-bold text-slate-900 mb-2">Welcome Back</h2>
            <p className="text-slate-500">Sign in to your Global Green Tech account.</p>
          </div>

          <form onSubmit={handleLogin} className="space-y-6">
            {error && (
              <div className="bg-red-50 text-red-600 px-4 py-3 rounded-xl text-sm font-medium border border-red-100 flex items-center gap-2">
                <span className="w-1.5 h-1.5 rounded-full bg-red-600"></span>
                {error}
              </div>
            )}

            <div className="space-y-5">
              <div className="space-y-1.5">
                <label className="text-sm font-semibold text-slate-700">Email Address</label>
                <div className="relative">
                  <User className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400" />
                  <input
                    type="email"
                    value={email}
                    onChange={(e) => { setEmail(e.target.value); setError(''); }}
                    placeholder="Enter your email"
                    required
                    className="w-full pl-11 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:ring-2 focus:ring-[#00873E] focus:border-[#00873E] outline-none transition-all font-medium text-slate-700"
                  />
                </div>
              </div>

              <div className="space-y-1.5">
                <div className="flex justify-between items-center">
                  <label className="text-sm font-semibold text-slate-700">Password</label>
                  <Link to="/forgot-password" className="text-sm font-medium text-[#00873E] hover:text-[#006b31]">Forgot password?</Link>
                </div>
                <div className="relative">
                  <Lock className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400" />
                  <input
                    type="password"
                    value={password}
                    onChange={(e) => { setPassword(e.target.value); setError(''); }}
                    placeholder="Enter your password"
                    required
                    className="w-full pl-11 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:ring-2 focus:ring-[#00873E] focus:border-[#00873E] outline-none transition-all font-medium text-slate-700"
                  />
                </div>
              </div>
            </div>

            <button
              type="submit"
              className="w-full group bg-[#00873E] hover:bg-[#006b31] text-white py-3.5 rounded-xl font-semibold transition-all shadow-[0_8px_20px_-6px_rgba(0,135,62,0.5)] hover:shadow-[0_12px_24px_-8px_rgba(0,135,62,0.6)] flex items-center justify-center gap-2 mt-4"
            >
              Sign In Securely
              <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
            </button>
          </form>
        </div>
      </div>
    </div>
  );
};

export default Login;
