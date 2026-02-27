"""ProposalView — campaign proposal review for judges / brand approval."""

cl import from .Button { Button }

def:pub ProposalView(
    campaign: dict,
    on_approve: any,
    on_back: any
) -> JsxElement {
    has show_rejected: bool = False;

    # ── extract campaign fields ──
    brand_name = campaign["brand_name"] or "Campaign";
    goal = campaign["goal"] or "";
    budget = campaign["budget_usdc"] or 0;
    mode = campaign["mode"] or "web3";
    timeline_days = campaign["timeline_days"] or 14;
    approved_kols = campaign["approved_kols"] or [];
    rejected_kols = campaign["rejected_kols"] or [];
    proposal = campaign["proposal"] or {};

    kol_roster = proposal["kol_roster"] or [];
    timeline = proposal["timeline"] or [];
    summary = proposal["campaign_summary"] or "No summary available.";
    recommendation = proposal["agent_recommendation"] or "";
    total_reach = proposal["total_expected_reach"] or 0;
    total_approved = proposal["total_approved"] or len(approved_kols);
    total_rejected_count = proposal["total_rejected"] or len(rejected_kols);

    # ── budget amounts ──
    t1_amount = budget * 0.4;
    t2_amount = budget * 0.4;
    t3_amount = budget * 0.2;

    # ── pre-compute mode badge styles ──
    mode_bg = "";
    mode_fg = "";
    mode_border = "";
    mode_text = "";
    if (mode == "web3") {
        mode_bg = "rgba(0,229,160,0.1)";
        mode_fg = "#00E5A0";
        mode_border = "1px solid rgba(0,229,160,0.25)";
        mode_text = "⬡ Web3";
    } else {
        mode_bg = "rgba(138,43,226,0.1)";
        mode_fg = "#B366FF";
        mode_border = "1px solid rgba(138,43,226,0.25)";
        mode_text = "◈ Web2";
    }

    # ── format reach ──
    reach_str = "";
    if (total_reach >= 1000000) {
        reach_str = str(total_reach / 1000000) + "M";
    } elif (total_reach >= 1000) {
        reach_str = str(total_reach / 1000) + "k";
    } else {
        reach_str = str(total_reach);
    }

    topbar_meta = "$" + str(budget) + " USDC · " + str(timeline_days) + " days";
    approved_pill = "✓ " + str(total_approved) + " KOLs Approved";
    rejected_pill = "✗ " + str(total_rejected_count) + " Rejected";
    reach_pill = "📊 " + reach_str + " Est. Reach";
    roster_count = str(len(kol_roster)) + " selected";
    budget_total_str = "$" + str(budget) + " USDC";
    timeline_tag = str(timeline_days) + " days";
    bottom_info_str = "Total: $" + str(budget) + " USDC · " + str(total_approved) + " KOLs · Est. " + reach_str + " impressions";
    rejected_toggle_str = "";
    if (show_rejected) {
        rejected_toggle_str = "▼ Rejected KOLs (" + str(len(rejected_kols)) + ")";
    } else {
        rejected_toggle_str = "▶ Rejected KOLs (" + str(len(rejected_kols)) + ")";
    }

    # ── build roster rows ──
    roster_rows: list = [];
    for entry in kol_roster {
        kol_score = 0;
        entry_handle = entry["handle"] or "";
        for ak in approved_kols {
            ak_handle = ak["handle"] or "";
            if (ak_handle == entry_handle) {
                kol_score = ak["score"] or 0;
                break;
            }
        }
        t = entry["tier"] or "tier_3";
        # tier color
        tc = "#5A6A7A";
        if (t == "tier_1") { tc = "#FFB800"; }
        if (t == "tier_2") { tc = "#0066FF"; }
        # tier label
        tl = "Tier 3";
        if (t == "tier_1") { tl = "★ Tier 1"; }
        if (t == "tier_2") { tl = "Tier 2"; }
        # score color
        sbg = "rgba(255,184,0,0.15)";
        sfg = "#FFB800";
        if (kol_score >= 90) {
            sbg = "rgba(0,229,160,0.15)";
            sfg = "#00E5A0";
        } elif (kol_score >= 70) {
            sbg = "rgba(0,102,255,0.15)";
            sfg = "#0066FF";
        }
        # reach format
        er = entry["expected_reach"] or 0;
        er_str = str(er);
        if (er >= 1000000) {
            er_str = str(er / 1000000) + "M";
        } elif (er >= 1000) {
            er_str = str(er / 1000) + "k";
        }
        entry_budget = entry["budget_usdc"] or 0;
        budget_str = "$" + str(entry_budget);
        entry_role = entry["role"] or "Campaign contributor";
        roster_rows.append(
            <tr style={{"borderLeft": "3px solid " + tc}}>
                <td style={{"fontWeight": "700"}}>{entry_handle}</td>
                <td>
                    <span style={{
                        "background": sbg,
                        "color": sfg,
                        "fontFamily": "DM Mono, monospace",
                        "fontSize": "11px",
                        "fontWeight": "700",
                        "padding": "4px 10px",
                        "borderRadius": "6px"
                    }}>{str(kol_score)}</span>
                </td>
                <td>
                    <span style={{
                        "border": "1px solid " + tc,
                        "color": tc,
                        "fontFamily": "DM Mono, monospace",
                        "fontSize": "10px",
                        "fontWeight": "600",
                        "padding": "3px 10px",
                        "borderRadius": "20px"
                    }}>{tl}</span>
                </td>
                <td style={{"color": "#8A95A3", "fontSize": "12px"}}>
                    {entry_role}
                </td>
                <td style={{
                    "fontFamily": "DM Mono, monospace",
                    "fontSize": "12px",
                    "fontWeight": "600",
                    "color": "#00E5A0"
                }}>{budget_str}</td>
                <td style={{
                    "fontFamily": "DM Mono, monospace",
                    "fontSize": "12px",
                    "color": "#5A6A7A"
                }}>{er_str}</td>
            </tr>
        );
    }

    # ── build rejected rows ──
    rejected_rows: list = [];
    for rk in rejected_kols {
        rk_handle = rk["handle"] or "";
        rk_score = rk["score"] or 0;
        rk_reason = rk["rejection_reason"] or "Below threshold";
        rk_score_str = str(rk_score) + "/100";
        rejected_rows.append(
            <div className="pv-rejected-item">
                <div className="pv-rejected-handle">
                    {rk_handle}
                    <span style={{
                        "fontFamily": "DM Mono, monospace",
                        "fontSize": "10px",
                        "color": "#FF4560",
                        "marginLeft": "6px"
                    }}>{rk_score_str}</span>
                </div>
                <div className="pv-rejected-reason">
                    {rk_reason}
                </div>
            </div>
        );
    }

    # ── build timeline rows ──
    timeline_rows: list = [];
    idx = 0;
    for entry in timeline {
        dot_color = "#00E5A0";
        if (idx % 2 != 0) {
            dot_color = "#0066FF";
        }
        entry_day = entry["day"] or "";
        entry_action = entry["action"] or "";
        day_label = "Day " + str(entry_day);
        timeline_rows.append(
            <div className="pv-timeline-item">
                <div style={{"position": "relative"}}>
                    <div className="pv-timeline-dot" style={{"background": dot_color}}></div>
                    <div className="pv-timeline-line"></div>
                </div>
                <div className="pv-timeline-day">{day_label}</div>
                <div className="pv-timeline-action">{entry_action}</div>
            </div>
        );
        idx = idx + 1;
    }

    return <div className="pv-root">
        <style>{"""
            .pv-root {
                background: var(--bg, #080C10);
                color: var(--text, #E8EDF2);
                font-family: "Syne", Arial, sans-serif;
                min-height: 100vh;
                overflow-x: hidden;
                position: relative;
                padding-bottom: 80px;
            }
            .pv-root::before {
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
            .pv-topbar {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 18px 36px;
                border-bottom: 1px solid rgba(255,255,255,0.07);
                background: rgba(8,12,16,0.85);
                backdrop-filter: blur(10px);
                position: sticky;
                top: 0;
                z-index: 20;
            }
            .pv-topbar-left {
                display: flex;
                align-items: center;
                gap: 14px;
            }
            .pv-back-btn {
                background: rgba(255,255,255,0.06);
                border: 1px solid rgba(255,255,255,0.1);
                color: #E8EDF2;
                font-size: 16px;
                width: 36px;
                height: 36px;
                border-radius: 10px;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.15s;
            }
            .pv-back-btn:hover {
                background: rgba(255,255,255,0.1);
                border-color: rgba(255,255,255,0.2);
            }
            .pv-topbar-title {
                font-size: 18px;
                font-weight: 700;
                letter-spacing: -0.3px;
            }
            .pv-topbar-goal {
                font-size: 12px;
                color: #5A6A7A;
                font-family: "DM Mono", monospace;
                margin-top: 1px;
            }
            .pv-mode-badge {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                font-family: "DM Mono", monospace;
                font-size: 11px;
                font-weight: 600;
                padding: 6px 14px;
                border-radius: 20px;
            }
            .pv-topbar-meta {
                font-family: "DM Mono", monospace;
                font-size: 13px;
                color: #E8EDF2;
                letter-spacing: -0.3px;
            }
            .pv-content {
                padding: 28px 36px;
                position: relative;
                z-index: 1;
            }
            .pv-summary { margin-bottom: 24px; }
            .pv-summary-text {
                font-size: 14px;
                line-height: 1.7;
                color: #C0C8D2;
                margin-bottom: 16px;
            }
            .pv-pills {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
            }
            .pv-pill {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                font-family: "DM Mono", monospace;
                font-size: 11px;
                font-weight: 600;
                padding: 6px 14px;
                border-radius: 20px;
            }
            .pv-grid {
                display: grid;
                grid-template-columns: 65fr 35fr;
                gap: 20px;
                margin-bottom: 24px;
            }
            .pv-card {
                background: #0D1318;
                border: 1px solid rgba(255,255,255,0.07);
                border-radius: 14px;
                overflow: hidden;
            }
            .pv-card-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 18px 22px;
                border-bottom: 1px solid rgba(255,255,255,0.07);
            }
            .pv-card-title {
                font-size: 14px;
                font-weight: 700;
                letter-spacing: -0.2px;
            }
            .pv-card-tag {
                font-family: "DM Mono", monospace;
                font-size: 9px;
                letter-spacing: 1.5px;
                text-transform: uppercase;
                color: #5A6A7A;
                background: #121A22;
                padding: 4px 10px;
                border-radius: 6px;
            }
            .pv-card-body { padding: 20px 22px; }
            .pv-table { width: 100%; border-collapse: collapse; }
            .pv-table thead th {
                font-family: "DM Mono", monospace;
                font-size: 10px;
                color: #5A6A7A;
                letter-spacing: 1.5px;
                text-transform: uppercase;
                padding: 13px 18px;
                text-align: left;
                border-bottom: 1px solid rgba(255,255,255,0.07);
                background: #121A22;
            }
            .pv-table tbody tr {
                border-bottom: 1px solid rgba(255,255,255,0.05);
                transition: background 0.15s;
            }
            .pv-table tbody tr:last-child { border-bottom: none; }
            .pv-table tbody tr:hover { background: rgba(255,255,255,0.02); }
            .pv-table td {
                padding: 14px 18px;
                font-size: 13px;
                vertical-align: middle;
            }
            .pv-rejected-toggle {
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 14px 22px;
                cursor: pointer;
                font-size: 13px;
                font-weight: 600;
                color: #5A6A7A;
                transition: color 0.15s;
                user-select: none;
                border-top: 1px solid rgba(255,255,255,0.05);
            }
            .pv-rejected-toggle:hover { color: #FF4560; }
            .pv-rejected-item {
                display: flex;
                align-items: flex-start;
                gap: 12px;
                padding: 12px 22px;
                border-left: 3px solid #FF4560;
                margin: 0 22px 8px;
                background: rgba(255,69,96,0.04);
                border-radius: 0 8px 8px 0;
            }
            .pv-rejected-handle {
                font-weight: 600;
                font-size: 13px;
                color: #FF4560;
                min-width: 140px;
            }
            .pv-rejected-reason {
                font-size: 12px;
                color: #5A6A7A;
                line-height: 1.5;
            }
            .pv-budget-row {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 14px;
            }
            .pv-budget-label {
                font-family: "DM Mono", monospace;
                font-size: 11px;
                color: #E8EDF2;
                min-width: 90px;
            }
            .pv-budget-bar-track {
                flex: 1;
                height: 8px;
                background: #121A22;
                border-radius: 4px;
                overflow: hidden;
            }
            .pv-budget-bar-fill {
                height: 100%;
                border-radius: 4px;
                transition: width 0.4s ease;
            }
            .pv-budget-amount {
                font-family: "DM Mono", monospace;
                font-size: 12px;
                font-weight: 600;
                min-width: 70px;
                text-align: right;
            }
            .pv-timeline-item {
                display: flex;
                align-items: flex-start;
                gap: 14px;
                padding: 10px 0;
                position: relative;
            }
            .pv-timeline-dot {
                width: 10px;
                height: 10px;
                border-radius: 50%;
                margin-top: 4px;
                flex-shrink: 0;
            }
            .pv-timeline-line {
                position: absolute;
                left: 4px;
                top: 24px;
                bottom: -10px;
                width: 2px;
                background: rgba(255,255,255,0.06);
            }
            .pv-timeline-day {
                font-family: "DM Mono", monospace;
                font-size: 11px;
                font-weight: 700;
                color: #E8EDF2;
                min-width: 52px;
            }
            .pv-timeline-action {
                font-size: 12px;
                color: #8A95A3;
                line-height: 1.5;
            }
            .pv-agent-card {
                background: #0D1318;
                border: 1px solid rgba(255,255,255,0.07);
                border-left: 4px solid #00E5A0;
                border-radius: 14px;
                padding: 20px 22px;
                margin-top: 16px;
            }
            .pv-agent-header {
                font-size: 13px;
                font-weight: 700;
                margin-bottom: 10px;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .pv-agent-body {
                font-size: 13px;
                color: #8A95A3;
                line-height: 1.7;
                font-style: italic;
            }
            .pv-bottom {
                position: fixed;
                bottom: 0;
                left: 0;
                right: 0;
                background: rgba(8,12,16,0.92);
                backdrop-filter: blur(12px);
                border-top: 1px solid rgba(255,255,255,0.07);
                padding: 16px 36px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                z-index: 20;
            }
            .pv-bottom-info {
                font-family: "DM Mono", monospace;
                font-size: 12px;
                color: #5A6A7A;
            }
            .pv-bottom-actions {
                display: flex;
                align-items: center;
                gap: 12px;
            }
            .pv-btn-changes {
                background: transparent;
                border: 1px solid rgba(255,255,255,0.12);
                color: #E8EDF2;
                font-family: "Syne", sans-serif;
                font-size: 13px;
                font-weight: 600;
                padding: 11px 22px;
                border-radius: 10px;
                cursor: pointer;
                transition: all 0.15s;
            }
            .pv-btn-changes:hover {
                border-color: rgba(255,255,255,0.25);
                background: rgba(255,255,255,0.04);
            }
            .pv-btn-approve {
                background: #00E5A0;
                color: #000;
                font-family: "Syne", sans-serif;
                font-size: 14px;
                font-weight: 700;
                padding: 12px 28px;
                border-radius: 10px;
                border: none;
                cursor: pointer;
                transition: all 0.2s;
                letter-spacing: 0.2px;
            }
            .pv-btn-approve:hover {
                background: #00ffb3;
                transform: translateY(-1px);
                box-shadow: 0 8px 24px rgba(0,229,160,0.3);
            }
            .pv-fade {
                animation: pvFadeIn 0.4s ease forwards;
                opacity: 0;
            }
            @keyframes pvFadeIn {
                from { opacity: 0; transform: translateY(8px); }
                to { opacity: 1; transform: translateY(0); }
            }
            .pv-fade:nth-child(1) { animation-delay: 0.05s; }
            .pv-fade:nth-child(2) { animation-delay: 0.1s; }
            .pv-fade:nth-child(3) { animation-delay: 0.15s; }
            @media (max-width: 1000px) {
                .pv-grid { grid-template-columns: 1fr; }
            }
            @media (max-width: 640px) {
                .pv-topbar { padding: 14px 16px; flex-direction: column; align-items: flex-start; gap: 10px; }
                .pv-content { padding: 20px 16px; }
                .pv-bottom { padding: 14px 16px; flex-direction: column; gap: 10px; }
            }
        """}</style>

        <div className="pv-topbar">
            <div className="pv-topbar-left">
                <button className="pv-back-btn" onClick={on_back}>←</button>
                <div>
                    <div className="pv-topbar-title">{brand_name}</div>
                    <div className="pv-topbar-goal">{goal}</div>
                </div>
            </div>
            <div className="pv-mode-badge" style={{
                "background": mode_bg,
                "color": mode_fg,
                "border": mode_border
            }}>{mode_text}</div>
            <div className="pv-topbar-meta">{topbar_meta}</div>
        </div>

        <div className="pv-content">
            <div className="pv-summary pv-fade">
                <p className="pv-summary-text">{summary}</p>
                <div className="pv-pills">
                    <span className="pv-pill" style={{
                        "background": "rgba(0,229,160,0.1)",
                        "color": "#00E5A0",
                        "border": "1px solid rgba(0,229,160,0.2)"
                    }}>{approved_pill}</span>
                    <span className="pv-pill" style={{
                        "background": "rgba(255,69,96,0.1)",
                        "color": "#FF4560",
                        "border": "1px solid rgba(255,69,96,0.2)"
                    }}>{rejected_pill}</span>
                    <span className="pv-pill" style={{
                        "background": "rgba(0,102,255,0.1)",
                        "color": "#0066FF",
                        "border": "1px solid rgba(0,102,255,0.2)"
                    }}>{reach_pill}</span>
                </div>
            </div>

            <div className="pv-grid">
                <div className="pv-fade">
                    <div className="pv-card">
                        <div className="pv-card-header">
                            <div className="pv-card-title">KOL Roster</div>
                            <div className="pv-card-tag">{roster_count}</div>
                        </div>
                        <table className="pv-table">
                            <thead>
                                <tr>
                                    <th>Handle</th>
                                    <th>Score</th>
                                    <th>Tier</th>
                                    <th>Role</th>
                                    <th>Budget</th>
                                    <th>Est. Reach</th>
                                </tr>
                            </thead>
                            <tbody>
                                {roster_rows}
                            </tbody>
                        </table>

                        <div className="pv-rejected-toggle"
                            onClick={lambda -> None { show_rejected = not show_rejected; }}>
                            {rejected_toggle_str}
                        </div>
                        {show_rejected and <div style={{"paddingBottom": "14px"}}>
                            {rejected_rows}
                        </div>}
                    </div>
                </div>

                <div className="pv-fade">
                    <div className="pv-card" style={{"marginBottom": "16px"}}>
                        <div className="pv-card-header">
                            <div className="pv-card-title">Budget Breakdown</div>
                            <div className="pv-card-tag">Allocation</div>
                        </div>
                        <div className="pv-card-body">
                            <div className="pv-budget-row">
                                <div className="pv-budget-label">Tier 1 · 40%</div>
                                <div className="pv-budget-bar-track">
                                    <div className="pv-budget-bar-fill" style={{"width": "40%", "background": "#FFB800"}}></div>
                                </div>
                                <div className="pv-budget-amount" style={{"color": "#FFB800"}}>{"$" + str(t1_amount)}</div>
                            </div>
                            <div className="pv-budget-row">
                                <div className="pv-budget-label">Tier 2 · 40%</div>
                                <div className="pv-budget-bar-track">
                                    <div className="pv-budget-bar-fill" style={{"width": "40%", "background": "#0066FF"}}></div>
                                </div>
                                <div className="pv-budget-amount" style={{"color": "#0066FF"}}>{"$" + str(t2_amount)}</div>
                            </div>
                            <div className="pv-budget-row">
                                <div className="pv-budget-label">Tier 3 · 20%</div>
                                <div className="pv-budget-bar-track">
                                    <div className="pv-budget-bar-fill" style={{"width": "20%", "background": "#5A6A7A"}}></div>
                                </div>
                                <div className="pv-budget-amount" style={{"color": "#5A6A7A"}}>{"$" + str(t3_amount)}</div>
                            </div>
                            <div style={{
                                "borderTop": "1px solid rgba(255,255,255,0.07)",
                                "marginTop": "14px",
                                "paddingTop": "14px",
                                "display": "flex",
                                "justifyContent": "space-between",
                                "alignItems": "center"
                            }}>
                                <span style={{
                                    "fontFamily": "DM Mono, monospace",
                                    "fontSize": "10px",
                                    "color": "#5A6A7A",
                                    "letterSpacing": "1.5px",
                                    "textTransform": "uppercase"
                                }}>Total</span>
                                <span style={{
                                    "fontFamily": "DM Mono, monospace",
                                    "fontSize": "16px",
                                    "fontWeight": "700",
                                    "color": "#00E5A0"
                                }}>{budget_total_str}</span>
                            </div>
                        </div>
                    </div>

                    <div className="pv-card" style={{"marginBottom": "16px"}}>
                        <div className="pv-card-header">
                            <div className="pv-card-title">Campaign Timeline</div>
                            <div className="pv-card-tag">{timeline_tag}</div>
                        </div>
                        <div className="pv-card-body">
                            {timeline_rows}
                        </div>
                    </div>

                    <div className="pv-agent-card">
                        <div className="pv-agent-header">🤖 Agent Assessment</div>
                        <div className="pv-agent-body">{recommendation}</div>
                    </div>
                </div>
            </div>
        </div>

        <div className="pv-bottom">
            <div className="pv-bottom-info">{bottom_info_str}</div>
            <div className="pv-bottom-actions">
                <button className="pv-btn-changes" onClick={lambda -> None { }}>
                    Request Changes
                </button>
                <button className="pv-btn-approve" onClick={on_approve}>
                    ✓ Approve & Lock Budget
                </button>
            </div>
        </div>
    </div>;
}
