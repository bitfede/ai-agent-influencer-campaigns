"""Main entry point for ai-agent-hackathon."""

cl import from "@jac/runtime" { jacLogin, jacSignup, jacLogout, jacIsLoggedIn }
cl import from .components.Dashboard { Dashboard }
cl import from .components.Login { LoginForm }

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
# Server Logic
# ───────────────────────────────────────────

sv {
    def:pub get_private_area() -> str {
        return "This is your private SaaS area. We'll build it out next.";
    }
}

cl {
    def:pub app() -> JsxElement {
        has email: str = "";
        has password: str = "";
        has is_loading: bool = False;
        has error: str = "";
        has mode: str = "login";
        has is_authed: bool = False;
        has ready: bool = False;
        has private_message: str = "";

        def clear_error() -> None {
            if (error != "") {
                error = "";
            }
        }

        async can with entry {
            is_authed = await jacIsLoggedIn();
            if (is_authed) {
                private_message = await get_private_area();
            }
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
            private_message = await get_private_area();
            password = "";
            is_loading = False;
        }

        async def logout() -> None {
            await jacLogout();
            is_authed = False;
            private_message = "";
        }

        if (not ready) {
            return <div style={{
                "minHeight": "100vh",
                "display": "flex",
                "alignItems": "center",
                "justifyContent": "center",
                "fontFamily": "Arial, sans-serif"
            }}>
                <p>Loading...</p>
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

        return <Dashboard private_message={private_message} on_logout={logout} />;
    }
}
