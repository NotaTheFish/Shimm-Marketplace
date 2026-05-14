import { BrowserRouter, NavLink, Route, Routes } from "react-router-dom";
import { cn } from "@shimm/ui-kit";
import { Home } from "./routes/home.js";
import { Market } from "./routes/market.js";
import { Reviews } from "./routes/reviews.js";
import { Notifications } from "./routes/notifications.js";
import { Profile } from "./routes/profile.js";
import { Wallet } from "./routes/wallet.js";
import { Deals } from "./routes/deals.js";
import { Support } from "./routes/support.js";
import { Settings } from "./routes/settings.js";
import "./style.css";

const navClass = ({ isActive }: { isActive: boolean }) =>
  cn("nav-item", isActive ? "nav-item-active" : undefined);

export function App() {
  return (
    <BrowserRouter>
      <div className="layout">
        <header className="header">
          <NavLink to="/" className={navClass}>
            Home
          </NavLink>
          <NavLink to="/market" className={navClass}>
            Market
          </NavLink>
          <NavLink to="/deals" className={navClass}>
            Deals
          </NavLink>
          <NavLink to="/wallet" className={navClass}>
            Wallet
          </NavLink>
          <NavLink to="/reviews" className={navClass}>
            Reviews
          </NavLink>
          <NavLink to="/notifications" className={navClass}>
            Notifications
          </NavLink>
          <NavLink to="/profile" className={navClass}>
            Profile
          </NavLink>
          <NavLink to="/support" className={navClass}>
            Support
          </NavLink>
          <NavLink to="/settings" className={navClass}>
            Settings
          </NavLink>
        </header>
        <main className="main">
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/market" element={<Market />} />
            <Route path="/deals" element={<Deals />} />
            <Route path="/wallet" element={<Wallet />} />
            <Route path="/reviews" element={<Reviews />} />
            <Route path="/notifications" element={<Notifications />} />
            <Route path="/profile" element={<Profile />} />
            <Route path="/support" element={<Support />} />
            <Route path="/settings" element={<Settings />} />
          </Routes>
        </main>
      </div>
    </BrowserRouter>
  );
}
