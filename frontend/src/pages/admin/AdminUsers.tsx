import React, { useState } from 'react';
import { UserPlus, Shield, MoreVertical, Building2, Briefcase } from 'lucide-react';
import { useSearch } from '../../context/SearchContextProvider';

type UserRole = 'Staff' | 'Customer';
type UserStatus = 'Active' | 'Suspended';

interface UserAccount {
  id: string;
  name: string;
  email: string;
  role: UserRole;
  status: UserStatus;
  photoUrl?: string;
}

const mockUsers: UserAccount[] = [
  { id: '1', name: 'Rahul Kumar', email: 'rahul.k@greentech.com', role: 'Staff', status: 'Active' },
  { id: '2', name: 'Acme Corp', email: 'admin@acme.com', role: 'Customer', status: 'Active' },
  { id: '3', name: 'John Doe', email: 'john@residential.com', role: 'Customer', status: 'Suspended' },
];

const AdminUsers: React.FC = () => {
  const [users, setUsers] = useState<UserAccount[]>(mockUsers);
  const [showModal, setShowModal] = useState(false);
  const { searchQuery } = useSearch();

  // Form State
  const [newName, setNewName] = useState('');
  const [newEmail, setNewEmail] = useState('');
  const [newRole, setNewRole] = useState<UserRole>('Staff');
  const [newPassword, setNewPassword] = useState('');
  const [newPhoto, setNewPhoto] = useState<File | null>(null);
  const [roleFilter, setRoleFilter] = useState('All');

  const handleAddUser = (e: React.FormEvent) => {
    e.preventDefault();
    const newUser: UserAccount = {
      id: Math.random().toString(36).substring(7),
      name: newName,
      email: newEmail,
      role: newRole,
      status: 'Active',
      photoUrl: newPhoto ? URL.createObjectURL(newPhoto) : undefined
    };

    setUsers([...users, newUser]);
    setShowModal(false);

    // Reset Form
    setNewName('');
    setNewEmail('');
    setNewRole('Staff');
    setNewPassword('');
    setNewPhoto(null);

    // Simulate notification
    alert(`Successfully created account for ${newEmail}`);
  };

  const filteredUsers = users.filter((user) => {
    const matchesRole = roleFilter === 'All' || user.role === roleFilter;

    const matchesSearch = searchQuery.trim() === '' ||
      user.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      user.email.toLowerCase().includes(searchQuery.toLowerCase());

    return matchesRole && matchesSearch;
  });

  console.log(filteredUsers)






  return (
    <div className="space-y-8 pb-20 md:pb-0">

      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 card p-6 relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-full bg-gradient-to-l from-primary-container/50 to-transparent pointer-events-none"></div>

        <div className="relative z-10">
          <h1 className="text-headline-lg text-on-surface">Access Management</h1>
          <p className="text-body-md text-on-surface-variant mt-1">Manage credentials for field staff and corporate customers.</p>
        </div>

        <button
          onClick={() => setShowModal(true)}
          className="relative z-10 btn-primary flex items-center gap-2 px-5 py-3"
        >
          <UserPlus className="w-5 h-5" />
          Create Account
        </button>
      </div>

      {/* Users Table */}
      <div className="card !p-0 overflow-hidden">
        <div className="p-6 border-b border-surface-container-highest flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-surface-container-lowest">
          <h2 className="text-label-lg font-bold text-on-surface uppercase tracking-wider">Registered Accounts</h2>

          {/* Filter Option Box (UI Only) */}
          <div className="flex items-center gap-3 w-full sm:w-auto">
            <label className="text-label-md font-bold text-on-surface-variant uppercase tracking-wider hidden sm:block">Filter by Role:</label>
            <select className="input-field w-full sm:w-auto px-4 py-2.5 cursor-pointer appearance-none" value={roleFilter} onChange={(e) => setRoleFilter(e.target.value)} >
              <option value="All">All Roles</option>
              <option value="Staff">Field Staff</option>
              <option value="Customer">Customers</option>
            </select>
          </div>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-surface-container border-b border-surface-container-highest">
                <th className="px-6 py-4 text-label-md text-on-surface-variant uppercase tracking-widest">User Details</th>
                <th className="px-6 py-4 text-label-md text-on-surface-variant uppercase tracking-widest">Role</th>
                <th className="px-6 py-4 text-label-md text-on-surface-variant uppercase tracking-widest">Status</th>
                <th className="px-6 py-4 text-label-md text-on-surface-variant uppercase tracking-widest text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-surface-container-highest">
              {filteredUsers.map((user) => (
                <tr key={user.id} className="hover:bg-surface-container/50 transition-colors group">
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-3">
                      {user.photoUrl ? (
                        <img src={user.photoUrl} alt={user.name} className="w-10 h-10 rounded-full object-cover border border-outline-variant shadow-sm" />
                      ) : (
                        <div className="w-10 h-10 rounded-full bg-surface-container flex items-center justify-center font-bold text-on-surface-variant border border-outline-variant">
                          {user.name.charAt(0)}
                        </div>
                      )}
                      <div>
                        <p className="text-body-md font-bold text-on-surface">{user.name}</p>
                        <p className="text-label-md text-on-surface-variant">{user.email}</p>
                      </div>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-2">
                      {user.role === 'Staff' ? <Briefcase className="w-4 h-4 text-primary" /> : <Building2 className="w-4 h-4 text-secondary" />}
                      <span className="text-body-sm font-bold text-on-surface">{user.role}</span>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <span className={`badge-${user.status === 'Active' ? 'active' : 'expired'}`}>
                      {user.status}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-right">
                    <button className="p-2 text-outline hover:text-primary hover:bg-primary-fixed rounded-lg transition-colors">
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
            <div className="absolute inset-0 bg-inverse-surface/60 backdrop-blur-sm" onClick={() => setShowModal(false)}></div>
            <div className="bg-surface-container-lowest rounded-3xl shadow-2xl w-full max-w-md relative z-10 overflow-hidden animate-in fade-in zoom-in-95 duration-200">
              <div className="p-6 border-b border-surface-container-highest bg-surface-container flex items-center gap-3">
                <div className="w-10 h-10 bg-surface-container-lowest rounded-xl shadow-sm border border-outline-variant flex items-center justify-center">
                  <Shield className="w-5 h-5 text-primary" />
                </div>
                <div>
                  <h2 className="text-title-lg font-extrabold text-on-surface">Create New Account</h2>
                  <p className="text-label-md font-medium text-on-surface-variant">Generate access credentials for the portal.</p>
                </div>
              </div>

              <form onSubmit={handleAddUser} className="p-6 space-y-5">
                <div className="space-y-1.5">
                  <label className="text-label-md font-bold text-on-surface uppercase tracking-wide">Full Name / Company</label>
                  <input
                    type="text"
                    value={newName}
                    onChange={(e) => setNewName(e.target.value)}
                    required
                    className="input-field"
                    placeholder="e.g. John Doe"
                  />
                </div>

                <div className="space-y-1.5">
                  <label className="text-label-md font-bold text-on-surface uppercase tracking-wide">Profile Photo / Logo</label>
                  <input
                    type="file"
                    accept="image/*"
                    onChange={(e) => {
                      if (e.target.files && e.target.files.length > 0) {
                        setNewPhoto(e.target.files[0]);
                      }
                    }}
                    className="w-full text-sm text-slate-500 file:mr-4 file:py-2.5 file:px-4 file:rounded-xl file:border-0 file:text-sm file:font-bold file:bg-primary-50 file:text-primary-700 hover:file:bg-primary-100 cursor-pointer border border-slate-200 rounded-xl"
                  />
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-1.5">
                    <label className="text-label-md font-bold text-on-surface uppercase tracking-wide">Account Role</label>
                    <select
                      value={newRole}
                      onChange={(e) => setNewRole(e.target.value as UserRole)}
                      className="input-field appearance-none cursor-pointer"
                    >
                      <option value="Staff">Field Staff</option>
                      <option value="Customer">Customer</option>
                    </select>
                  </div>
                  <div className="space-y-1.5">
                    <label className="text-label-md font-bold text-on-surface uppercase tracking-wide">Email</label>
                    <input
                      type="email"
                      value={newEmail}
                      onChange={(e) => setNewEmail(e.target.value)}
                      required
                      className="input-field"
                      placeholder="user@example.com"
                    />
                  </div>
                </div>

                <div className="space-y-1.5">
                  <label className="text-label-md font-bold text-on-surface uppercase tracking-wide">Temporary Password</label>
                  <input
                    type="text"
                    value={newPassword}
                    onChange={(e) => setNewPassword(e.target.value)}
                    required
                    className="input-field"
                    placeholder="e.g. Temp@1234"
                  />
                </div>

                <div className="pt-4 flex gap-3">
                  <button
                    type="button"
                    onClick={() => setShowModal(false)}
                    className="flex-1 px-4 py-3 rounded-xl font-bold text-on-surface-variant bg-surface-container hover:bg-surface-container-highest transition-colors"
                  >
                    Cancel
                  </button>
                  <button
                    type="submit"
                    className="btn-primary flex-1 px-4 py-3"
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
