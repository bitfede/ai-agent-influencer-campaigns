"""Main entry point for ai-agent-hackathon."""

cl import from "@jac/runtime" { jacLogin, jacSignup, jacLogout, jacIsLoggedIn }
cl import from .components.Dashboard { Dashboard }
cl import from .components.Login { LoginForm }
cl import from .components.ProposalView { ProposalView }
cl import from .components.AgentRunning { AgentRunning }
cl import from .components.LiveDashboard { LiveDashboard }

import from services.agent {
    build_intelligence_profile,
    vet_kol,
    build_proposal,
    write_outreach,
    verify_content
}
import from services.mock_kols { get_candidates }
import from services.demo_data { get_demo_campaigns, DEMO_WEB3_CAMPAIGN, DEMO_WEB2_CAMPAIGN }

import random;

# ───────────────────────────────────────────
# Data Model — Graph Nodes
# ───────────────────────────────────────────

node Campaign {
    has id: str = "";
    has brand_name: str = "";
    has goal: str = "";
    has budget_usdc: float = 0.0;
    has timeline_days: int = 14;
    has target_audience: list = [];
    has content_type: list = [];
    has campaign_brief: str = "";
    has min_kol_score: int = 65;
    has status: str = "onboarding";
    has intelligence_profile: dict = {};
    has proposal: dict = {};
    has created_at: str = "";
}

node KOL {
    has handle: str = "";
    has followers: int = 0;
    has engagement_rate: float = 0.0;
    has score: int = 0;
    has verdict: str = "";
    has tier: str = "";
    has wallet_address: str = "";
    has payment_status: str = "unpaid";
    has payment_amount_usdc: float = 0.0;
    has rejection_reason: str = "";
    has content_url: str = "";
    has verification_score: int = 0;
    has verification_verdict: str = "";
    has tx_hash: str = "";
    has outreach_message: str = "";
}

node ActivityLog {
    has event_type: str = "";
    has message: str = "";
    has detail: str = "";
    has timestamp: str = "";
    has campaign_id: str = "";
}

# ───────────────────────────────────────────
# Data Model — Edges
# ───────────────────────────────────────────

edge owns {}      # root --owns--> Campaign
edge includes {}  # Campaign --includes--> KOL
edge logged {}    # Campaign --logged--> ActivityLog

# ───────────────────────────────────────────
# Global Campaign Store
# ───────────────────────────────────────────

glob campaigns: dict = {};

# ───────────────────────────────────────────
# Helper: generate a simple timestamp string
# ───────────────────────────────────────────

def _make_ts() -> str {
    h = str(random.randint(10, 23));
    m = str(random.randint(10, 59));
    s = str(random.randint(10, 59));
    return "2026-02-27T" + h + ":" + m + ":" + s + "Z";
}

# #region agent log
import json as _dj;
import time as _dt;
import traceback as _dtb;
def _dl(loc: str, msg: str, data: dict = {}) {
    _ff = open("/Users/federicodefaveri-sei/Developer/hackathons/velric_hackathon/jaseci_test/ai-agent-hackathon/.cursor/debug.log", "a");
    _ff.write(_dj.dumps({"location": loc, "message": msg, "data": data, "timestamp": _dt.time()}) + "\n");
    _ff.close();
}
# #endregion

# ───────────────────────────────────────────
# Server Logic — Full Campaign Pipeline
# ───────────────────────────────────────────

sv {

    # ——— Startup: Load demo campaigns ———
    def _ensure_demos() {
        if (not campaigns.get("demo-doge-001")) {
            demos = get_demo_campaigns();
            for k in demos {
                campaigns[k] = demos[k];
            }
        }
    }

    # ——— Get all campaigns (list) ———
    def:pub get_campaigns() -> list {
        _ensure_demos();
        result: list = [];
        for cid in campaigns {
            c = campaigns[cid];
            result.append({
                "id": cid,
                "brand_name": c.get("brand_name", ""),
                "goal": c.get("goal", ""),
                "status": c.get("status", ""),
                "budget_usdc": c.get("budget_usdc", 0),
                "mode": c.get("mode", "web3")
            });
        }
        return result;
    }

    # ——— Get single campaign ———
    def:pub get_campaign(cid: str) -> dict {
        _ensure_demos();
        if (campaigns.get(cid)) {
            return campaigns[cid];
        }
        return {"error": "Campaign not found"};
    }

    # ——— Get activity log ———
    def:pub get_activity(cid: str) -> list {
        _ensure_demos();
        if (campaigns.get(cid)) {
            return campaigns[cid].get("activity_log", []);
        }
        return [];
    }

    # ——— Helper: add log entry ———
    def _add_log(cid: str, event_type: str, message: str, detail: str = "") {
        if (campaigns.get(cid)) {
            campaigns[cid]["activity_log"].insert(0, {
                "event_type": event_type,
                "message": message,
                "detail": detail,
                "timestamp": _make_ts()
            });
        }
    }

    # ——— Create new campaign (single-dict param for reliable cl→sv serialization) ———
    def:pub create_campaign(data: dict) -> str {
        # #region agent log
        _dl("sv:create_campaign:entry", "create_campaign called", {"data_type": str(type(data))});
        # #endregion
        _ensure_demos();

        brand_name = str(data.get("brand_name", ""));
        goal = str(data.get("goal", ""));
        budget_usdc = float(data.get("budget_usdc", 0));
        timeline_days = int(data.get("timeline_days", 14));
        target_audience = data.get("target_audience", []);
        content_type = data.get("content_type", []);
        campaign_brief = str(data.get("campaign_brief", ""));
        min_kol_score = int(data.get("min_kol_score", 65));
        mode = str(data.get("mode", "web3"));

        cid = "camp-" + str(random.randint(10000, 99999));
        campaigns[cid] = {
            "id": cid,
            "brand_name": brand_name,
            "goal": goal,
            "budget_usdc": budget_usdc,
            "timeline_days": timeline_days,
            "target_audience": target_audience,
            "content_type": content_type,
            "campaign_brief": campaign_brief,
            "min_kol_score": min_kol_score,
            "mode": mode,
            "status": "onboarding",
            "intelligence_profile": {},
            "proposal": {},
            "approved_kols": [],
            "rejected_kols": [],
            "activity_log": [],
            "created_at": _make_ts()
        };
        _add_log(cid, "campaign_created",
            "Campaign created — " + brand_name + " " + goal,
            "$" + str(budget_usdc) + " · " + str(timeline_days) + " days · " + mode + " mode");
        # #region agent log
        _dl("sv:create_campaign:return", "Returning campaign_id", {"cid": cid});
        # #endregion
        return cid;
    }

    # ——— Run full pipeline (called after create) ———
    def:pub run_pipeline(cid: str) -> dict {
        # #region agent log
        _dl("sv:run_pipeline:entry", "run_pipeline called", {"cid": cid});
        # #endregion
        try {
            _ensure_demos();
            if (not campaigns.get(cid)) {
                # #region agent log
                _dl("sv:run_pipeline:not_found", "campaign not found", {"cid": cid});
                # #endregion
                return {"error": "Campaign not found"};
            }
            c = campaigns[cid];
            mode = c.get("mode", "web3");

            # Stage 1: Intelligence Profile
            # #region agent log
            _dl("sv:run_pipeline:stage1_start", "Starting intelligence profile", {"cid": cid});
            # #endregion
            c["status"] = "onboarding";
            _add_log(cid, "profile_start", "Building Campaign Intelligence Profile...", "Analyzing brand goals and audience");

            intake = {
                "brand_name": c["brand_name"],
                "goal": c["goal"],
                "budget_usdc": c["budget_usdc"],
                "timeline_days": c["timeline_days"],
                "target_audience": c["target_audience"],
                "content_type": c["content_type"],
                "campaign_brief": c["campaign_brief"],
                "min_kol_score": c["min_kol_score"]
            };
            profile = build_intelligence_profile(intake);
            c["intelligence_profile"] = profile;
            eco = str(profile.get("ecosystem_focus", ["General"]));
            _add_log(cid, "profile_done", "✓ Intelligence profile ready", "Targeting: " + eco);
            # #region agent log
            _dl("sv:run_pipeline:stage1_done", "Intelligence profile done", {"eco": eco});
            # #endregion

            # Stage 2: Discovery
            # #region agent log
            _dl("sv:run_pipeline:stage2_start", "Starting discovery", {"mode": mode});
            # #endregion
            c["status"] = "discovering";
            _add_log(cid, "discovery_start", "Querying Influur database...", "Mode: " + mode);
            candidates = get_candidates(mode=mode);
            _add_log(cid, "discovery_done", str(len(candidates)) + " candidates found", "Passing to vetting engine");
            # #region agent log
            _dl("sv:run_pipeline:stage2_done", "Discovery done", {"num_candidates": len(candidates)});
            # #endregion

            # Stage 3: Vetting
            # #region agent log
            _dl("sv:run_pipeline:stage3_start", "Starting vetting", {"num_candidates": len(candidates)});
            # #endregion
            c["status"] = "vetting";
            approved: list = [];
            rejected: list = [];
            vet_idx = 0;
            for kol in candidates {
                # #region agent log
                _dl("sv:run_pipeline:vet_kol", "Vetting KOL " + str(vet_idx), {"handle": kol.get("handle", "?")});
                # #endregion
                result = vet_kol(kol, profile);
                # #region agent log
                _dl("sv:run_pipeline:vet_kol_done", "KOL vetted " + str(vet_idx), {"verdict": result.get("verdict", "?")});
                # #endregion
                # Manual dict merge (no spread syntax in Jac)
                kol_copy: dict = {};
                for k in kol {
                    kol_copy[k] = kol[k];
                }
                for k in result {
                    kol_copy[k] = result[k];
                }
                if (result.get("verdict") == "approved") {
                    approved.append(kol_copy);
                    _add_log(cid, "kol_approved",
                        "✓ " + str(kol["handle"]) + " approved",
                        "Score: " + str(result.get("score", 0)) + "/100 — " + str(result.get("tier", "N/A")));
                } else {
                    rejected.append(kol_copy);
                    _add_log(cid, "kol_rejected",
                        "✗ " + str(kol["handle"]) + " rejected",
                        str(result.get("rejection_reason", "Below threshold")));
                }
                vet_idx = vet_idx + 1;
            }
            c["approved_kols"] = approved;
            c["rejected_kols"] = rejected;
            # #region agent log
            _dl("sv:run_pipeline:stage3_done", "Vetting done", {"approved": len(approved), "rejected": len(rejected)});
            # #endregion

            # Stage 4: Proposal
            # #region agent log
            _dl("sv:run_pipeline:stage4_start", "Starting proposal generation", {});
            # #endregion
            c["status"] = "building_proposal";
            _add_log(cid, "proposal_start", "Generating campaign proposal...",
                str(len(approved)) + " approved, " + str(len(rejected)) + " rejected");
            proposal = build_proposal(approved, c);
            c["proposal"] = proposal;
            # #region agent log
            _dl("sv:run_pipeline:stage4_done", "Proposal built", {"has_roster": "kol_roster" in proposal});
            # #endregion

            # Sync budget allocation from proposal kol_roster back to approved_kols
            roster = proposal.get("kol_roster", []);
            for roster_entry in roster {
                r_handle = roster_entry.get("handle", "");
                r_budget = roster_entry.get("budget_usdc", 0);
                for ak in approved {
                    ak_handle = ak.get("handle", "");
                    if (ak_handle == r_handle) {
                        ak["payment_amount_usdc"] = r_budget;
                        ak["payment_status"] = "unpaid";
                        break;
                    }
                }
            }

            c["status"] = "proposal_ready";
            _add_log(cid, "proposal_done", "✓ Proposal ready for approval",
                "Expected reach: " + str(proposal.get("total_expected_reach", "N/A")));

            # #region agent log
            _dl("sv:run_pipeline:complete", "Pipeline DONE", {"status": "proposal_ready"});
            # #endregion
            return {"status": "proposal_ready", "approved": len(approved), "rejected": len(rejected)};
        } except Exception as e {
            # #region agent log
            _dl("sv:run_pipeline:EXCEPTION", "Pipeline crashed", {"error": str(e), "tb": _dtb.format_exc()});
            # #endregion
            return {"error": str(e)};
        }
    }

    # ——— Approve campaign ———
    def:pub approve_campaign(cid: str) -> dict {
        _ensure_demos();
        if (not campaigns.get(cid)) {
            return {"error": "Campaign not found"};
        }
        c = campaigns[cid];
        c["status"] = "approved";
        _add_log(cid, "approved", "✓ Campaign approved by brand", "Budget locked. Starting outreach.");

        # Generate outreach for each approved KOL
        for kol in c["approved_kols"] {
            amt = kol.get("payment_amount_usdc", 0);
            outreach = write_outreach(kol, c, amt);
            kol["outreach_message"] = outreach;
            kol["payment_status"] = "outreach_sent";
            _add_log(cid, "outreach_sent",
                "📨 Outreach sent to " + str(kol["handle"]),
                "Payment: $" + str(amt));
        }
        c["status"] = "executing";
        return {"message": "Approved. Outreach complete.", "status": "executing"};
    }

    # ——— Verify KOL content ———
    def:pub verify_kol_content(cid: str, kol_handle: str, content_url: str) -> dict {
        _ensure_demos();
        if (not campaigns.get(cid)) {
            return {"error": "Campaign not found"};
        }
        c = campaigns[cid];
        target_kol: dict = {};
        for kol in c["approved_kols"] {
            if (kol["handle"] == kol_handle) {
                target_kol = kol;
                break;
            }
        }
        if (not target_kol) {
            return {"error": "KOL not found in campaign"};
        }
        result = verify_content(content_url, target_kol, c);
        target_kol["content_url"] = content_url;
        target_kol["verification_score"] = result.get("score", 0);
        target_kol["verification_verdict"] = result.get("verdict", "FAIL");

        if (result.get("verdict") == "PASS") {
            target_kol["payment_status"] = "verified";
            _add_log(cid, "content_verified",
                "✓ Content verified for " + kol_handle,
                "Score: " + str(result.get("score", 0)) + "/100");
        } else {
            _add_log(cid, "content_failed",
                "✗ Content failed for " + kol_handle,
                str(result.get("feedback", "")));
        }
        return result;
    }

    # ——— Pay KOL ———
    def:pub pay_kol(cid: str, kol_handle: str) -> dict {
        _ensure_demos();
        if (not campaigns.get(cid)) {
            return {"error": "Campaign not found"};
        }
        c = campaigns[cid];
        mode = c.get("mode", "web3");
        target_kol: dict = {};
        for kol in c["approved_kols"] {
            if (kol["handle"] == kol_handle) {
                target_kol = kol;
                break;
            }
        }
        if (not target_kol) {
            return {"error": "KOL not found"};
        }

        amount = target_kol.get("payment_amount_usdc", 0);

        if (mode == "web3") {
            digits: list = [];
            i = 0;
            while (i < 64) {
                digits.append(str(random.randint(0, 9)));
                i = i + 1;
            }
            tx_hash = "0x" + "".join(digits);
            target_kol["payment_status"] = "paid";
            target_kol["tx_hash"] = tx_hash;
            _add_log(cid, "payment_sent",
                "💸 $" + str(amount) + " USDC → " + kol_handle,
                "Tx: " + tx_hash[:20] + "...");
            return {"tx_hash": tx_hash, "amount_usdc": amount, "explorer_url": "https://sepolia.basescan.org/tx/" + tx_hash};
        } else {
            ref_digits: list = [];
            j = 0;
            while (j < 6) {
                ref_digits.append(str(random.randint(0, 9)));
                j = j + 1;
            }
            ref_id = "PAY-" + "".join(ref_digits);
            target_kol["payment_status"] = "paid";
            target_kol["payment_ref"] = ref_id;
            _add_log(cid, "payment_sent",
                "💸 $" + str(amount) + " → " + kol_handle,
                "Ref: " + ref_id + " · via PayPal");
            return {"payment_ref": ref_id, "amount_usd": amount, "method": "PayPal"};
        }
    }
}

cl {
    def:pub app() -> JsxElement {
        # ——— Auth state ———
        has email: str = "";
        has password: str = "";
        has is_loading: bool = False;
        has error: str = "";
        has mode: str = "login";
        has is_authed: bool = False;
        has ready: bool = False;

        # ——— View state ———
        has current_view: str = "dashboard";
        has current_campaign_id: str = "";
        has current_campaign: dict = {};
        has activity_log: list = [];
        has campaign_mode: str = "web3";
        has is_launching: bool = False;

        # ——— Auth helpers ———

        def clear_error() -> None {
            if (error != "") {
                error = "";
            }
        }

        async can with entry {
            is_authed = await jacIsLoggedIn();
            ready = True;
        }

        async def submit_auth() -> None {
            clear_error();
            if (email.strip() == "" or password == "") {
                error = "Email and password are required.";
                return;
            }
            is_loading = True;
            success = False;
            if (mode == "login") {
                success = await jacLogin(email.strip().lower(), password);
            } else {
                success = await jacSignup(email.strip().lower(), password);
            }
            if (not success) {
                error = "Authentication failed.";
                is_loading = False;
                return;
            }
            is_authed = True;
            password = "";
            is_loading = False;
        }

        async def logout() -> None {
            await jacLogout();
            is_authed = False;
            current_view = "dashboard";
            current_campaign_id = "";
            current_campaign = {};
        }

        # ——— Campaign actions ———

        async def load_demo(demo_id: str) -> None {
            current_campaign = await get_campaign(demo_id);
            current_campaign_id = demo_id;
            campaign_mode = current_campaign["mode"] or "web3";
            activity_log = current_campaign["activity_log"] or [];
            current_view = "proposal";
        }

        async def launch_campaign(form_data: dict) -> None {
            fd_mode = form_data["mode"] or "web3";
            fd_min = form_data["min_kol_score"] or 65;

            # Show loading state immediately
            is_launching = True;

            # Create server-side campaign (returns campaign ID string)
            current_campaign_id = await create_campaign(form_data);
            campaign_mode = fd_mode;

            # Run the full pipeline (blocks but that's OK — we show loading spinner)
            await run_pipeline(current_campaign_id);

            # Fetch completed campaign
            current_campaign = await get_campaign(current_campaign_id);
            activity_log = current_campaign["activity_log"] or [];

            is_launching = False;

            # Go straight to proposal
            current_view = "proposal";
        }

        async def handle_approve() -> None {
            await approve_campaign(current_campaign_id);
            current_campaign = await get_campaign(current_campaign_id);
            activity_log = current_campaign["activity_log"] or [];
            current_view = "live";
        }

        async def handle_verify(kol_handle: str, content_url: str) -> None {
            await verify_kol_content(current_campaign_id, kol_handle, content_url);
            current_campaign = await get_campaign(current_campaign_id);
            activity_log = current_campaign["activity_log"] or [];
        }

        async def handle_pay(kol_handle: str) -> None {
            await pay_kol(current_campaign_id, kol_handle);
            current_campaign = await get_campaign(current_campaign_id);
            activity_log = current_campaign["activity_log"] or [];
        }

        def go_to_dashboard() -> None {
            current_view = "dashboard";
            current_campaign_id = "";
            current_campaign = {};
        }

        # ——— Render ———

        if (not ready) {
            return <div style={{
                "minHeight": "100vh",
                "display": "flex",
                "alignItems": "center",
                "justifyContent": "center",
                "background": "#080C10",
                "color": "#E8EDF2"
            }}>
                <p>Loading CampaignMind...</p>
        </div>;
        }

        if (not is_authed) {
            return <LoginForm
                email={email}
                password={password}
                error={error}
                is_loading={is_loading}
                mode={mode}
                on_email_change={lambda event -> None { email = event.target.value; clear_error(); }}
                on_password_change={lambda event -> None { password = event.target.value; clear_error(); }}
                on_submit={submit_auth}
                on_toggle_mode={lambda -> None {
                    if (mode == "login") {
                        mode = "register";
                    } else {
                        mode = "login";
                    }
                    clear_error();
                }}
            />;
        }

        # ——— Authenticated views ———

        if (current_view == "running") {
            return <AgentRunning
                campaign={current_campaign}
                activity_log={activity_log}
                on_proposal_ready={lambda -> None { current_view = "proposal"; }}
            />;
        }

        if (current_view == "proposal") {
            return <ProposalView
                campaign={current_campaign}
                on_approve={handle_approve}
                on_back={go_to_dashboard}
            />;
        }

        if (current_view == "live") {
            return <LiveDashboard
                campaign={current_campaign}
                activity_log={activity_log}
                on_verify={handle_verify}
                on_pay={handle_pay}
            />;
        }

        if (is_launching) {
            return <div style={{
                "minHeight": "100vh",
                "background": "#080C10",
                "color": "#E8EDF2",
                "fontFamily": "'Syne', Arial, sans-serif",
                "display": "flex",
                "flexDirection": "column",
                "alignItems": "center",
                "justifyContent": "center"
            }}>
                <style>{"""
                    @keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
                    @keyframes pulse2 { 0%,100% { opacity: 1; } 50% { opacity: 0.5; } }
                """}</style>
                <div style={{
                    "width": "64px",
                    "height": "64px",
                    "border": "3px solid rgba(0,229,160,0.2)",
                    "borderTop": "3px solid #00E5A0",
                    "borderRadius": "50%",
                    "animation": "spin 1s linear infinite",
                    "marginBottom": "24px"
                }}></div>
                <h2 style={{
                    "fontSize": "22px",
                    "fontWeight": "800",
                    "letterSpacing": "-0.5px",
                    "marginBottom": "8px"
                }}>🤖 Agent Working...</h2>
                <p style={{
                    "fontSize": "14px",
                    "color": "#5A6A7A",
                    "marginBottom": "4px"
                }}>Running the full campaign pipeline</p>
                <p style={{
                    "fontSize": "12px",
                    "color": "#5A6A7A",
                    "fontFamily": "'DM Mono', monospace",
                    "animation": "pulse2 2s infinite"
                }}>Profiling → Discovery → Vetting → Proposal</p>
            </div>;
        }

        # Default: Dashboard
        return <Dashboard
            on_logout={logout}
            on_load_demo={load_demo}
            on_launch={launch_campaign}
        />;
    }
}
