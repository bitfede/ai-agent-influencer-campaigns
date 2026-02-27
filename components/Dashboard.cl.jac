"""CampaignMind-style dashboard view."""

cl import from .Button { Button }

def:pub Dashboard(private_message: str, on_logout: any) -> JsxElement {
    return <div className="cm-root">
        <style>{"""
            :root {
                --bg: #080C10;
                --surface: #0D1318;
                --surface2: #121A22;
                --border: rgba(255,255,255,0.07);
                --accent: #00E5A0;
                --accent2: #0066FF;
                --accent3: #FF4560;
                --text: #E8EDF2;
                --muted: #5A6A7A;
                --warn: #FFB800;
            }
            .cm-root {
                background: var(--bg);
                color: var(--text);
                font-family: "Syne", Arial, sans-serif;
                min-height: 100vh;
                overflow-x: hidden;
            }
            .cm-root::before {
                content: "";
                position: fixed;
                inset: 0;
                background-image:
                    linear-gradient(rgba(0,229,160,0.015) 1px, transparent 1px),
                    linear-gradient(90deg, rgba(0,229,160,0.015) 1px, transparent 1px);
                background-size: 40px 40px;
                pointer-events: none;
                z-index: 0;
            }
            .cm-root::after {
                content: "";
                position: fixed;
                top: -200px;
                left: 50%;
                transform: translateX(-50%);
                width: 800px;
                height: 400px;
                background: radial-gradient(ellipse, rgba(0,229,160,0.06) 0%, transparent 70%);
                pointer-events: none;
                z-index: 0;
            }
            .sidebar {
                position: fixed;
                left: 0;
                top: 0;
                bottom: 0;
                width: 220px;
                background: var(--surface);
                border-right: 1px solid var(--border);
                display: flex;
                flex-direction: column;
                z-index: 10;
                padding: 28px 0;
            }
            .logo {
                padding: 0 24px 28px;
                border-bottom: 1px solid var(--border);
            }
            .logo-mark {
                font-size: 18px;
                font-weight: 800;
                letter-spacing: -0.5px;
                color: var(--text);
            }
            .logo-mark span { color: var(--accent); }
            .logo-sub {
                font-family: "DM Mono", monospace;
                font-size: 9px;
                color: var(--muted);
                letter-spacing: 2px;
                text-transform: uppercase;
                margin-top: 4px;
            }
            .nav {
                padding: 20px 12px;
                flex: 1;
                display: flex;
                flex-direction: column;
                gap: 2px;
            }
            .nav-label {
                font-family: "DM Mono", monospace;
                font-size: 9px;
                color: var(--muted);
                letter-spacing: 2px;
                text-transform: uppercase;
                padding: 0 12px;
                margin: 12px 0 6px;
            }
            .nav-item {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 10px 12px;
                border-radius: 8px;
                font-size: 13px;
                font-weight: 500;
                color: var(--muted);
                cursor: pointer;
                transition: all 0.15s;
                position: relative;
            }
            .nav-item:hover { background: var(--surface2); color: var(--text); }
            .nav-item.active {
                background: rgba(0,229,160,0.08);
                color: var(--accent);
            }
            .nav-item.active::before {
                content: "";
                position: absolute;
                left: 0;
                top: 50%;
                transform: translateY(-50%);
                width: 3px;
                height: 20px;
                background: var(--accent);
                border-radius: 0 3px 3px 0;
            }
            .nav-icon { font-size: 15px; width: 18px; text-align: center; }
            .nav-badge {
                margin-left: auto;
                background: var(--accent);
                color: #000;
                font-size: 9px;
                font-weight: 700;
                padding: 2px 6px;
                border-radius: 20px;
                font-family: "DM Mono", monospace;
            }
            .sidebar-bottom {
                padding: 20px 12px 0;
                border-top: 1px solid var(--border);
            }
            .wallet-card {
                background: var(--surface2);
                border: 1px solid var(--border);
                border-radius: 10px;
                padding: 12px;
            }
            .wallet-label {
                font-family: "DM Mono", monospace;
                font-size: 9px;
                color: var(--muted);
                letter-spacing: 1.5px;
                text-transform: uppercase;
            }
            .wallet-balance {
                font-size: 20px;
                font-weight: 700;
                color: var(--accent);
                margin: 4px 0 2px;
                letter-spacing: -0.5px;
            }
            .wallet-addr {
                font-family: "DM Mono", monospace;
                font-size: 9px;
                color: var(--muted);
            }
            .main {
                margin-left: 220px;
                min-height: 100vh;
                position: relative;
                z-index: 1;
            }
            .topbar {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 20px 36px;
                border-bottom: 1px solid var(--border);
                background: rgba(8,12,16,0.8);
                backdrop-filter: blur(10px);
                position: sticky;
                top: 0;
                z-index: 5;
            }
            .topbar-left h1 {
                font-size: 20px;
                font-weight: 700;
                letter-spacing: -0.3px;
            }
            .topbar-left p {
                font-size: 12px;
                color: var(--muted);
                font-family: "DM Mono", monospace;
                margin-top: 2px;
            }
            .topbar-right { display: flex; align-items: center; gap: 12px; }
            .status-pill {
                display: flex;
                align-items: center;
                gap: 7px;
                background: rgba(0,229,160,0.08);
                border: 1px solid rgba(0,229,160,0.2);
                border-radius: 20px;
                padding: 6px 14px;
                font-size: 11px;
                font-weight: 600;
                color: var(--accent);
                font-family: "DM Mono", monospace;
            }
            .status-dot {
                width: 7px;
                height: 7px;
                border-radius: 50%;
                background: var(--accent);
                box-shadow: 0 0 8px var(--accent);
                animation: pulse 2s infinite;
            }
            @keyframes pulse {
                0%, 100% { opacity: 1; transform: scale(1); }
                50% { opacity: 0.6; transform: scale(0.85); }
            }
            .avatar {
                width: 36px;
                height: 36px;
                border-radius: 50%;
                background: linear-gradient(135deg, var(--accent2), var(--accent));
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 13px;
                font-weight: 700;
                cursor: pointer;
            }
            .content { padding: 32px 36px; }
            .launch-hero {
                background: linear-gradient(135deg, rgba(0,229,160,0.05) 0%, rgba(0,102,255,0.05) 100%);
                border: 1px solid rgba(0,229,160,0.15);
                border-radius: 16px;
                padding: 36px 40px;
                margin-bottom: 28px;
                position: relative;
                overflow: hidden;
            }
            .launch-hero::before {
                content: "";
                position: absolute;
                top: -60px;
                right: -60px;
                width: 250px;
                height: 250px;
                background: radial-gradient(circle, rgba(0,229,160,0.08), transparent 70%);
                pointer-events: none;
            }
            .hero-tag {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                background: rgba(0,229,160,0.1);
                border: 1px solid rgba(0,229,160,0.25);
                border-radius: 20px;
                padding: 4px 12px;
                font-family: "DM Mono", monospace;
                font-size: 10px;
                color: var(--accent);
                letter-spacing: 1px;
                text-transform: uppercase;
                margin-bottom: 16px;
            }
            .hero-title {
                font-size: 30px;
                font-weight: 800;
                letter-spacing: -1px;
                line-height: 1.1;
                margin-bottom: 10px;
            }
            .hero-title span { color: var(--accent); }
            .hero-sub {
                font-size: 13px;
                color: var(--muted);
                max-width: 520px;
                line-height: 1.6;
                margin-bottom: 28px;
            }
            .hero-actions { display: flex; align-items: center; gap: 12px; }
            .btn-primary {
                display: flex;
                align-items: center;
                gap: 8px;
                background: var(--accent);
                color: #000;
                font-family: "Syne", sans-serif;
                font-size: 13px;
                font-weight: 700;
                padding: 12px 24px;
                border-radius: 10px;
                border: none;
                cursor: pointer;
                transition: all 0.2s;
                letter-spacing: 0.2px;
            }
            .btn-primary:hover {
                background: #00ffb3;
                transform: translateY(-1px);
                box-shadow: 0 8px 24px rgba(0,229,160,0.3);
            }
            .btn-secondary {
                display: flex;
                align-items: center;
                gap: 8px;
                background: transparent;
                color: var(--text);
                font-family: "Syne", sans-serif;
                font-size: 13px;
                font-weight: 600;
                padding: 12px 24px;
                border-radius: 10px;
                border: 1px solid var(--border);
                cursor: pointer;
                transition: all 0.2s;
            }
            .btn-secondary:hover { border-color: rgba(255,255,255,0.2); background: var(--surface2); }
            .stats-row {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 16px;
                margin-bottom: 28px;
            }
            .stat-card {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: 12px;
                padding: 20px;
                position: relative;
                overflow: hidden;
                transition: border-color 0.2s;
            }
            .stat-card:hover { border-color: rgba(255,255,255,0.15); }
            .stat-card::after {
                content: "";
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                height: 2px;
            }
            .stat-card.green::after { background: linear-gradient(90deg, var(--accent), transparent); }
            .stat-card.blue::after { background: linear-gradient(90deg, var(--accent2), transparent); }
            .stat-card.red::after { background: linear-gradient(90deg, var(--accent3), transparent); }
            .stat-card.yellow::after { background: linear-gradient(90deg, var(--warn), transparent); }
            .stat-label {
                font-family: "DM Mono", monospace;
                font-size: 10px;
                color: var(--muted);
                letter-spacing: 1.5px;
                text-transform: uppercase;
                margin-bottom: 10px;
            }
            .stat-value {
                font-size: 28px;
                font-weight: 800;
                letter-spacing: -1px;
                line-height: 1;
                margin-bottom: 6px;
            }
            .stat-card.green .stat-value { color: var(--accent); }
            .stat-card.blue .stat-value { color: var(--accent2); }
            .stat-card.red .stat-value { color: var(--accent3); }
            .stat-card.yellow .stat-value { color: var(--warn); }
            .stat-change {
                font-size: 11px;
                color: var(--muted);
                font-family: "DM Mono", monospace;
            }
            .two-col {
                display: grid;
                grid-template-columns: 1fr 380px;
                gap: 20px;
                margin-bottom: 28px;
            }
            .form-card {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: 14px;
                overflow: hidden;
            }
            .card-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 20px 24px;
                border-bottom: 1px solid var(--border);
            }
            .card-title {
                font-size: 14px;
                font-weight: 700;
                letter-spacing: -0.2px;
            }
            .card-tag {
                font-family: "DM Mono", monospace;
                font-size: 9px;
                letter-spacing: 1.5px;
                text-transform: uppercase;
                color: var(--muted);
                background: var(--surface2);
                padding: 4px 10px;
                border-radius: 6px;
            }
            .form-body { padding: 24px; }
            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 14px;
                margin-bottom: 14px;
            }
            .form-group { display: flex; flex-direction: column; gap: 7px; }
            .form-group.full { grid-column: 1 / -1; }
            .form-label {
                font-size: 11px;
                font-weight: 600;
                color: var(--muted);
                letter-spacing: 0.5px;
                font-family: "DM Mono", monospace;
                text-transform: uppercase;
            }
            .form-input, .form-select, .form-textarea {
                background: var(--surface2);
                border: 1px solid var(--border);
                border-radius: 8px;
                padding: 10px 14px;
                font-family: "Syne", sans-serif;
                font-size: 13px;
                color: var(--text);
                outline: none;
                transition: border-color 0.15s;
                width: 100%;
            }
            .form-input:focus, .form-select:focus, .form-textarea:focus {
                border-color: rgba(0,229,160,0.4);
                box-shadow: 0 0 0 3px rgba(0,229,160,0.06);
            }
            .form-input::placeholder { color: var(--muted); }
            .form-select option { background: var(--surface2); }
            .form-textarea { resize: none; height: 80px; line-height: 1.5; }
            .budget-row {
                display: flex;
                align-items: center;
                gap: 10px;
                background: var(--surface2);
                border: 1px solid var(--border);
                border-radius: 8px;
                padding: 10px 14px;
                transition: border-color 0.15s;
            }
            .budget-row:focus-within {
                border-color: rgba(0,229,160,0.4);
                box-shadow: 0 0 0 3px rgba(0,229,160,0.06);
            }
            .budget-currency {
                font-family: "DM Mono", monospace;
                font-size: 11px;
                font-weight: 500;
                color: var(--accent);
                background: rgba(0,229,160,0.1);
                padding: 3px 8px;
                border-radius: 5px;
                white-space: nowrap;
            }
            .budget-input {
                background: transparent;
                border: none;
                font-family: "Syne", sans-serif;
                font-size: 13px;
                color: var(--text);
                outline: none;
                flex: 1;
                width: 100%;
            }
            .budget-input::placeholder { color: var(--muted); }
            .tags-row { display: flex; gap: 8px; flex-wrap: wrap; margin-top: 4px; }
            .tag {
                display: flex;
                align-items: center;
                gap: 6px;
                background: rgba(0,102,255,0.1);
                border: 1px solid rgba(0,102,255,0.2);
                border-radius: 6px;
                padding: 5px 10px;
                font-size: 11px;
                font-weight: 600;
                color: #6699FF;
                cursor: pointer;
                transition: all 0.15s;
            }
            .tag:hover, .tag.selected {
                background: rgba(0,102,255,0.2);
                border-color: rgba(0,102,255,0.4);
            }
            .tag-x { opacity: 0.5; font-size: 13px; line-height: 1; }
            .form-footer {
                padding: 16px 24px;
                border-top: 1px solid var(--border);
                display: flex;
                align-items: center;
                justify-content: space-between;
            }
            .form-note {
                font-family: "DM Mono", monospace;
                font-size: 10px;
                color: var(--muted);
            }
            .activity-card {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: 14px;
                overflow: hidden;
            }
            .activity-list { padding: 8px 0; }
            .activity-item {
                display: flex;
                align-items: flex-start;
                gap: 12px;
                padding: 14px 20px;
                border-bottom: 1px solid var(--border);
                transition: background 0.15s;
                cursor: default;
            }
            .activity-item:last-child { border-bottom: none; }
            .activity-item:hover { background: rgba(255,255,255,0.02); }
            .activity-icon {
                width: 32px;
                height: 32px;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 14px;
                flex-shrink: 0;
                margin-top: 1px;
            }
            .activity-icon.green { background: rgba(0,229,160,0.1); }
            .activity-icon.blue { background: rgba(0,102,255,0.1); }
            .activity-icon.red { background: rgba(255,69,96,0.1); }
            .activity-icon.yellow { background: rgba(255,184,0,0.1); }
            .activity-text { flex: 1; }
            .activity-title {
                font-size: 12px;
                font-weight: 600;
                margin-bottom: 3px;
            }
            .activity-desc {
                font-size: 11px;
                color: var(--muted);
                font-family: "DM Mono", monospace;
                line-height: 1.4;
            }
            .activity-time {
                font-family: "DM Mono", monospace;
                font-size: 10px;
                color: var(--muted);
                white-space: nowrap;
                margin-top: 2px;
            }
            .table-card {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: 14px;
                overflow: hidden;
            }
            table { width: 100%; border-collapse: collapse; }
            thead th {
                font-family: "DM Mono", monospace;
                font-size: 10px;
                color: var(--muted);
                letter-spacing: 1.5px;
                text-transform: uppercase;
                padding: 14px 20px;
                text-align: left;
                border-bottom: 1px solid var(--border);
                background: var(--surface2);
            }
            tbody tr {
                border-bottom: 1px solid var(--border);
                transition: background 0.15s;
                cursor: pointer;
            }
            tbody tr:last-child { border-bottom: none; }
            tbody tr:hover { background: rgba(255,255,255,0.02); }
            td { padding: 16px 20px; font-size: 13px; }
            .campaign-name { font-weight: 600; }
            .campaign-brand {
                font-size: 11px;
                color: var(--muted);
                font-family: "DM Mono", monospace;
                margin-top: 2px;
            }
            .badge {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                font-family: "DM Mono", monospace;
                font-size: 10px;
                font-weight: 500;
                padding: 4px 10px;
                border-radius: 6px;
                white-space: nowrap;
            }
            .badge-dot { width: 5px; height: 5px; border-radius: 50%; }
            .badge.running { background: rgba(0,229,160,0.1); color: var(--accent); }
            .badge.running .badge-dot { background: var(--accent); }
            .badge.pending { background: rgba(255,184,0,0.1); color: var(--warn); }
            .badge.pending .badge-dot { background: var(--warn); }
            .badge.done { background: rgba(90,106,122,0.15); color: var(--muted); }
            .badge.done .badge-dot { background: var(--muted); }
            .progress-bar {
                width: 100px;
                height: 4px;
                background: var(--surface2);
                border-radius: 4px;
                overflow: hidden;
            }
            .progress-fill {
                height: 100%;
                background: var(--accent);
                border-radius: 4px;
                transition: width 0.3s;
            }
            .progress-fill.blue { background: var(--accent2); }
            .progress-fill.muted { background: var(--muted); }
            .amount {
                font-family: "DM Mono", monospace;
                font-size: 12px;
                font-weight: 500;
            }
            .amount.green { color: var(--accent); }
            .amount.muted { color: var(--muted); }
            .fade-in { animation: fadeIn 0.4s ease forwards; opacity: 0; }
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(8px); }
                to { opacity: 1; transform: translateY(0); }
            }
            .fade-in:nth-child(1) { animation-delay: 0.05s; }
            .fade-in:nth-child(2) { animation-delay: 0.1s; }
            .fade-in:nth-child(3) { animation-delay: 0.15s; }
            .fade-in:nth-child(4) { animation-delay: 0.2s; }
            .fade-in:nth-child(5) { animation-delay: 0.25s; }
            @media (max-width: 1100px) {
                .stats-row { grid-template-columns: repeat(2, 1fr); }
                .two-col { grid-template-columns: 1fr; }
            }
            @media (max-width: 860px) {
                .sidebar {
                    position: static;
                    width: 100%;
                    flex-direction: row;
                    flex-wrap: wrap;
                    padding: 16px;
                    gap: 12px;
                }
                .nav, .sidebar-bottom { display: none; }
                .main { margin-left: 0; }
            }
            @media (max-width: 640px) {
                .topbar { padding: 16px; flex-direction: column; align-items: flex-start; gap: 12px; }
                .content { padding: 20px 16px; }
                .stats-row { grid-template-columns: 1fr; }
                .hero-title { font-size: 24px; }
            }
        """}</style>
        <aside className="sidebar">
            <div className="logo">
                <div className="logo-mark">Campaign<span>Mind</span></div>
                <div className="logo-sub">Autonomous Agent v1.0</div>
            </div>
            <nav className="nav">
                <div className="nav-label">Main</div>
                <div className="nav-item active">
                    <span className="nav-icon">⚡</span>
                    Dashboard
                </div>
                <div className="nav-item">
                    <span className="nav-icon">📡</span>
                    Campaigns
                    <span className="nav-badge">3</span>
                </div>
                <div className="nav-item">
                    <span className="nav-icon">🔍</span>
                    KOL Discovery
                </div>
                <div className="nav-item">
                    <span className="nav-icon">✅</span>
                    Vetting Queue
                    <span className="nav-badge">7</span>
                </div>
                <div className="nav-label">Finance</div>
                <div className="nav-item">
                    <span className="nav-icon">💸</span>
                    Payments
                </div>
                <div className="nav-item">
                    <span className="nav-icon">🔗</span>
                    On-Chain Log
                </div>
                <div className="nav-label">Settings</div>
                <div className="nav-item">
                    <span className="nav-icon">⚙️</span>
                    Agent Config
                </div>
            </nav>
            <div className="sidebar-bottom">
                <div className="wallet-card">
                    <div className="wallet-label">Agent Wallet</div>
                    <div className="wallet-balance">$47,200</div>
                    <div className="wallet-addr">0x4f2a...c91b · Base</div>
                </div>
            </div>
        </aside>
        <main className="main">
            <header className="topbar">
                <div className="topbar-left">
                    <h1>Command Center</h1>
                    <p>FEB 27, 2026 · 14:32 EST</p>
                </div>
                <div className="topbar-right">
                    <div className="status-pill">
                        <div className="status-dot"></div>
                        AGENT ACTIVE
                    </div>
                    <div className="avatar">E</div>
                    <Button label="Sign out" onClick={on_logout} variant="secondary" />
                </div>
            </header>
            <div className="content">
                <div className="launch-hero fade-in">
                    <div className="hero-tag">⚡ New Campaign</div>
                    <h2 className="hero-title">Launch your next<br /><span>autonomous campaign</span></h2>
                    <p className="hero-sub">
                        Deposit budget, define your goals, and let the agent handle everything —
                        KOL discovery, vetting, outreach, verification, and USDC payments.
                    </p>
                    <div className="hero-actions">
                        <button className="btn-primary">🚀 Start New Campaign</button>
                        <button className="btn-secondary">📄 View Templates</button>
                    </div>
                </div>
                <div className="stats-row">
                    <div className="stat-card green fade-in">
                        <div className="stat-label">USDC Distributed</div>
                        <div className="stat-value">$128K</div>
                        <div className="stat-change">+$14,200 this week</div>
                    </div>
                    <div className="stat-card blue fade-in">
                        <div className="stat-label">KOLs Vetted</div>
                        <div className="stat-value">847</div>
                        <div className="stat-change">312 approved · 535 rejected</div>
                    </div>
                    <div className="stat-card red fade-in">
                        <div className="stat-label">Rugs Avoided</div>
                        <div className="stat-value">63</div>
                        <div className="stat-change">$89K saved in bad hires</div>
                    </div>
                    <div className="stat-card yellow fade-in">
                        <div className="stat-label">Active Campaigns</div>
                        <div className="stat-value">3</div>
                        <div className="stat-change">2 in execution · 1 pending</div>
                    </div>
                </div>
                <div className="two-col">
                    <div className="form-card fade-in">
                        <div className="card-header">
                            <div className="card-title">Quick Campaign Brief</div>
                            <div className="card-tag">Step 1 of 3</div>
                        </div>
                        <div className="form-body">
                            <div className="form-row">
                                <div className="form-group">
                                    <label className="form-label">Brand / Project</label>
                                    <input className="form-input" type="text" value="MoltX Protocol" />
                                </div>
                                <div className="form-group">
                                    <label className="form-label">Campaign Goal</label>
                                    <select className="form-select">
                                        <option>Product Launch</option>
                                        <option>Community Growth</option>
                                        <option>Brand Awareness</option>
                                        <option>Token TGE</option>
                                    </select>
                                </div>
                            </div>
                            <div className="form-row">
                                <div className="form-group">
                                    <label className="form-label">Budget (USDC)</label>
                                    <div className="budget-row">
                                        <span className="budget-currency">USDC</span>
                                        <input className="budget-input" type="text" value="15,000" />
                                    </div>
                                </div>
                                <div className="form-group">
                                    <label className="form-label">Timeline</label>
                                    <select className="form-select">
                                        <option>14 days</option>
                                        <option>7 days</option>
                                        <option>30 days</option>
                                        <option>Custom</option>
                                    </select>
                                </div>
                            </div>
                            <div className="form-row">
                                <div className="form-group full">
                                    <label className="form-label">Target Audience</label>
                                    <div className="tags-row">
                                        <div className="tag selected">Base Ecosystem <span className="tag-x">×</span></div>
                                        <div className="tag selected">DeFi Users <span className="tag-x">×</span></div>
                                        <div className="tag selected">AI Enthusiasts <span className="tag-x">×</span></div>
                                        <div className="tag">+ Add</div>
                                    </div>
                                </div>
                            </div>
                            <div className="form-row">
                                <div className="form-group full">
                                    <label className="form-label">Campaign Brief</label>
                                    <textarea className="form-textarea">
                                        Launching MoltX agent staking feature. KOLs must cover Base ecosystem.
                                        No competing AI agent protocols.
                                    </textarea>
                                </div>
                            </div>
                            <div className="form-row">
                                <div className="form-group">
                                    <label className="form-label">Content Type</label>
                                    <select className="form-select">
                                        <option>Twitter Threads</option>
                                        <option>Short Videos</option>
                                        <option>Twitter + Video</option>
                                        <option>UGC Only</option>
                                    </select>
                                </div>
                                <div className="form-group">
                                    <label className="form-label">Min KOL Score</label>
                                    <select className="form-select">
                                        <option>65 / 100 (Recommended)</option>
                                        <option>75 / 100 (Strict)</option>
                                        <option>50 / 100 (Lenient)</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div className="form-footer">
                            <div className="form-note">Agent will discover & vet KOLs via Influur</div>
                            <button className="btn-primary">Continue →</button>
                        </div>
                    </div>
                    <div className="activity-card fade-in">
                        <div className="card-header">
                            <div className="card-title">Agent Activity</div>
                            <div className="card-tag">Live</div>
                        </div>
                        <div className="activity-list">
                            <div className="activity-item">
                                <div className="activity-icon green">💸</div>
                                <div className="activity-text">
                                    <div className="activity-title">Payment Released</div>
                                    <div className="activity-desc">$6,000 USDC → @cryptoKOL_A<br />Content verified ✓</div>
                                </div>
                                <div className="activity-time">2m ago</div>
                            </div>
                            <div className="activity-item">
                                <div className="activity-icon blue">✅</div>
                                <div className="activity-text">
                                    <div className="activity-title">Content Approved</div>
                                    <div className="activity-desc">@defi_maven post verified<br />Brief match: 94%</div>
                                </div>
                                <div className="activity-time">18m ago</div>
                            </div>
                            <div className="activity-item">
                                <div className="activity-icon red">⛔</div>
                                <div className="activity-text">
                                    <div className="activity-title">KOL Rejected</div>
                                    <div className="activity-desc">@pump_king scored 28/100<br />Reason: 2 rug promotions</div>
                                </div>
                                <div className="activity-time">34m ago</div>
                            </div>
                            <div className="activity-item">
                                <div className="activity-icon yellow">📨</div>
                                <div className="activity-text">
                                    <div className="activity-title">Outreach Sent</div>
                                    <div className="activity-desc">7 personalized DMs sent<br />Awaiting KOL responses</div>
                                </div>
                                <div className="activity-time">1h ago</div>
                            </div>
                            <div className="activity-item">
                                <div className="activity-icon green">🔍</div>
                                <div className="activity-text">
                                    <div className="activity-title">Discovery Complete</div>
                                    <div className="activity-desc">31 candidates found via Influur<br />9 approved · 22 rejected</div>
                                </div>
                                <div className="activity-time">2h ago</div>
                            </div>
                            <div className="activity-item">
                                <div className="activity-icon blue">💰</div>
                                <div className="activity-text">
                                    <div className="activity-title">Budget Deposited</div>
                                    <div className="activity-desc">$15,000 USDC locked in escrow<br />Tx: 0x9c1b...44fa</div>
                                </div>
                                <div className="activity-time">2h ago</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="table-card fade-in">
                    <div className="card-header">
                        <div className="card-title">Active Campaigns</div>
                        <button className="btn-secondary" style={{"padding": "8px 16px", "fontSize": "12px"}}>View All →</button>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>Campaign</th>
                                <th>Status</th>
                                <th>KOLs</th>
                                <th>Progress</th>
                                <th>Budget</th>
                                <th>Distributed</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <div className="campaign-name">Agent Staking Launch</div>
                                    <div className="campaign-brand">MoltX Protocol</div>
                                </td>
                                <td><span className="badge running"><span className="badge-dot"></span>Running</span></td>
                                <td>9 / 9</td>
                                <td><div className="progress-bar"><div className="progress-fill" style={{"width": "65%"}}></div></div></td>
                                <td><span className="amount muted">$15,000</span></td>
                                <td><span className="amount green">$9,750</span></td>
                            </tr>
                            <tr>
                                <td>
                                    <div className="campaign-name">Community Growth Q1</div>
                                    <div className="campaign-brand">Avantis Protocol</div>
                                </td>
                                <td><span className="badge pending"><span className="badge-dot"></span>Pending Approval</span></td>
                                <td>12 / 12</td>
                                <td><div className="progress-bar"><div className="progress-fill blue" style={{"width": "20%"}}></div></div></td>
                                <td><span className="amount muted">$22,000</span></td>
                                <td><span className="amount green">$0</span></td>
                            </tr>
                            <tr>
                                <td>
                                    <div className="campaign-name">TGE Awareness Push</div>
                                    <div className="campaign-brand">Base Ecosystem Fund</div>
                                </td>
                                <td><span className="badge done"><span className="badge-dot"></span>Complete</span></td>
                                <td>6 / 6</td>
                                <td><div className="progress-bar"><div className="progress-fill muted" style={{"width": "100%"}}></div></div></td>
                                <td><span className="amount muted">$10,200</span></td>
                                <td><span className="amount green">$10,200</span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div style={{
                    "marginTop": "24px",
                    "fontSize": "12px",
                    "color": "var(--muted)"
                }}>
                    {private_message}
                </div>
            </div>
        </main>
    </div>;
}
