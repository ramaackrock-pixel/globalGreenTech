import React, { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { User, Lock, ArrowRight, ShieldCheck } from 'lucide-react';

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
    <div className="min-h-screen bg-background flex items-center justify-center p-4 relative overflow-hidden">
      {/* Dynamic Background Gradients */}
      <div className="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] bg-primary/30 blur-[120px] rounded-full pointer-events-none"></div>
      <div className="absolute bottom-[-10%] right-[-10%] w-[40%] h-[40%] bg-secondary/30 blur-[120px] rounded-full pointer-events-none"></div>

      <div className="max-w-4xl w-full flex bg-white/10 backdrop-blur-xl rounded-3xl shadow-2xl overflow-hidden border border-white/20 relative z-10">

        {/* Left Side Branding */}
        <div className="hidden lg:flex flex-col justify-between w-1/2 p-12 bg-gradient-to-br from-primary-container/95 to-primary/95 text-on-primary relative overflow-hidden">
          <div className="absolute inset-0 bg-[url('https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?q=80&w=2070&auto=format&fit=crop')] mix-blend-overlay opacity-20 bg-cover bg-center"></div>

          <div className="relative z-10">
            <div className="flex items-center mb-12">
              <img src="/logo.png" alt="Global Green Tech" className="h-16 w-auto object-contain drop-shadow-xl" />
            </div>

            <h1 className="text-display-lg leading-tight mb-6 text-on-primary">
              Reaping Green <br /> Futures
            </h1>
            <p className="text-primary-fixed text-body-lg max-w-md">
              Streamline operations, track technicians in real-time, and provide exceptional customer service all in one premium portal.
            </p>
          </div>

          <div className="relative z-10 flex items-center gap-4 text-body-sm text-primary-fixed bg-black/20 p-4 rounded-2xl backdrop-blur-sm border border-white/10">
            <ShieldCheck className="w-8 h-8 text-primary-fixed-dim" />
            <p>Enterprise-grade security. <br /> Access restricted by assigned roles.</p>
          </div>
        </div>

        {/* Right Side Form */}
        <div className="w-full lg:w-1/2 p-8 sm:p-12 bg-surface-container-lowest">
          <div className="lg:hidden flex items-center mb-8">
            <img src="/logo.png" alt="Global Green Tech" className="h-12 w-auto object-contain" />
          </div>

          <div className="mb-10">
            <h2 className="text-headline-lg text-on-surface mb-2">Welcome Back</h2>
            <p className="text-body-md text-on-surface-variant">Sign in to your Global Green Tech account.</p>
          </div>

          <form onSubmit={handleLogin} className="space-y-6">
            {error && (
              <div className="bg-error-container text-on-error-container px-4 py-3 rounded-xl text-body-sm font-medium border border-error flex items-center gap-2">
                <span className="w-1.5 h-1.5 rounded-full bg-error"></span>
                {error}
              </div>
            )}

            <div className="space-y-5">
              <div className="space-y-1.5">
                <label className="text-body-sm font-semibold text-on-surface">Email Address</label>
                <div className="relative">
                  <User className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-outline" />
                  <input
                    type="email"
                    value={email}
                    onChange={(e) => { setEmail(e.target.value); setError(''); }}
                    placeholder="Enter your email"
                    required
                    className="input-field pl-11 py-3"
                  />
                </div>
              </div>

              <div className="space-y-1.5">
                <div className="flex justify-between items-center">
                  <label className="text-body-sm font-semibold text-on-surface">Password</label>
                  <Link to="/forgot-password" className="text-body-sm font-medium text-primary hover:text-primary-container">Forgot password?</Link>
                </div>
                <div className="relative">
                  <Lock className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-outline" />
                  <input
                    type="password"
                    value={password}
                    onChange={(e) => { setPassword(e.target.value); setError(''); }}
                    placeholder="Enter your password"
                    required
                    className="input-field pl-11 py-3"
                  />
                </div>
              </div>
            </div>

            <button
              type="submit"
              className="btn-primary w-full py-3.5 text-body-lg mt-4 group"
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
