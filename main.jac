"""Main entry point for ai-agent-hackathon."""

cl import from .components.Button { Button }
cl import from "@jac/runtime" { jacLogin, jacSignup, jacLogout, jacIsLoggedIn }

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
            error_block = None;
            if (error != "") {
                error_block = <div style={{"color": "#dc2626"}}>{error}</div>;
            }
            heading = "Welcome back";
            subheading = "Sign in to access your workspace.";
            button_label = "Sign in";
            toggle_label = "Need an account? Create one";
            if (mode != "login") {
                heading = "Create your account";
                subheading = "Start your workspace in minutes.";
                button_label = "Create account";
                toggle_label = "Have an account? Sign in";
            }

            return <div style={{
                "minHeight": "100vh",
                "display": "flex",
                "alignItems": "center",
                "justifyContent": "center",
                "background": "#f3f4f6",
                "fontFamily": "Arial, sans-serif",
                "padding": "2rem"
            }}>
                <div style={{
                    "width": "100%",
                    "maxWidth": "420px",
                    "background": "#ffffff",
                    "padding": "2rem",
                    "borderRadius": "0.75rem",
                    "boxShadow": "0 10px 25px rgba(0,0,0,0.08)"
                }}>
                    <h1 style={{"marginBottom": "0.5rem"}}>{heading}</h1>
                    <p style={{"color": "#6b7280", "marginBottom": "1.5rem"}}>{subheading}</p>
                    <div style={{"display": "flex", "flexDirection": "column", "gap": "1rem"}}>
                        <div style={{"display": "flex", "flexDirection": "column", "gap": "0.5rem"}}>
                            <label>Email</label>
                            <input
                                type="email"
                                value={email}
                                onChange={lambda event -> None { email = event.target.value; clear_error(); }}
                                style={{
                                    "padding": "0.75rem",
                                    "borderRadius": "0.5rem",
                                    "border": "1px solid #d1d5db"
                                }}
                                placeholder="you@company.com"
                            />
                        </div>
                        <div style={{"display": "flex", "flexDirection": "column", "gap": "0.5rem"}}>
                            <label>Password</label>
                            <input
                                type="password"
                                value={password}
                                onChange={lambda event -> None { password = event.target.value; clear_error(); }}
                                style={{
                                    "padding": "0.75rem",
                                    "borderRadius": "0.5rem",
                                    "border": "1px solid #d1d5db"
                                }}
                                placeholder="At least 8 characters"
                            />
                        </div>
                        {error_block}
                        <Button
                            label={button_label}
                            onClick={submit_auth}
                            variant="primary"
                            disabled={is_loading}
                        />
                        <button
                            style={{
                                "background": "none",
                                "border": "none",
                                "color": "#2563eb",
                                "cursor": "pointer",
                                "textAlign": "left",
                                "padding": "0"
                            }}
                            onClick={lambda -> None {
                                if (mode == "login") {
                                    mode = "register";
                                } else {
                                    mode = "login";
                                }
                                clear_error();
                            }}
                        >
                            {toggle_label}
                        </button>
                    </div>
                </div>
            </div>;
        }

        return <div style={{
            "minHeight": "100vh",
            "background": "linear-gradient(180deg, #f8fafc 0%, #eef2ff 60%, #ffffff 100%)",
            "fontFamily": "Arial, sans-serif",
            "color": "#0f172a"
        }}>
            <header style={{
                "position": "sticky",
                "top": "0",
                "zIndex": "10",
                "background": "rgba(255,255,255,0.9)",
                "backdropFilter": "blur(10px)",
                "borderBottom": "1px solid #e2e8f0"
            }}>
                <div style={{
                    "maxWidth": "1120px",
                    "margin": "0 auto",
                    "display": "flex",
                    "alignItems": "center",
                    "justifyContent": "space-between",
                    "padding": "1rem 1.5rem"
                }}>
                    <div style={{"display": "flex", "alignItems": "center", "gap": "0.75rem"}}>
                        <div style={{
                            "width": "36px",
                            "height": "36px",
                            "borderRadius": "12px",
                            "background": "linear-gradient(135deg, #6366f1, #8b5cf6)"
                        }} />
                        <div>
                            <div style={{"fontWeight": "700"}}>Velric</div>
                            <div style={{"fontSize": "0.75rem", "color": "#64748b"}}>Workspace</div>
                        </div>
                    </div>
                    <div style={{"display": "flex", "alignItems": "center", "gap": "1rem"}}>
                        <div style={{
                            "fontSize": "0.875rem",
                            "color": "#475569",
                            "padding": "0.35rem 0.75rem",
                            "borderRadius": "999px",
                            "background": "#e2e8f0"
                        }}>
                            Private area
                        </div>
                        <Button label="Sign out" onClick={logout} variant="secondary" />
                    </div>
                </div>
            </header>
            <main style={{"padding": "2.5rem 1.5rem"}}>
                <div style={{
                    "maxWidth": "1120px",
                    "margin": "0 auto",
                    "display": "flex",
                    "flexDirection": "column",
                    "gap": "2rem"
                }}>
                    <section style={{
                        "display": "flex",
                        "flexDirection": "column",
                        "gap": "0.5rem"
                    }}>
                        <h1 style={{"margin": "0", "fontSize": "2rem"}}>Private Workspace</h1>
                        <p style={{"margin": "0", "color": "#64748b"}}>
                            {private_message}
                        </p>
                    </section>
                    <section style={{
                        "display": "grid",
                        "gridTemplateColumns": "repeat(auto-fit, minmax(220px, 1fr))",
                        "gap": "1rem"
                    }}>
                        <div style={{
                            "background": "#ffffff",
                            "borderRadius": "1rem",
                            "padding": "1.25rem",
                            "boxShadow": "0 12px 30px rgba(15,23,42,0.08)",
                            "border": "1px solid #e2e8f0"
                        }}>
                            <div style={{"fontSize": "0.75rem", "color": "#64748b"}}>Usage</div>
                            <div style={{"fontSize": "1.5rem", "fontWeight": "700"}}>0</div>
                            <div style={{"color": "#94a3b8"}}>Events tracked</div>
                        </div>
                        <div style={{
                            "background": "#ffffff",
                            "borderRadius": "1rem",
                            "padding": "1.25rem",
                            "boxShadow": "0 12px 30px rgba(15,23,42,0.08)",
                            "border": "1px solid #e2e8f0"
                        }}>
                            <div style={{"fontSize": "0.75rem", "color": "#64748b"}}>Team</div>
                            <div style={{"fontSize": "1.5rem", "fontWeight": "700"}}>1</div>
                            <div style={{"color": "#94a3b8"}}>Active members</div>
                        </div>
                        <div style={{
                            "background": "#ffffff",
                            "borderRadius": "1rem",
                            "padding": "1.25rem",
                            "boxShadow": "0 12px 30px rgba(15,23,42,0.08)",
                            "border": "1px solid #e2e8f0"
                        }}>
                            <div style={{"fontSize": "0.75rem", "color": "#64748b"}}>Plan</div>
                            <div style={{"fontSize": "1.5rem", "fontWeight": "700"}}>Starter</div>
                            <div style={{"color": "#94a3b8"}}>Upgrade anytime</div>
                        </div>
                    </section>
                    <section style={{
                        "background": "#ffffff",
                        "borderRadius": "1.25rem",
                        "padding": "2rem",
                        "boxShadow": "0 20px 45px rgba(15,23,42,0.08)",
                        "border": "1px solid #e2e8f0",
                        "minHeight": "320px"
                    }}>
                        <div style={{"display": "flex", "flexDirection": "column", "gap": "0.75rem"}}>
                            <div style={{
                                "display": "inline-flex",
                                "alignItems": "center",
                                "gap": "0.5rem",
                                "fontSize": "0.75rem",
                                "letterSpacing": "0.08em",
                                "textTransform": "uppercase",
                                "color": "#6366f1"
                            }}>
                                Next step
                            </div>
                            <h2 style={{"margin": "0"}}>Build your workspace</h2>
                            <p style={{"margin": "0", "color": "#64748b"}}>
                                We will design this area together. Use this space for dashboards,
                                workflows, and anything your team needs.
                            </p>
                        </div>
                        <div style={{
                            "marginTop": "2rem",
                            "borderRadius": "1rem",
                            "border": "2px dashed #cbd5f5",
                            "background": "linear-gradient(135deg, rgba(99,102,241,0.08), rgba(139,92,246,0.06))",
                            "minHeight": "200px",
                            "display": "flex",
                            "alignItems": "center",
                            "justifyContent": "center",
                            "color": "#94a3b8"
                        }}>
                            Blank space reserved for the next step.
                        </div>
                    </section>
                </div>
            </main>
        </div>;
    }
}
