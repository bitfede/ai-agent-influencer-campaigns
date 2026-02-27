"""AgentRunning — shows real-time pipeline progress while the agent works."""

def:pub AgentRunning(
    campaign: dict,
    activity_log: list,
    on_proposal_ready: any
) -> JsxElement {

    brand = campaign["brand_name"] or "Campaign";
    status = campaign["status"] or "running";

    # Build activity items
    log_items: list = [];
    for entry in activity_log {
        evt = entry["event_type"] or "";
        icon_bg = "rgba(0,229,160,0.1)";
        icon_char = "⚡";
        if ("rejected" in evt or "failed" in evt) {
            icon_bg = "rgba(255,69,96,0.1)";
            icon_char = "✗";
        } elif ("approved" in evt or "done" in evt or "verified" in evt) {
            icon_bg = "rgba(0,229,160,0.1)";
            icon_char = "✓";
        } elif ("start" in evt) {
            icon_bg = "rgba(0,102,255,0.1)";
            icon_char = "⏳";
        }

        entry_msg = entry["message"] or "";
        entry_detail = entry["detail"] or "";
        entry_ts = entry["timestamp"] or "";

        log_items.append(
            <div style={{
                "display": "flex",
                "alignItems": "flex-start",
                "gap": "12px",
                "padding": "12px 0",
                "borderBottom": "1px solid rgba(255,255,255,0.05)"
            }}>
                <div style={{
                    "width": "32px",
                    "height": "32px",
                    "borderRadius": "8px",
                    "background": icon_bg,
                    "display": "flex",
                    "alignItems": "center",
                    "justifyContent": "center",
                    "fontSize": "14px",
                    "flexShrink": "0"
                }}>{icon_char}</div>
                <div style={{"flex": "1"}}>
                    <div style={{"fontSize": "13px", "fontWeight": "600", "color": "#E8EDF2", "marginBottom": "2px"}}>{entry_msg}</div>
                    <div style={{"fontSize": "11px", "color": "#5A6A7A", "fontFamily": "'DM Mono', monospace"}}>{entry_detail}</div>
                </div>
                <div style={{"fontSize": "10px", "color": "#5A6A7A", "fontFamily": "'DM Mono', monospace", "whiteSpace": "nowrap"}}>{entry_ts}</div>
            </div>
        );
    }

    # Status badge
    status_text = "Running...";
    status_color = "#00E5A0";
    if (status == "proposal_ready") {
        status_text = "Proposal Ready!";
        status_color = "#00E5A0";
    } elif (status == "vetting") {
        status_text = "Vetting KOLs...";
        status_color = "#0066FF";
    } elif (status == "discovering") {
        status_text = "Discovering KOLs...";
        status_color = "#0066FF";
    } elif (status == "onboarding") {
        status_text = "Building Profile...";
        status_color = "#FFB800";
    }

    return <div style={{
        "minHeight": "100vh",
        "background": "#080C10",
        "color": "#E8EDF2",
        "fontFamily": "'Syne', Arial, sans-serif",
        "display": "flex",
        "flexDirection": "column",
        "alignItems": "center",
        "padding": "40px 20px"
    }}>
        <style>{"""
            @keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
            @keyframes pulse2 { 0%,100% { opacity: 1; } 50% { opacity: 0.5; } }
        """}</style>

        <div style={{
            "width": "100%",
            "maxWidth": "680px"
        }}>
            <div style={{
                "textAlign": "center",
                "marginBottom": "40px"
            }}>
                <div style={{
                    "width": "64px",
                    "height": "64px",
                    "border": "3px solid rgba(0,229,160,0.2)",
                    "borderTop": "3px solid #00E5A0",
                    "borderRadius": "50%",
                    "animation": "spin 1s linear infinite",
                    "margin": "0 auto 20px"
                }}></div>
                <h1 style={{
                    "fontSize": "24px",
                    "fontWeight": "800",
                    "letterSpacing": "-0.5px",
                    "marginBottom": "8px"
                }}>🤖 Agent Working</h1>
                <p style={{
                    "fontSize": "14px",
                    "color": "#5A6A7A"
                }}>{brand} — AI pipeline in progress</p>
                <div style={{
                    "display": "inline-flex",
                    "alignItems": "center",
                    "gap": "8px",
                    "marginTop": "16px",
                    "padding": "6px 16px",
                    "borderRadius": "20px",
                    "fontSize": "12px",
                    "fontWeight": "600",
                    "fontFamily": "'DM Mono', monospace",
                    "color": status_color,
                    "background": "rgba(0,229,160,0.08)",
                    "border": "1px solid rgba(0,229,160,0.2)"
                }}>
                    <div style={{
                        "width": "7px",
                        "height": "7px",
                        "borderRadius": "50%",
                        "background": status_color,
                        "animation": "pulse2 2s infinite"
                    }}></div>
                    {status_text}
                </div>
            </div>

            <div style={{
                "background": "#0D1318",
                "border": "1px solid rgba(255,255,255,0.07)",
                "borderRadius": "14px",
                "padding": "24px",
                "marginBottom": "24px"
            }}>
                <div style={{
                    "fontSize": "14px",
                    "fontWeight": "700",
                    "marginBottom": "16px",
                    "letterSpacing": "-0.2px"
                }}>Live Activity Feed</div>
                {log_items}
            </div>

            <div style={{
                "display": "flex",
                "justifyContent": "center",
                "gap": "12px"
            }}>
                <button
                    style={{
                        "padding": "12px 28px",
                        "borderRadius": "10px",
                        "fontSize": "13px",
                        "fontWeight": "700",
                        "fontFamily": "'Syne', sans-serif",
                        "cursor": "pointer",
                        "background": "#00E5A0",
                        "color": "#000",
                        "border": "none",
                        "transition": "all 0.2s"
                    }}
                    onClick={on_proposal_ready}
                >View Proposal →</button>
            </div>
        </div>
    </div>;
}
