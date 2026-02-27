"""Login and signup view for the client app."""

cl import from .Button { Button }

def:pub LoginForm(
    email: str,
    password: str,
    error: str,
    is_loading: bool,
    mode: str,
    on_email_change: any,
    on_password_change: any,
    on_submit: any,
    on_toggle_mode: any
) -> JsxElement {
    error_block = None;
    heading = "Welcome back";
    subheading = "Sign in to access your workspace.";
    button_label = "Sign in";
    toggle_label = "Need an account? Create one";

    if (error != "") {
        error_block = <div style={{"color": "#dc2626"}}>{error}</div>;
    }
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
                        onChange={on_email_change}
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
                        onChange={on_password_change}
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
                    onClick={on_submit}
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
                    onClick={on_toggle_mode}
                >
                    {toggle_label}
                </button>
            </div>
        </div>
    </div>;
}
