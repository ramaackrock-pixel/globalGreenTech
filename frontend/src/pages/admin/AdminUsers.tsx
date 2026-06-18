import React, { useState } from 'react';
import { UserPlus, Shield, MoreVertical, Building2, Briefcase } from 'lucide-react';

type UserRole = 'Staff' | 'Customer';
type UserStatus = 'Active' | 'Suspended';

interface UserAccount {
  id: string;
  name: string;
  email: string;
  role: UserRole;
  status: UserStatus;
}

const mockUsers: UserAccount[] = [
  { id: '1', name: 'Rahul Kumar', email: 'rahul.k@greentech.com', role: 'Staff', status: 'Active' },
  { id: '2', name: 'Acme Corp', email: 'admin@acme.com', role: 'Customer', status: 'Active' },
  { id: '3', name: 'John Doe', email: 'john@residential.com', role: 'Customer', status: 'Suspended' },
];

const AdminUsers: React.FC = () => {
  const [users, setUsers] = useState<UserAccount[]>(mockUsers);
  const [showModal, setShowModal] = useState(false);

  // Form State
  const [newName, setNewName] = useState('');
  const [newEmail, setNewEmail] = useState('');
  const [newRole, setNewRole] = useState<UserRole>('Staff');
  const [newPassword, setNewPassword] = useState('');
  const [roleFilter, setRoleFilter] = useState('All');

  const handleAddUser = (e: React.FormEvent) => {
    e.preventDefault();
    const newUser: UserAccount = {
      id: Math.random().toString(36).substring(7),
      name: newName,
      email: newEmail,
      role: newRole,
      status: 'Active'
    };

    setUsers([...users, newUser]);
    setShowModal(false);

    // Reset Form
    setNewName('');
    setNewEmail('');
    setNewRole('Staff');
    setNewPassword('');

    // Simulate notification
    alert(`Successfully created account for ${newEmail}`);
  };

  const filteredUsers = users.filter((user) => {
    if (roleFilter === user.role) return user;
    if (roleFilter === 'All') return []

  })





  return (
    <div className="space-y-8 pb-20 md:pb-0">

      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-white p-6 rounded-2xl shadow-[0_2px_10px_-3px_rgba(6,81,237,0.1)] border border-slate-100 relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-full bg-gradient-to-l from-primary-50/50 to-transparent pointer-events-none"></div>

        <div className="relative z-10">
          <h1 className="text-2xl font-extrabold text-slate-800 tracking-tight">Access Management</h1>
          <p className="text-slate-500 text-sm mt-1 font-medium">Manage credentials for field staff and corporate customers.</p>
        </div>

        <button
          onClick={() => setShowModal(true)}
          className="relative z-10 flex items-center gap-2 px-5 py-3 bg-gradient-to-r from-slate-900 to-slate-800 hover:from-slate-800 hover:to-slate-700 text-white rounded-xl font-bold shadow-md hover:shadow-lg transition-all"
        >
          <UserPlus className="w-5 h-5" />
          Create Account
        </button>
      </div>

      {/* Users Table */}
      <div className="bg-white rounded-2xl shadow-[0_4px_20px_-4px_rgba(0,0,0,0.03)] border border-slate-100 overflow-hidden">
        <div className="p-6 border-b border-slate-100 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-slate-50/50">
          <h2 className="text-sm font-bold text-slate-800 uppercase tracking-wider">Registered Accounts</h2>

          {/* Filter Option Box (UI Only) */}
          <div className="flex items-center gap-3 w-full sm:w-auto">
            <label className="text-xs font-bold text-slate-500 uppercase tracking-wider hidden sm:block">Filter by Role:</label>
            <select className="w-full sm:w-auto px-4 py-2.5 rounded-xl border border-slate-300 bg-white shadow-sm text-sm font-bold text-slate-700 outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all appearance-none cursor-pointer" value={roleFilter} onChange={(e) => setRoleFilter(e.target.value)} >
              <option value="All">All Roles</option>
              <option value="Staff">Field Staff</option>
              <option value="Customer">Customers</option>
            </select>
          </div>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-slate-50/50 border-b border-slate-100">
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">User Details</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">Role</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest">Status</th>
                <th className="px-6 py-4 text-[10px] font-extrabold text-slate-400 uppercase tracking-widest text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {(filteredUsers.length > 0 || roleFilter !== 'All' ? filteredUsers : users).map((user) => (
                <tr key={user.id} className="hover:bg-slate-50/80 transition-colors group">
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-full bg-slate-100 flex items-center justify-center font-bold text-slate-600 border border-slate-200">
                        {user.name.charAt(0)}
                      </div>
                      <div>
                        <p className="text-sm font-bold text-slate-800">{user.name}</p>
                        <p className="text-xs text-slate-500 font-medium">{user.email}</p>
                      </div>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-2">
                      {user.role === 'Staff' ? <Briefcase className="w-4 h-4 text-blue-500" /> : <Building2 className="w-4 h-4 text-amber-500" />}
                      <span className="text-sm font-bold text-slate-700">{user.role}</span>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <span className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider border ${user.status === 'Active' ? 'bg-emerald-50 text-emerald-600 border-emerald-100' : 'bg-red-50 text-red-600 border-red-100'
                      }`}>
                      {user.status}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-right">
                    <button className="p-2 text-slate-400 hover:text-primary-600 hover:bg-primary-50 rounded-lg transition-colors">
                      <MoreVertical className="w-5 h-5" />
                    </button>
                  </td>
                </tr>

              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Create User Modal */}
      {
        showModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
            <div className="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" onClick={() => setShowModal(false)}></div>
            <div className="bg-white rounded-3xl shadow-2xl w-full max-w-md relative z-10 overflow-hidden animate-in fade-in zoom-in-95 duration-200">
              <div className="p-6 border-b border-slate-100 bg-slate-50/50 flex items-center gap-3">
                <div className="w-10 h-10 bg-white rounded-xl shadow-sm border border-slate-100 flex items-center justify-center">
                  <Shield className="w-5 h-5 text-primary-600" />
                </div>
                <div>
                  <h2 className="text-lg font-extrabold text-slate-800">Create New Account</h2>
                  <p className="text-xs font-medium text-slate-500">Generate access credentials for the portal.</p>
                </div>
              </div>

              <form onSubmit={handleAddUser} className="p-6 space-y-5">
                <div className="space-y-1.5">
                  <label className="text-xs font-bold text-slate-700 uppercase tracking-wide">Full Name / Company</label>
                  <input
                    type="text"
                    value={newName}
                    onChange={(e) => setNewName(e.target.value)}
                    required
                    className="w-full px-4 py-3 rounded-xl border border-slate-300 bg-white shadow-sm focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 outline-none transition-all font-medium text-slate-800"
                    placeholder="e.g. John Doe"
                  />
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-1.5">
                    <label className="text-xs font-bold text-slate-700 uppercase tracking-wide">Account Role</label>
                    <select
                      value={newRole}
                      onChange={(e) => setNewRole(e.target.value as UserRole)}
                      className="w-full px-4 py-3 rounded-xl border border-slate-300 bg-white shadow-sm focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 outline-none transition-all font-bold text-slate-800 appearance-none"
                    >
                      <option value="Staff">Field Staff</option>
                      <option value="Customer">Customer</option>
                    </select>
                  </div>
                  <div className="space-y-1.5">
                    <label className="text-xs font-bold text-slate-700 uppercase tracking-wide">Email</label>
                    <input
                      type="email"
                      value={newEmail}
                      onChange={(e) => setNewEmail(e.target.value)}
                      required
                      className="w-full px-4 py-3 rounded-xl border border-slate-300 bg-white shadow-sm focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 outline-none transition-all font-medium text-slate-800"
                      placeholder="user@example.com"
                    />
                  </div>
                </div>

                <div className="space-y-1.5">
                  <label className="text-xs font-bold text-slate-700 uppercase tracking-wide">Temporary Password</label>
                  <input
                    type="text"
                    value={newPassword}
                    onChange={(e) => setNewPassword(e.target.value)}
                    required
                    className="w-full px-4 py-3 rounded-xl border border-slate-200 bg-slate-50/50 focus:bg-white focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 outline-none transition-all font-medium text-slate-800"
                    placeholder="e.g. Temp@1234"
                  />
                </div>

                <div className="pt-4 flex gap-3">
                  <button
                    type="button"
                    onClick={() => setShowModal(false)}
                    className="flex-1 px-4 py-3 rounded-xl font-bold text-slate-600 bg-slate-100 hover:bg-slate-200 transition-colors"
                  >
                    Cancel
                  </button>
                  <button
                    type="submit"
                    className="flex-1 px-4 py-3 rounded-xl font-bold text-white bg-gradient-to-r from-[#00873E] to-[#006b31] shadow-[0_4px_12px_-2px_rgba(0,135,62,0.4)] hover:shadow-[0_8px_16px_-4px_rgba(0,135,62,0.5)] transition-all"
                  >
                    Create Account
                  </button>
                </div>
              </form>
            </div>
          </div>
        )
      }
    </div >
  );
};

export default AdminUsers;
