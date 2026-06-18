import React, { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { Mail, ArrowLeft, ArrowRight, ShieldCheck } from 'lucide-react';

const ForgotPassword: React.FC = () => {
  const [email, setEmail] = useState('');
  const [isSubmitted, setIsSubmitted] = useState(false);
  const navigate = useNavigate();

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (email) {
      // Simulate sending reset link
      setIsSubmitted(true);
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
              Secure Account <br /> Recovery
            </h1>
            <p className="text-emerald-100/80 text-lg max-w-md">
              Forgot your password? No problem. Follow our secure recovery process to regain access to the enterprise portal.
            </p>
          </div>

          <div className="relative z-10 flex items-center gap-4 text-sm font-medium text-emerald-200 bg-black/20 p-4 rounded-2xl backdrop-blur-sm border border-white/10">
            <ShieldCheck className="w-8 h-8 text-emerald-400" />
            <p>Verification links expire in 15 minutes. <br /> Security protocols enforced.</p>
          </div>
        </div>

        {/* Right Side Form */}
        <div className="w-full lg:w-1/2 p-8 sm:p-12 bg-white flex flex-col justify-center">
          <div className="lg:hidden flex items-center mb-8">
            <img src="/logo.png" alt="Global Green Tech" className="h-12 w-auto object-contain" />
          </div>

          {!isSubmitted ? (
            <>
              <div className="mb-8">
                <Link to="/login" className="inline-flex items-center gap-2 text-sm font-medium text-slate-500 hover:text-slate-800 transition-colors mb-6">
                  <ArrowLeft className="w-4 h-4" /> Back to Login
                </Link>
                <h2 className="text-3xl font-bold text-slate-900 mb-2">Reset Password</h2>
                <p className="text-slate-500 leading-relaxed">Enter the email address associated with your account, and we'll send you a link to reset your password.</p>
              </div>

              <form onSubmit={handleSubmit} className="space-y-6">
                <div className="space-y-1.5">
                  <label className="text-sm font-semibold text-slate-700">Email Address</label>
                  <div className="relative">
                    <Mail className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400" />
                    <input
                      type="email"
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      placeholder="e.g. staff@greentech.com"
                      required
                      className="w-full pl-11 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:bg-white focus:ring-2 focus:ring-[#00873E] focus:border-[#00873E] outline-none transition-all font-medium text-slate-700"
                    />
                  </div>
                </div>

                <button
                  type="submit"
                  className="w-full group bg-[#00873E] hover:bg-[#006b31] text-white py-3.5 rounded-xl font-semibold transition-all shadow-[0_8px_20px_-6px_rgba(0,135,62,0.5)] hover:shadow-[0_12px_24px_-8px_rgba(0,135,62,0.6)] flex items-center justify-center gap-2"
                >
                  Send Reset Link
                  <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
                </button>
              </form>
            </>
          ) : (
            <div className="text-center py-8">
              <div className="w-20 h-20 bg-emerald-50 rounded-full flex items-center justify-center mx-auto mb-6">
                <Mail className="w-10 h-10 text-emerald-600" />
              </div>
              <h2 className="text-2xl font-bold text-slate-900 mb-3">Check your inbox</h2>
              <p className="text-slate-500 mb-8 max-w-sm mx-auto">
                We have sent a secure password reset link to <br />
                <span className="font-semibold text-slate-800">{email}</span>
              </p>
              <Link
                to="/login"
                className="inline-flex justify-center w-full bg-slate-900 hover:bg-slate-800 text-white py-3.5 rounded-xl font-semibold transition-all"
              >
                Return to Sign In
              </Link>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default ForgotPassword;
