
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import Login from './pages/auth/Login';
import ForgotPassword from './pages/auth/ForgotPassword';
import AdminLayout from './components/layout/AdminLayout';
import AdminDashboard from './pages/admin/AdminDashboard';
import AdminUsers from './pages/admin/AdminUsers';
import AdminCustomers from './pages/admin/AdminCustomers';
import AdminTasks from './pages/admin/AdminTasks';
import AdminInventory from './pages/admin/AdminInventory';
import AdminPayroll from './pages/admin/AdminPayroll';
import StaffLayout from './components/layout/StaffLayout';
import StaffDashboard from './pages/staff/StaffDashboard';
import CustomerLayout from './components/layout/CustomerLayout';
import CustomerDashboard from './pages/customer/CustomerDashboard';
import Settings from './pages/shared/Settings';
import { SearchContextProvider } from './context/SearchContextProvider'

function App() {
  return (
    <SearchContextProvider>
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Navigate to="/login" replace />} />
          <Route path="/login" element={<Login />} />
          <Route path="/forgot-password" element={<ForgotPassword />} />

          {/* Admin Routes */}
          <Route path="/admin" element={<AdminLayout />}>
            <Route index element={<AdminDashboard />} />
            <Route path="users" element={<AdminUsers />} />
            <Route path="customers" element={<AdminCustomers />} />
            <Route path="amc" element={<AdminTasks />} />
            <Route path="inventory" element={<AdminInventory />} />
            <Route path="payroll" element={<AdminPayroll />} />
            <Route path="settings" element={<Settings />} />
          </Route>

          {/* Staff Routes */}
          <Route path="/staff" element={<StaffLayout />}>
            <Route index element={<StaffDashboard />} />
            <Route path="check-in" element={<div className="p-4">Check-In Map Placeholder</div>} />
            <Route path="map" element={<div className="p-4">Route Map Placeholder</div>} />
            <Route path="inventory" element={<div className="p-4">Inventory Used</div>} />
            <Route path="incentives" element={<div className="p-4">Incentives Detail</div>} />
            <Route path="settings" element={<Settings />} />
          </Route>

          {/* Customer Routes */}
          <Route path="/customer" element={<CustomerLayout />}>
            <Route index element={<CustomerDashboard />} />
            <Route path="warranties" element={<div className="p-4">Warranties List</div>} />
            <Route path="referrals" element={<div className="p-4">Refer & Earn Code</div>} />
            <Route path="settings" element={<Settings />} />
          </Route>
        </Routes>
      </BrowserRouter>
    </SearchContextProvider>
  );
}

export default App;
