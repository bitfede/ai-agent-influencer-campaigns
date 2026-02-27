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
    has content_type: str = "";
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

    # ——— Create new campaign ———
    def:pub create_campaign(
        brand_name: str,
        goal: str,
        budget_usdc: float,
        timeline_days: int,
        target_audience: list,
        content_type: str,
        campaign_brief: str,
        min_kol_score: int = 65,
        mode: str = "web3"
    ) -> dict {
        _ensure_demos();
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
        return {"campaign_id": cid, "status": "onboarding"};
    }

    # ——— Run full pipeline (called after create) ———
    def:pub run_pipeline(cid: str) -> dict {
        _ensure_demos();
        if (not campaigns.get(cid)) {
            return {"error": "Campaign not found"};
        }
        c = campaigns[cid];
        mode = c.get("mode", "web3");

        # Stage 1: Intelligence Profile
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

        # Stage 2: Discovery
        c["status"] = "discovering";
        _add_log(cid, "discovery_start", "Querying Influur database...", "Mode: " + mode);
        candidates = get_candidates(mode=mode);
        _add_log(cid, "discovery_done", str(len(candidates)) + " candidates found", "Passing to vetting engine");

        # Stage 3: Vetting
        c["status"] = "vetting";
        approved: list = [];
        rejected: list = [];
        for kol in candidates {
            result = vet_kol(kol, profile);
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
        }
        c["approved_kols"] = approved;
        c["rejected_kols"] = rejected;

        # Stage 4: Proposal
        c["status"] = "building_proposal";
        _add_log(cid, "proposal_start", "Generating campaign proposal...",
            str(len(approved)) + " approved, " + str(len(rejected)) + " rejected");
        proposal = build_proposal(approved, c);
        c["proposal"] = proposal;
        c["status"] = "proposal_ready";
        _add_log(cid, "proposal_done", "✓ Proposal ready for approval",
            "Expected reach: " + str(proposal.get("total_expected_reach", "N/A")));

        return {"status": "proposal_ready", "approved": len(approved), "rejected": len(rejected)};
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

        # ——— Auth helpers ———

        def clear_error() -> None {
            if (error != "") {
                error = "";
            }
        }

        async can with entry {
            is_authed = await jacIsLoggedIn();
            ready = True;
            # #region agent log
            setTimeout(lambda -> None {
                bs = window.getComputedStyle(document.body);
                tb = document.querySelector(".topbar");
                ct = document.querySelector(".content");
                h1el = document.querySelector(".topbar-left h1");
                pel = document.querySelector(".topbar-left p");
                tb_s = "none";
                h1_s = "none";
                p_s = "none";
                ct_t = 0;
                tb_h = 0;
                tb_b = 0;
                if (tb) {
                    tb_h = tb.offsetHeight;
                    tb_b = tb.getBoundingClientRect().bottom;
                    tb_s = window.getComputedStyle(tb).padding;
                }
                if (ct) {
                    ct_t = ct.getBoundingClientRect().top;
                }
                if (h1el) {
                    h1_s = window.getComputedStyle(h1el).margin;
                }
                if (pel) {
                    p_s = window.getComputedStyle(pel).margin;
                }
                fetch("http://127.0.0.1:7242/ingest/e31488d5-7723-4d02-978f-319d2733ddbc", {"method": "POST", "headers": {"Content-Type": "application/json"}, "body": JSON.stringify({"location": "main.jac:app:entry", "message": "layout-debug", "hypothesisId": "H1-H5", "runId": "run1", "timestamp": Date.now(), "data": {"bodyMargin": bs.margin, "bodyPadding": bs.padding, "topbarHeight": tb_h, "topbarBottom": tb_b, "topbarPadding": tb_s, "contentTop": ct_t, "h1Margin": h1_s, "pMargin": p_s}})});
            }, 2000);
            # #endregion agent log
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
            result = await create_campaign(
                brand_name=form_data["brand_name"],
                goal=form_data["goal"],
                budget_usdc=form_data["budget_usdc"],
                timeline_days=form_data["timeline_days"],
                target_audience=form_data["target_audience"],
                content_type=form_data["content_type"],
                campaign_brief=form_data["campaign_brief"],
                min_kol_score=fd_min,
                mode=fd_mode
            );
            current_campaign_id = result["campaign_id"];
            campaign_mode = fd_mode;
            current_view = "running";
            # Start pipeline
            await run_pipeline(current_campaign_id);
            # Refresh campaign data
            current_campaign = await get_campaign(current_campaign_id);
            activity_log = current_campaign["activity_log"] or [];
            # Auto-advance to proposal if ready
            if (current_campaign["status"] == "proposal_ready") {
                current_view = "proposal";
            }
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

        # Default: Dashboard
        return <Dashboard
            on_logout={logout}
            on_load_demo={load_demo}
            on_launch={launch_campaign}
        />;
    }
}
