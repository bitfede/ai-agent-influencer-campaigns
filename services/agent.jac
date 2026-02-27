"""CampaignMind AI Agent — 5 core functions powered by Jac's native by llm().

Uses byllm plugin with gpt-4o-mini (fast, cheap).
Set OPENAI_API_KEY in your environment before running.

Functions:
  1. build_intelligence_profile  — brand intake → Campaign Intelligence Profile
  2. vet_kol                     — score & verdict a single KOL
  3. build_proposal              — approved KOLs → campaign proposal with budget
  4. write_outreach              — personalized outreach DM per KOL
  5. verify_content              — verify submitted content against brief
"""

# ───────────────────────────────────────────
# Prompt Constants
# ───────────────────────────────────────────

glob MASTER_PROMPT: str = """You are CampaignMind, an autonomous influencer marketing agent for Web3 crypto projects.
You are analytical, precise, and fiercely protective of campaign budgets.
You make decisions based on data. You explain every decision clearly.
You output only valid JSON unless instructed otherwise.""";

glob PROFILE_INSTRUCTIONS: str = """Build a Campaign Intelligence Profile from the brand intake data provided.
Return JSON with these exact keys:
- ecosystem_focus: list of blockchain ecosystems to target
- min_engagement_rate: float, minimum acceptable engagement rate
- ideal_follower_min: int, minimum follower count for KOLs
- ideal_follower_max: int, maximum follower count for KOLs
- categories: list of content categories to match (from: Base, DeFi, AI, Trading, Education)
- campaign_narrative: str, 2 sentences describing the campaign angle
- budget_breakdown: object with keys tier_1_pct (float), tier_2_pct (float), tier_3_pct (float) summing to 1.0
- hard_disqualifiers: list of strings describing automatic rejection criteria""";

glob VET_KOL_INSTRUCTIONS: str = """Score this KOL for the given campaign profile.

Score out of 100 across these dimensions:
- engagement_authenticity (30 pts): Is the engagement rate healthy for their follower count? Is comment quality high?
- reputation_trust (25 pts): Any rug promotion history? What is their disclosure rate?
- audience_fit (25 pts): Do their content categories match the campaign categories?
- content_quality (20 pts): Original analysis vs pure shill? Educational value?

Hard reject rules (verdict must be hard_rejected):
- rug_promotions > 0
- account_age_days < 180
- comment_quality is low AND engagement_rate < 2.0

Tier assignment:
- tier_1: score >= 85
- tier_2: score >= 70 and score < 85
- tier_3: score >= 60 and score < 70
- null: score < 60 (rejected)

Return JSON with these exact keys:
- score: int 0-100
- verdict: str, one of approved / rejected / hard_rejected
- score_breakdown: dict with keys engagement_authenticity, reputation_trust, audience_fit, content_quality (each int)
- tier: str tier_1 / tier_2 / tier_3 or null
- key_strengths: list of 2 strings
- key_risks: list of 2 strings
- rejection_reason: str or null""";

glob PROPOSAL_INSTRUCTIONS: str = """Build a campaign proposal for brand approval.

Budget allocation rules:
- Tier 1 KOLs get 40% of total budget, divided equally among tier 1 KOLs
- Tier 2 KOLs get 40% of total budget, divided equally among tier 2 KOLs
- Tier 3 KOLs get 20% of total budget, divided equally among tier 3 KOLs
- Round budget_usdc per KOL to nearest integer

Return JSON with these exact keys:
- campaign_summary: str, 2-3 sentence overview
- kol_roster: list of objects, each with keys: handle (str), tier (str), role (str describing their campaign role), budget_usdc (int), expected_reach (int)
- timeline: list of objects, each with keys: day (int), action (str describing what happens)
- total_expected_reach: int
- agent_recommendation: str, 3 sentences with the agent's recommendation
- total_approved: int, number of approved KOLs
- total_rejected: int, number of rejected KOLs from the vetting phase""";

glob OUTREACH_INSTRUCTIONS: str = """Write a personalized outreach DM to this KOL for the campaign.

Rules:
- Under 120 words
- Reference one specific thing from their recent content or style
- State the USDC payment amount clearly
- Mention that payment releases automatically on content verification
- End with one clear call to action
- Use crypto-native tone, not corporate speak
- Return plain text only, no JSON, no markdown formatting""";

glob VERIFY_INSTRUCTIONS: str = """A KOL submitted content for payment verification.

For demo purposes, simulate verification based on the URL and KOL quality data.
If the KOL score is above 70, lean toward PASS with score 75-95.
If the KOL score is below 65, lean toward FAIL with score 30-55.
Add realistic variation and detailed feedback.

Return JSON with these exact keys:
- verdict: str, PASS or FAIL
- score: int 0-100
- score_breakdown: object with keys brand_message (int out of 30), content_quality (int out of 25), engagement_estimate (int out of 20), audience_reception (int out of 25)
- feedback: str, 2 sentences of specific feedback
- payment_authorized: bool, true only if verdict is PASS""";

# ───────────────────────────────────────────
# Core LLM Functions (by llm)
# ───────────────────────────────────────────

def _build_intelligence_profile_llm(
    intake: dict  # "Brand intake data: brand_name, goal, budget_usdc, timeline_days, target_audience, content_type, campaign_brief, min_kol_score"
) -> dict         # "Campaign Intelligence Profile as JSON"
    by llm(model="gpt-4o-mini", temperature=0.3, incl_info=(MASTER_PROMPT, PROFILE_INSTRUCTIONS));

def _vet_kol_llm(
    kol: dict      # "KOL data: handle, followers, engagement_rate, account_age_days, categories, rug_promotions, disclosure_rate, comment_quality, recent_posts"
  , profile: dict  # "Campaign Intelligence Profile: ecosystem_focus, categories, min_engagement_rate, hard_disqualifiers"
) -> dict          # "Vetting result: score, verdict, score_breakdown, tier, key_strengths, key_risks, rejection_reason"
    by llm(model="gpt-4o-mini", temperature=0.3, incl_info=(MASTER_PROMPT, VET_KOL_INSTRUCTIONS));

def _build_proposal_llm(
    approved_kols: list  # "List of approved KOL dicts with handle, tier, score, followers, estimated_price_usd"
  , campaign: dict       # "Campaign data: brand_name, goal, budget_usdc, timeline_days, target_audience, campaign_brief, content_type"
) -> dict                # "Campaign proposal: campaign_summary, kol_roster, timeline, total_expected_reach, agent_recommendation, total_approved, total_rejected"
    by llm(model="gpt-4o-mini", temperature=0.3, incl_info=(MASTER_PROMPT, PROPOSAL_INSTRUCTIONS));

def _write_outreach_llm(
    kol: dict       # "KOL profile: handle, followers, tier, score, recent_posts, estimated_price_usd"
  , campaign: dict  # "Campaign data: brand_name, goal, campaign_brief, content_type"
  , payment_amount: float  # "USDC payment amount for this KOL"
) -> str            # "Personalized outreach DM as plain text, under 120 words"
    by llm(model="gpt-4o-mini", temperature=0.3, incl_info=(MASTER_PROMPT, OUTREACH_INSTRUCTIONS));

def _verify_content_llm(
    content_url: str  # "URL of the submitted content to verify"
  , kol: dict         # "KOL profile: handle, score, tier, followers"
  , campaign_brief: str  # "The original campaign brief to verify content against"
) -> dict             # "Verification result: verdict, score, score_breakdown, feedback, payment_authorized"
    by llm(model="gpt-4o-mini", temperature=0.3, incl_info=(MASTER_PROMPT, VERIFY_INSTRUCTIONS));

# ───────────────────────────────────────────
# Safe Public Wrappers (try/except)
# ───────────────────────────────────────────

def:pub build_intelligence_profile(intake: dict) -> dict {
    """Build a Campaign Intelligence Profile from brand intake data."""
    try {
        return _build_intelligence_profile_llm(intake);
    } except Exception as e {
        return {"error": "Failed to build intelligence profile: " + str(e)};
    }
}

def:pub vet_kol(kol: dict, profile: dict) -> dict {
    """Score and vet a single KOL against a campaign profile."""
    try {
        return _vet_kol_llm(kol, profile);
    } except Exception as e {
        return {"error": "Failed to vet KOL: " + str(e), "score": 0, "verdict": "rejected", "rejection_reason": str(e)};
    }
}

def:pub build_proposal(approved_kols: list, campaign: dict) -> dict {
    """Generate a campaign proposal with budget allocation across approved KOLs."""
    try {
        return _build_proposal_llm(approved_kols, campaign);
    } except Exception as e {
        return {"error": "Failed to build proposal: " + str(e)};
    }
}

def:pub write_outreach(kol: dict, campaign: dict, payment_amount: float = 0.0) -> str {
    """Write a personalized outreach DM to a KOL."""
    try {
        return _write_outreach_llm(kol, campaign, payment_amount);
    } except Exception as e {
        return "Error generating outreach: " + str(e);
    }
}

def:pub verify_content(content_url: str, kol: dict, campaign: dict) -> dict {
    """Verify submitted content against the campaign brief."""
    try {
        brief = "";
        if ("campaign_brief" in campaign) {
            brief = campaign["campaign_brief"];
        }
        return _verify_content_llm(content_url, kol, brief);
    } except Exception as e {
        return {"error": "Failed to verify content: " + str(e), "verdict": "FAIL", "payment_authorized": False};
    }
}
