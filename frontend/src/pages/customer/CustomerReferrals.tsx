import React, { useState } from 'react';
import { Gift, Copy, Share2, Users, Coins, CheckCircle2 } from 'lucide-react';
import customersData from '../../mockData/customers.json';

const CustomerReferrals: React.FC = () => {
  const me = customersData[0]; // Acme Corp
  const [copied, setCopied] = useState(false);

  const referralCode = `GGT-${me.id}-500`;

  const copyToClipboard = () => {
    navigator.clipboard.writeText(referralCode);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const shareViaWhatsApp = () => {
    const text = `Hey! I highly recommend Global Green Tech for your RO systems. Use my referral code to get a ₹500 discount on your first service: ${referralCode}`;
    window.open(`https://wa.me/?text=${encodeURIComponent(text)}`, '_blank');
  };

  return (
    <div className="space-y-6 pb-20 md:pb-0">
      
      {/* Header Banner */}
      <div className="bg-primary rounded-3xl p-8 relative overflow-hidden text-white shadow-lg">
        <div className="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full blur-3xl -translate-y-1/4 translate-x-1/4 pointer-events-none"></div>
        <div className="relative z-10 flex flex-col md:flex-row justify-between items-center gap-8 text-center md:text-left">
          <div className="max-w-xl">
            <h1 className="text-display-sm font-black mb-3">Refer & Earn Rewards!</h1>
            <p className="text-body-lg text-primary-fixed font-medium">Invite your network to Global Green Tech and earn ₹500 off your next AMC or service visit for every successful referral.</p>
          </div>
          <div className="w-32 h-32 bg-white/20 rounded-full flex items-center justify-center shrink-0 backdrop-blur-sm border border-white/30 shadow-inner">
            <Gift className="w-16 h-16 text-white drop-shadow-md" />
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        
        {/* Referral Code Card */}
        <div className="lg:col-span-2 bg-white rounded-3xl p-6 lg:p-8 border border-outline-variant/30 shadow-sm flex flex-col justify-center">
          <h2 className="text-title-lg font-black text-on-surface mb-2">Your Unique Referral Code</h2>
          <p className="text-label-md text-on-surface-variant mb-6">Share this code with friends. When they sign up and book a service, you both get ₹500 off!</p>
          
          <div className="flex flex-wrap sm:flex-nowrap gap-3">
            <div className="flex-1 min-w-0 bg-surface-container-lowest border border-outline-variant rounded-xl flex items-center px-4 py-3">
              <span className="text-body-md font-mono font-bold text-on-surface truncate block w-full">{referralCode}</span>
            </div>
            <button 
              onClick={copyToClipboard}
              className={`px-6 py-3 rounded-xl font-bold flex items-center justify-center gap-2 transition-all ${
                copied ? 'bg-emerald-500 text-white' : 'bg-primary text-white hover:bg-primary/90'
              }`}
            >
              {copied ? <CheckCircle2 className="w-5 h-5" /> : <Copy className="w-5 h-5" />}
              {copied ? 'Copied!' : 'Copy Code'}
            </button>
            <button 
              onClick={shareViaWhatsApp}
              className="px-6 py-3 rounded-xl font-bold flex items-center justify-center gap-2 bg-[#25D366] text-white hover:bg-[#20bd5a] transition-all"
            >
              <Share2 className="w-5 h-5" />
              Share
            </button>
          </div>
        </div>

        {/* Stats Card */}
        <div className="bg-surface-container-lowest rounded-3xl p-6 lg:p-8 border border-outline-variant/30 shadow-sm flex flex-col justify-center space-y-6">
          <div className="flex items-center gap-4">
            <div className="w-12 h-12 bg-secondary-container text-on-secondary-container rounded-full flex items-center justify-center">
              <Users className="w-6 h-6" />
            </div>
            <div>
              <p className="text-label-sm font-bold text-on-surface-variant uppercase tracking-wider">Total Referrals</p>
              <p className="text-headline-md font-black text-on-surface">3</p>
            </div>
          </div>
          
          <div className="h-px w-full bg-surface-container-highest"></div>
          
          <div className="flex items-center gap-4">
            <div className="w-12 h-12 bg-amber-100 text-amber-700 rounded-full flex items-center justify-center">
              <Coins className="w-6 h-6" />
            </div>
            <div>
              <p className="text-label-sm font-bold text-on-surface-variant uppercase tracking-wider">Rewards Earned</p>
              <p className="text-headline-md font-black text-primary">₹1,500</p>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
};

export default CustomerReferrals;
