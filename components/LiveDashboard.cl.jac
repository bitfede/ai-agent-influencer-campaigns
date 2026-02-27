"""LiveDashboard — post-approval execution view with verify + pay actions."""

def:pub LiveDashboard(
    campaign: dict,
    activity_log: list,
    on_verify: any,
    on_pay: any
) -> JsxElement {

    has verify_url: str = "https://twitter.com/example/status/123456789";
    has pending_handle: str = "";

    brand = campaign["brand_name"] or "Campaign";
    mode_val = campaign["mode"] or "web3";
    budget = campaign["budget_usdc"] or 0;
    approved_kols = campaign["approved_kols"] or [];

    # Pre-compute mode badge
    mode_label = "⬡ Web3";
    mode_color = "#00E5A0";
    mode_bg = "rgba(0,229,160,0.1)";
    mode_border = "rgba(0,229,160,0.3)";
    if (mode_val == "web2") {
        mode_label = "◈ Web2";
        mode_color = "#A855F7";
        mode_bg = "rgba(168,85,247,0.1)";
        mode_border = "rgba(168,85,247,0.3)";
    }

    # Build KOL rows
    kol_rows: list = [];
    for kol in approved_kols {
        handle = kol["handle"] or "";
        tier = kol["tier"] or "";
        pay_status = kol["payment_status"] or "unpaid";
        amount = kol["payment_amount_usdc"] or 0;
        v_verdict = kol["verification_verdict"] or "";
        v_score = kol["verification_score"] or 0;

        # Status pill
        pill_text = "Awaiting Content";
        pill_bg = "rgba(255,184,0,0.1)";
        pill_color = "#FFB800";
        if (pay_status == "paid") {
            pill_text = "✓ Paid";
            pill_bg = "rgba(0,229,160,0.1)";
            pill_color = "#00E5A0";
        } elif (pay_status == "verified") {
            pill_text = "✓ Verified — Ready to Pay";
            pill_bg = "rgba(0,102,255,0.1)";
            pill_color = "#0066FF";
        } elif (pay_status == "outreach_sent") {
            pill_text = "Outreach Sent";
            pill_bg = "rgba(0,102,255,0.1)";
            pill_color = "#0066FF";
        }

        # Tier color
        tier_color = "#5A6A7A";
        if (tier == "tier_1") {
            tier_color = "#FFB800";
        } elif (tier == "tier_2") {
            tier_color = "#0066FF";
        }

        # Action buttons
        action_el = <span style={{"color": "#5A6A7A", "fontSize": "11px"}}>—</span>;
        captured_handle = handle;
        if (pay_status == "outreach_sent" or pay_status == "unpaid") {
            action_el = <button
                style={{
                    "padding": "6px 14px",
                    "borderRadius": "6px",
                    "fontSize": "11px",
                    "fontWeight": "600",
                    "fontFamily": "'Syne', sans-serif",
                    "cursor": "pointer",
                    "background": "rgba(0,102,255,0.1)",
                    "border": "1px solid rgba(0,102,255,0.3)",
                    "color": "#0066FF"
                }}
                onClick={lambda h=captured_handle, v=on_verify, u=verify_url -> None { v(h, u); }}
            >Verify Content</button>;
        } elif (pay_status == "verified") {
            action_el = <button
                style={{
                    "padding": "6px 14px",
                    "borderRadius": "6px",
                    "fontSize": "11px",
                    "fontWeight": "600",
                    "fontFamily": "'Syne', sans-serif",
                    "cursor": "pointer",
                    "background": "rgba(0,229,160,0.1)",
                    "border": "1px solid rgba(0,229,160,0.3)",
                    "color": "#00E5A0"
                }}
                onClick={lambda h=captured_handle, p=on_pay -> None { p(h); }}
            >💸 Release Payment</button>;
        } elif (pay_status == "paid") {
            action_el = <span style={{"color": "#00E5A0", "fontSize": "11px", "fontFamily": "'DM Mono', monospace"}}>✓ Complete</span>;
        }

        kol_rows.append(
            <tr style={{"borderBottom": "1px solid rgba(255,255,255,0.05)"}}>
                <td style={{"padding": "14px 20px"}}>
                    <div style={{"fontWeight": "600", "fontSize": "13px"}}>{handle}</div>
                    <div style={{"fontSize": "10px", "color": tier_color, "fontFamily": "'DM Mono', monospace", "marginTop": "2px"}}>{tier}</div>
                </td>
                <td style={{"padding": "14px 20px"}}>
                    <span style={{
                        "padding": "4px 10px",
                        "borderRadius": "6px",
                        "fontSize": "10px",
                        "fontWeight": "500",
                        "fontFamily": "'DM Mono', monospace",
                        "background": pill_bg,
                        "color": pill_color
                    }}>{pill_text}</span>
                </td>
                <td style={{"padding": "14px 20px", "fontFamily": "'DM Mono', monospace", "fontSize": "12px", "color": "#00E5A0"}}>{"$" + str(amount)}</td>
                <td style={{"padding": "14px 20px"}}>{action_el}</td>
            </tr>
        );
    }

    # Build activity log items
    log_items: list = [];
    max_log = 8;
    log_count = 0;
    for entry in activity_log {
        if (log_count >= max_log) {
            break;
        }
        log_count = log_count + 1;
        e_msg = entry["message"] or "";
        e_detail = entry["detail"] or "";
        log_items.append(
            <div style={{
                "display": "flex",
                "alignItems": "flex-start",
                "gap": "10px",
                "padding": "10px 0",
                "borderBottom": "1px solid rgba(255,255,255,0.04)"
            }}>
                <div style={{"flex": "1"}}>
                    <div style={{"fontSize": "12px", "fontWeight": "600", "color": "#E8EDF2"}}>{e_msg}</div>
                    <div style={{"fontSize": "10px", "color": "#5A6A7A", "fontFamily": "'DM Mono', monospace", "marginTop": "2px"}}>{e_detail}</div>
                </div>
            </div>
        );
    }

    return <div style={{
        "minHeight": "100vh",
        "background": "#080C10",
        "color": "#E8EDF2",
        "fontFamily": "'Syne', Arial, sans-serif"
    }}>
        <div style={{
            "display": "flex",
            "alignItems": "center",
            "justifyContent": "space-between",
            "padding": "20px 36px",
            "borderBottom": "1px solid rgba(255,255,255,0.07)",
            "background": "rgba(8,12,16,0.9)",
            "backdropFilter": "blur(10px)"
        }}>
            <div>
                <h1 style={{"fontSize": "20px", "fontWeight": "700", "letterSpacing": "-0.3px"}}>{brand} — Execution</h1>
                <p style={{"fontSize": "11px", "color": "#5A6A7A", "fontFamily": "'DM Mono', monospace", "marginTop": "2px"}}>Campaign executing · outreach complete</p>
            </div>
            <div style={{"display": "flex", "alignItems": "center", "gap": "12px"}}>
                <span style={{
                    "padding": "5px 12px",
                    "borderRadius": "20px",
                    "fontSize": "11px",
                    "fontWeight": "600",
                    "fontFamily": "'DM Mono', monospace",
                    "color": mode_color,
                    "background": mode_bg,
                    "border": "1px solid " + mode_border
                }}>{mode_label}</span>
                <span style={{"fontSize": "13px", "color": "#00E5A0", "fontFamily": "'DM Mono', monospace", "fontWeight": "600"}}>{"$" + str(budget) + " USDC"}</span>
            </div>
        </div>

        <div style={{"padding": "32px 36px"}}>
            <div style={{
                "display": "grid",
                "gridTemplateColumns": "1fr 360px",
                "gap": "24px"
            }}>
                <div>
                    <div style={{
                        "background": "#0D1318",
                        "border": "1px solid rgba(255,255,255,0.07)",
                        "borderRadius": "14px",
                        "overflow": "hidden"
                    }}>
                        <div style={{
                            "display": "flex",
                            "alignItems": "center",
                            "justifyContent": "space-between",
                            "padding": "16px 20px",
                            "borderBottom": "1px solid rgba(255,255,255,0.07)"
                        }}>
                            <div style={{"fontSize": "14px", "fontWeight": "700"}}>KOL Roster — Execution Status</div>
                            <div style={{"fontSize": "10px", "color": "#5A6A7A", "fontFamily": "'DM Mono', monospace"}}>
                                {str(len(approved_kols)) + " KOLs"}
                            </div>
                        </div>
                        <table style={{"width": "100%", "borderCollapse": "collapse"}}>
                            <thead>
                                <tr style={{"background": "#121A22"}}>
                                    <th style={{"padding": "12px 20px", "textAlign": "left", "fontSize": "10px", "color": "#5A6A7A", "fontFamily": "'DM Mono', monospace", "letterSpacing": "1.5px", "textTransform": "uppercase"}}>KOL</th>
                                    <th style={{"padding": "12px 20px", "textAlign": "left", "fontSize": "10px", "color": "#5A6A7A", "fontFamily": "'DM Mono', monospace", "letterSpacing": "1.5px", "textTransform": "uppercase"}}>Status</th>
                                    <th style={{"padding": "12px 20px", "textAlign": "left", "fontSize": "10px", "color": "#5A6A7A", "fontFamily": "'DM Mono', monospace", "letterSpacing": "1.5px", "textTransform": "uppercase"}}>Budget</th>
                                    <th style={{"padding": "12px 20px", "textAlign": "left", "fontSize": "10px", "color": "#5A6A7A", "fontFamily": "'DM Mono', monospace", "letterSpacing": "1.5px", "textTransform": "uppercase"}}>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                {kol_rows}
                            </tbody>
                        </table>
                    </div>

                    <div style={{
                        "marginTop": "20px",
                        "background": "#0D1318",
                        "border": "1px solid rgba(255,255,255,0.07)",
                        "borderRadius": "14px",
                        "padding": "20px"
                    }}>
                        <div style={{"fontSize": "11px", "fontWeight": "600", "color": "#5A6A7A", "letterSpacing": "1px", "textTransform": "uppercase", "fontFamily": "'DM Mono', monospace", "marginBottom": "10px"}}>Content URL for Verification</div>
                        <input
                            type="text"
                            value={verify_url}
                            onChange={lambda e -> None { verify_url = e.target.value; }}
                            style={{
                                "width": "100%",
                                "padding": "10px 14px",
                                "borderRadius": "8px",
                                "border": "1px solid rgba(255,255,255,0.07)",
                                "background": "#121A22",
                                "color": "#E8EDF2",
                                "fontSize": "13px",
                                "fontFamily": "'Syne', sans-serif",
                                "outline": "none"
                            }}
                        />
                        <p style={{"fontSize": "10px", "color": "#5A6A7A", "marginTop": "6px", "fontFamily": "'DM Mono', monospace"}}>Paste KOL content URL, then click "Verify Content" on their row.</p>
                    </div>
                </div>

                <div>
                    <div style={{
                        "background": "#0D1318",
                        "border": "1px solid rgba(255,255,255,0.07)",
                        "borderRadius": "14px",
                        "padding": "20px"
                    }}>
                        <div style={{"fontSize": "14px", "fontWeight": "700", "marginBottom": "16px"}}>Activity Log</div>
                        {log_items}
                    </div>
                </div>
            </div>
        </div>
    </div>;
}
