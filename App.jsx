import { HashRouter as Router, Routes, Route } from 'react-router-dom';
import Storefront from './components/Storefront';
import AdminDashboard from './components/AdminDashboard';
import Login from './components/Login';

// Using HashRouter for GitHub Pages to avoid 404 on refresh
function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Storefront />} />
        <Route path="/admin" element={<AdminDashboard />} />
        <Route path="/login" element={<Login />} />
      </Routes>
    </Router>
  );
}

export default App;
