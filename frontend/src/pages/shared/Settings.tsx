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
        <h1 className="text-headline-lg text-on-surface">Security Settings</h1>
        <p className="text-body-md text-on-surface-variant mt-1">Update your account password and security preferences.</p>
      </div>

      <div className="card !p-0 overflow-hidden relative">
        <div className="absolute top-0 right-0 w-64 h-64 bg-primary/5 blur-[50px] pointer-events-none"></div>
        
        <div className="p-8 border-b border-surface-container-highest flex items-center gap-4 relative z-10">
          <div className="w-12 h-12 rounded-2xl bg-primary-fixed text-primary flex items-center justify-center border border-primary-container shadow-inner">
            <KeyRound className="w-6 h-6" />
          </div>
          <div>
            <h2 className="text-title-lg font-bold text-on-surface">Change Password</h2>
            <p className="text-body-sm text-on-surface-variant mt-0.5">Ensure your account is using a long, random password to stay secure.</p>
          </div>
        </div>

        <form onSubmit={handleSubmit} className="p-8 space-y-6 relative z-10">
          {message && (
            <div className={`flex items-center gap-3 p-4 rounded-xl border ${
              message.type === 'success' ? 'bg-primary-fixed text-primary border-primary-container' : 'bg-error-container text-on-error-container border-error/20'
            }`}>
              {message.type === 'success' ? <CheckCircle2 className="w-5 h-5 text-primary" /> : <ShieldAlert className="w-5 h-5 text-error" />}
              <span className="text-sm font-bold">{message.text}</span>
            </div>
          )}

          <div className="space-y-2">
            <label className="text-label-md font-bold text-on-surface">Current Password</label>
            <input 
              type="password" 
              value={currentPassword}
              onChange={(e) => setCurrentPassword(e.target.value)}
              required
              className="input-field lg:w-2/3"
            />
          </div>

          <div className="space-y-2">
            <label className="text-label-md font-bold text-on-surface">New Password</label>
            <input 
              type="password" 
              value={newPassword}
              onChange={(e) => setNewPassword(e.target.value)}
              required
              className="input-field lg:w-2/3"
            />
          </div>

          <div className="space-y-2">
            <label className="text-label-md font-bold text-on-surface">Retype New Password</label>
            <input 
              type="password" 
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              required
              className="input-field lg:w-2/3"
            />
          </div>

          <div className="pt-4 flex justify-end lg:w-2/3">
            <button 
              type="submit"
              className="btn-primary px-6 py-3"
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
