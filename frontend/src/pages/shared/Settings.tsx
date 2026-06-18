import React, { useState } from 'react';
import { KeyRound, CheckCircle2, ShieldAlert } from 'lucide-react';

const Settings: React.FC = () => {
  const [currentPassword, setCurrentPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [message, setMessage] = useState<{ type: 'success' | 'error', text: string } | null>(null);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (newPassword !== confirmPassword) {
      setMessage({ type: 'error', text: 'New passwords do not match.' });
      return;
    }
    if (newPassword.length < 6) {
      setMessage({ type: 'error', text: 'Password must be at least 6 characters.' });
      return;
    }
    
    // Simulate API call
    setMessage({ type: 'success', text: 'Password successfully updated.' });
    setCurrentPassword('');
    setNewPassword('');
    setConfirmPassword('');
  };

  return (
    <div className="max-w-3xl space-y-8 pb-20 md:pb-0">
      <div className="flex flex-col gap-2">
        <h1 className="text-2xl font-extrabold text-slate-800 tracking-tight">Security Settings</h1>
        <p className="text-slate-500 text-sm font-medium">Update your account password and security preferences.</p>
      </div>

      <div className="bg-white rounded-3xl shadow-[0_4px_20px_-4px_rgba(0,0,0,0.03)] border border-slate-100 overflow-hidden relative">
        <div className="absolute top-0 right-0 w-64 h-64 bg-primary-500/5 blur-[50px] pointer-events-none"></div>
        
        <div className="p-8 border-b border-slate-100 flex items-center gap-4 relative z-10">
          <div className="w-12 h-12 rounded-2xl bg-primary-50 text-primary-600 flex items-center justify-center border border-primary-100 shadow-inner">
            <KeyRound className="w-6 h-6" />
          </div>
          <div>
            <h2 className="text-lg font-bold text-slate-800">Change Password</h2>
            <p className="text-sm text-slate-500 mt-0.5">Ensure your account is using a long, random password to stay secure.</p>
          </div>
        </div>

        <form onSubmit={handleSubmit} className="p-8 space-y-6 relative z-10">
          {message && (
            <div className={`flex items-center gap-3 p-4 rounded-xl border ${
              message.type === 'success' ? 'bg-emerald-50 text-emerald-800 border-emerald-200' : 'bg-red-50 text-red-800 border-red-200'
            }`}>
              {message.type === 'success' ? <CheckCircle2 className="w-5 h-5 text-emerald-600" /> : <ShieldAlert className="w-5 h-5 text-red-600" />}
              <span className="text-sm font-bold">{message.text}</span>
            </div>
          )}

          <div className="space-y-2">
            <label className="text-sm font-bold text-slate-700">Current Password</label>
            <input 
              type="password" 
              value={currentPassword}
              onChange={(e) => setCurrentPassword(e.target.value)}
              required
              className="w-full lg:w-2/3 px-4 py-3 rounded-xl border border-slate-300 bg-white shadow-sm focus:bg-white focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 outline-none transition-all text-slate-800 font-medium"
            />
          </div>

          <div className="space-y-2">
            <label className="text-sm font-bold text-slate-700">New Password</label>
            <input 
              type="password" 
              value={newPassword}
              onChange={(e) => setNewPassword(e.target.value)}
              required
              className="w-full lg:w-2/3 px-4 py-3 rounded-xl border border-slate-300 bg-white shadow-sm focus:bg-white focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 outline-none transition-all text-slate-800 font-medium"
            />
          </div>

          <div className="space-y-2">
            <label className="text-sm font-bold text-slate-700">Retype New Password</label>
            <input 
              type="password" 
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              required
              className="w-full lg:w-2/3 px-4 py-3 rounded-xl border border-slate-300 bg-white shadow-sm focus:bg-white focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 outline-none transition-all text-slate-800 font-medium"
            />
          </div>

          <div className="pt-4 flex justify-end lg:w-2/3">
            <button 
              type="submit"
              className="px-6 py-3 rounded-xl font-bold text-white bg-gradient-to-r from-[#00873E] to-[#006b31] shadow-[0_4px_12px_-2px_rgba(0,135,62,0.4)] hover:shadow-[0_8px_16px_-4px_rgba(0,135,62,0.5)] transition-all"
            >
              Update Password
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default Settings;
