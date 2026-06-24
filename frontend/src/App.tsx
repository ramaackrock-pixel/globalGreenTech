
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
import AdminMap from './pages/admin/AdminMap';
import AdminPhotos from './pages/admin/AdminPhotos';
import AdminKiosk from './pages/admin/AdminKiosk';
import AdminAttendance from './pages/admin/AdminAttendance';
import StaffLayout from './components/layout/StaffLayout';
import StaffDashboard from './pages/staff/StaffDashboard';
import DailyAttendance from './pages/staff/DailyAttendance';
import StaffMap from './pages/staff/StaffMap';
import StaffInventory from './pages/staff/StaffInventory';
import StaffCheckIn from './pages/staff/StaffCheckIn';
import StaffIncentives from './pages/staff/StaffIncentives';
import CustomerLayout from './components/layout/CustomerLayout';
import CustomerDashboard from './pages/customer/CustomerDashboard';
import CustomerWarranties from './pages/customer/CustomerWarranties';
import CustomerReferrals from './pages/customer/CustomerReferrals';
import CustomerComplaints from './pages/customer/CustomerComplaints';
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
            <Route path="kiosk" element={<AdminKiosk />} />
            <Route path="customers" element={<AdminCustomers />} />
            <Route path="amc" element={<AdminTasks />} />
            <Route path="tracking" element={<AdminMap />} />
            <Route path="attendance" element={<AdminAttendance />} />
            <Route path="photos" element={<AdminPhotos />} />
            <Route path="inventory" element={<AdminInventory />} />
            <Route path="payroll" element={<AdminPayroll />} />
            <Route path="settings" element={<Settings />} />
          </Route>

          {/* Staff Routes */}
          <Route path="/staff" element={<StaffLayout />}>
            <Route index element={<StaffDashboard />} />
            <Route path="attendance" element={<DailyAttendance />} />
            <Route path="check-in" element={<StaffCheckIn />} />
            <Route path="map" element={<StaffMap />} />
            <Route path="inventory" element={<StaffInventory />} />
            <Route path="incentives" element={<StaffIncentives />} />
            <Route path="settings" element={<Settings />} />
          </Route>

          {/* Customer Routes */}
          <Route path="/customer" element={<CustomerLayout />}>
            <Route index element={<CustomerDashboard />} />
            <Route path="warranties" element={<CustomerWarranties />} />
            <Route path="complaints" element={<CustomerComplaints />} />
            <Route path="referrals" element={<CustomerReferrals />} />
            <Route path="settings" element={<Settings />} />
          </Route>
        </Routes>
      </BrowserRouter>
    </SearchContextProvider>
  );
}

export default App;
