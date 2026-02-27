"""Pre-loaded demo campaigns for hackathon judges.
These campaigns are already at proposal_ready status with full data."""

glob DEMO_WEB3_CAMPAIGN: dict = {
    "id": "demo-doge-001",
    "mode": "web3",
    "brand_name": "Dogecoin",
    "goal": "Community Growth",
    "budget_usdc": 25000,
    "timeline_days": 14,
    "status": "proposal_ready",
    "target_audience": ["Meme Community", "Crypto Traders", "DeFi Users"],
    "content_type": "Twitter Threads",
    "campaign_brief": "Drive Dogecoin community growth and awareness ahead of the DOGE ecosystem expansion. KOLs should highlight Dogecoin utility beyond memes — tipping, payments, DeFi integrations on Dogechain. Meme-friendly tone encouraged but must include real use cases.",
    "min_kol_score": 65,
    "created_at": "2026-02-27T10:00:00Z",
    "intelligence_profile": {
        "ecosystem_focus": ["Dogecoin", "Meme Coins", "DeFi"],
        "min_engagement_rate": 4.0,
        "ideal_follower_min": 50000,
        "ideal_follower_max": 500000,
        "categories": ["Base", "AI", "DeFi", "Trading"],
        "campaign_narrative": "Dogecoin is expanding beyond memes into real DeFi utility with Dogechain integrations and merchant payments. This campaign targets the intersection of meme culture and serious crypto adoption, reaching both retail traders and DeFi power users.",
        "budget_breakdown": {"tier_1_pct": 0.4, "tier_2_pct": 0.4, "tier_3_pct": 0.2},
        "hard_disqualifiers": ["Any rug promotion history", "Account under 6 months", "Bot-driven engagement"]
    },
    "approved_kols": [
        {"handle": "@based_builder", "followers": 187000, "engagement_rate": 8.4, "score": 92, "verdict": "approved", "tier": "tier_1", "payment_amount_usdc": 10000, "payment_status": "unpaid", "wallet_address": "0x4f2a8B3c91D7eF06A42b1C9dE5f8A3e71c2B09aD", "content_url": "", "tx_hash": "", "outreach_message": "", "verification_verdict": "", "verification_score": 0, "rejection_reason": "", "score_breakdown": {"engagement_authenticity": 28, "reputation_trust": 25, "audience_fit": 23, "content_quality": 16}, "key_strengths": ["Top-tier crypto ecosystem coverage", "Consistently high engagement with quality meme + alpha content"], "key_risks": ["Premium pricing", "May be overbooked with campaign requests"]},
        {"handle": "@defi_maven", "followers": 224000, "engagement_rate": 7.9, "score": 85, "verdict": "approved", "tier": "tier_2", "payment_amount_usdc": 3500, "payment_status": "unpaid", "wallet_address": "0x7aE1c3D9f5B24680eA31d8C7bF09e4A62dF8c11B", "content_url": "", "tx_hash": "", "outreach_message": "", "verification_verdict": "", "verification_score": 0, "rejection_reason": "", "score_breakdown": {"engagement_authenticity": 26, "reputation_trust": 23, "audience_fit": 22, "content_quality": 14}, "key_strengths": ["Strong DeFi audience overlap with DOGE holders", "Transparent paid disclosure history"], "key_risks": ["High follower count may dilute meme targeting", "Competes with multiple brand deals"]},
        {"handle": "@ai_agent_alpha", "followers": 156000, "engagement_rate": 9.1, "score": 80, "verdict": "approved", "tier": "tier_2", "payment_amount_usdc": 3000, "payment_status": "unpaid", "wallet_address": "0xB3d7F2a9c8E14D6b5A0f3C7e9d1B8A4F6c2E50aA", "content_url": "", "tx_hash": "", "outreach_message": "", "verification_verdict": "", "verification_score": 0, "rejection_reason": "", "score_breakdown": {"engagement_authenticity": 27, "reputation_trust": 20, "audience_fit": 19, "content_quality": 14}, "key_strengths": ["Highest engagement rate in pool", "Can bridge DOGE with AI agent narrative"], "key_risks": ["Newer account compared to tier 1", "AI niche may not fully overlap with meme community"]},
        {"handle": "@crypto_educator", "followers": 175000, "engagement_rate": 4.9, "score": 77, "verdict": "approved", "tier": "tier_2", "payment_amount_usdc": 3500, "payment_status": "unpaid", "wallet_address": "0xA8c3E1d7B2f6490eC5b8D1a3F9e7C4b6d2A8F01E", "content_url": "", "tx_hash": "", "outreach_message": "", "verification_verdict": "", "verification_score": 0, "rejection_reason": "", "score_breakdown": {"engagement_authenticity": 20, "reputation_trust": 22, "audience_fit": 20, "content_quality": 15}, "key_strengths": ["Strong educational content — perfect for explaining DOGE utility", "Established trust with beginner audience"], "key_risks": ["Lower engagement rate", "Audience may need more meme energy"]},
        {"handle": "@agent_maxi", "followers": 89000, "engagement_rate": 6.5, "score": 69, "verdict": "approved", "tier": "tier_3", "payment_amount_usdc": 3000, "payment_status": "unpaid", "wallet_address": "0x9cA1e3D7b2F8460dE5a8C1B4f6D9E3c7a2B1F04D", "content_url": "", "tx_hash": "", "outreach_message": "", "verification_verdict": "", "verification_score": 0, "rejection_reason": "", "score_breakdown": {"engagement_authenticity": 20, "reputation_trust": 18, "audience_fit": 18, "content_quality": 13}, "key_strengths": ["Strong meme game with substance", "Growing audience in crypto-native niche"], "key_risks": ["Smaller reach", "Account under 2 years"]},
        {"handle": "@yield_hunter_ct", "followers": 98000, "engagement_rate": 5.6, "score": 66, "verdict": "approved", "tier": "tier_3", "payment_amount_usdc": 2000, "payment_status": "unpaid", "wallet_address": "0x5eB1d8C3a7F9420bE6c1D9A4f3B7E8c2d6A1F09B", "content_url": "", "tx_hash": "", "outreach_message": "", "verification_verdict": "", "verification_score": 0, "rejection_reason": "", "score_breakdown": {"engagement_authenticity": 18, "reputation_trust": 17, "audience_fit": 17, "content_quality": 14}, "key_strengths": ["Active DeFi community member", "Can cover DOGE yield opportunities on Dogechain"], "key_risks": ["Borderline score", "Medium comment quality"]}
    ],
    "rejected_kols": [
        {"handle": "@pump_king", "score": 28, "verdict": "hard_rejected", "rejection_reason": "Confirmed rug promotion: SafeMoon2 (Dec 2024). Auto-rejected per campaign guardrails — cannot risk Dogecoin brand association.", "tier": ""},
        {"handle": "@shillmaster_9000", "score": 34, "verdict": "rejected", "rejection_reason": "89% fake engagement detected via comment analysis. Follower-to-engagement ratio indicates bot activity.", "tier": ""},
        {"handle": "@anon_trader_xyz", "score": 41, "verdict": "rejected", "rejection_reason": "Account age: 90 days (minimum requirement: 180 days). Insufficient track record for campaign inclusion.", "tier": ""}
    ],
    "proposal": {
        "campaign_summary": "Dogecoin Community Growth campaign targeting meme culture, crypto traders, and DeFi users with 6 vetted KOLs across 3 tiers. The roster combines meme virality with educational depth to drive both awareness and real utility adoption. $25,000 USDC budget across 14 days.",
        "kol_roster": [
            {"handle": "@based_builder", "tier": "tier_1", "role": "Anchor thread — Dogecoin ecosystem deep dive: from memes to DeFi utility", "budget_usdc": 10000, "expected_reach": 950000},
            {"handle": "@defi_maven", "tier": "tier_2", "role": "DeFi comparison — DOGE yield farming on Dogechain vs ETH L2s", "budget_usdc": 3500, "expected_reach": 560000},
            {"handle": "@ai_agent_alpha", "tier": "tier_2", "role": "Thread: AI agents meet Dogecoin — the future of meme-powered automation", "budget_usdc": 3000, "expected_reach": 490000},
            {"handle": "@crypto_educator", "tier": "tier_2", "role": "Beginner guide — How to use Dogecoin for payments and DeFi in 2026", "budget_usdc": 3500, "expected_reach": 430000},
            {"handle": "@agent_maxi", "tier": "tier_3", "role": "Meme thread — Why Dogecoin outlasted every other meme coin", "budget_usdc": 3000, "expected_reach": 340000},
            {"handle": "@yield_hunter_ct", "tier": "tier_3", "role": "Yield analysis — Dogechain staking and LP opportunities breakdown", "budget_usdc": 2000, "expected_reach": 250000}
        ],
        "timeline": [
            {"day": 1, "action": "Campaign kickoff — lock $25,000 USDC in agent wallet"},
            {"day": 2, "action": "Distribute briefs and Dogecoin brand guidelines to all 6 KOLs"},
            {"day": 3, "action": "Tier 1: @based_builder publishes anchor Dogecoin ecosystem thread"},
            {"day": 5, "action": "Tier 2: @defi_maven, @ai_agent_alpha, @crypto_educator publish"},
            {"day": 7, "action": "Mid-campaign check — verify engagement metrics and community sentiment"},
            {"day": 8, "action": "Tier 3: @agent_maxi, @yield_hunter_ct publish supporting content"},
            {"day": 10, "action": "Content verification window opens — AI reviews all deliverables"},
            {"day": 12, "action": "Final USDC payments released for verified content"},
            {"day": 14, "action": "Campaign complete — generate performance report for Dogecoin Foundation"}
        ],
        "total_expected_reach": 3020000,
        "agent_recommendation": "This is a strong roster for a Dogecoin community growth campaign. The Tier 1 placement with @based_builder provides credibility and deep ecosystem coverage, while Tier 2 KOLs bridge the meme-to-utility narrative effectively. @agent_maxi in Tier 3 brings authentic meme energy that resonates with the DOGE community. I recommend approving — the $25K budget is well-distributed across tiers for maximum virality and education.",
        "total_approved": 6,
        "total_rejected": 3
    },
    "activity_log": [
        {"event_type": "proposal_done", "message": "✓ Proposal generated — ready for brand approval", "detail": "Expected reach: 3.0M · 6 KOLs · $25,000 budget", "timestamp": "2026-02-27T10:08:30Z"},
        {"event_type": "proposal_start", "message": "Generating campaign proposal...", "detail": "6 KOLs approved, 3 rejected", "timestamp": "2026-02-27T10:08:12Z"},
        {"event_type": "kol_approved", "message": "✓ @yield_hunter_ct approved", "detail": "Score: 66/100 — Tier 3", "timestamp": "2026-02-27T10:07:45Z"},
        {"event_type": "kol_approved", "message": "✓ @agent_maxi approved", "detail": "Score: 69/100 — Tier 3", "timestamp": "2026-02-27T10:07:20Z"},
        {"event_type": "kol_rejected", "message": "✗ @anon_trader_xyz rejected", "detail": "Account age: 90 days (minimum: 180)", "timestamp": "2026-02-27T10:06:55Z"},
        {"event_type": "kol_rejected", "message": "✗ @shillmaster_9000 rejected", "detail": "89% fake engagement detected", "timestamp": "2026-02-27T10:06:30Z"},
        {"event_type": "kol_rejected", "message": "✗ @pump_king hard rejected", "detail": "Confirmed rug promotion: SafeMoon2", "timestamp": "2026-02-27T10:06:05Z"},
        {"event_type": "kol_approved", "message": "✓ @crypto_educator approved", "detail": "Score: 77/100 — Tier 2", "timestamp": "2026-02-27T10:05:40Z"},
        {"event_type": "kol_approved", "message": "✓ @ai_agent_alpha approved", "detail": "Score: 80/100 — Tier 2", "timestamp": "2026-02-27T10:05:15Z"},
        {"event_type": "kol_approved", "message": "✓ @defi_maven approved", "detail": "Score: 85/100 — Tier 2", "timestamp": "2026-02-27T10:04:50Z"},
        {"event_type": "kol_approved", "message": "✓ @based_builder approved", "detail": "Score: 92/100 — Tier 1", "timestamp": "2026-02-27T10:04:25Z"},
        {"event_type": "vetting_start", "message": "Vetting 20 candidates with AI scoring engine...", "detail": "4 categories: engagement, reputation, audience fit, content quality", "timestamp": "2026-02-27T10:04:00Z"},
        {"event_type": "discovery_done", "message": "20 candidates found via Influur", "detail": "Passing to vetting engine", "timestamp": "2026-02-27T10:03:30Z"},
        {"event_type": "discovery_start", "message": "Querying Influur database...", "detail": "Mode: web3 · Categories: Meme, DeFi, Trading", "timestamp": "2026-02-27T10:02:00Z"},
        {"event_type": "profile_done", "message": "✓ Campaign Intelligence Profile generated", "detail": "Targeting: Dogecoin, Meme Coins, DeFi", "timestamp": "2026-02-27T10:01:30Z"},
        {"event_type": "campaign_created", "message": "Campaign created — Dogecoin Community Growth", "detail": "$25,000 USDC · 14 days · Web3 mode", "timestamp": "2026-02-27T10:00:00Z"}
    ]
};

glob DEMO_WEB2_CAMPAIGN: dict = {
    "id": "demo-saas-001",
    "mode": "web2",
    "brand_name": "Notion",
    "goal": "Product Launch",
    "budget_usdc": 12000,
    "timeline_days": 14,
    "status": "proposal_ready",
    "target_audience": ["Productivity Enthusiasts", "Remote Workers", "SaaS Users"],
    "content_type": "Mixed",
    "campaign_brief": "Launch Notion's new AI-powered workspace features. Target productivity creators and tech reviewers. Emphasize real workflow improvements, not hype.",
    "min_kol_score": 65,
    "created_at": "2026-02-27T09:30:00Z",
    "intelligence_profile": {
        "ecosystem_focus": ["Productivity", "Remote Work", "SaaS"],
        "min_engagement_rate": 3.5,
        "ideal_follower_min": 40000,
        "ideal_follower_max": 600000,
        "categories": ["Tech", "Business", "Lifestyle"],
        "campaign_narrative": "Notion is launching AI-powered workspace features that transform how teams collaborate. This campaign targets productivity enthusiasts and tech reviewers who can demonstrate real workflow improvements.",
        "budget_breakdown": {"tier_1_pct": 0.4, "tier_2_pct": 0.4, "tier_3_pct": 0.2},
        "hard_disqualifiers": ["Controversial brand safety rating", "FTC compliance under 0.5", "Fake engagement patterns"]
    },
    "approved_kols": [
        {"handle": "@productivity_pro", "followers": 175000, "engagement_rate": 7.2, "score": 88, "verdict": "approved", "tier": "tier_1", "payment_amount_usdc": 4800, "payment_status": "unpaid", "payment_email": "prodpro@creator.com", "content_url": "", "payment_ref": "", "outreach_message": "", "verification_verdict": "", "verification_score": 0, "rejection_reason": "", "score_breakdown": {"engagement_authenticity": 27, "reputation_trust": 23, "audience_fit": 22, "content_quality": 16}, "key_strengths": ["Top productivity content creator", "YouTube + LinkedIn cross-platform reach"], "key_risks": ["Higher cost per impression", "May have competing SaaS partnerships"]},
        {"handle": "@lifestyle_lea", "followers": 320000, "engagement_rate": 6.8, "score": 81, "verdict": "approved", "tier": "tier_2", "payment_amount_usdc": 2400, "payment_status": "unpaid", "payment_email": "lea@lifestyle.co", "content_url": "", "payment_ref": "", "outreach_message": "", "verification_verdict": "", "verification_score": 0, "rejection_reason": "", "score_breakdown": {"engagement_authenticity": 24, "reputation_trust": 22, "audience_fit": 20, "content_quality": 15}, "key_strengths": ["Large lifestyle audience interested in productivity", "High visual content quality"], "key_risks": ["Audience may be broader than target", "Instagram-heavy may not drive conversions"]},
        {"handle": "@startup_lea", "followers": 140000, "engagement_rate": 5.4, "score": 77, "verdict": "approved", "tier": "tier_2", "payment_amount_usdc": 2400, "payment_status": "unpaid", "payment_email": "lea@startupinsights.co", "content_url": "", "payment_ref": "", "outreach_message": "", "verification_verdict": "", "verification_score": 0, "rejection_reason": "", "score_breakdown": {"engagement_authenticity": 21, "reputation_trust": 22, "audience_fit": 19, "content_quality": 15}, "key_strengths": ["Direct access to startup founder audience", "LinkedIn thought leadership"], "key_risks": ["Smaller reach", "LinkedIn content may have lower viral potential"]},
        {"handle": "@saas_breakdown", "followers": 92000, "engagement_rate": 8.1, "score": 69, "verdict": "approved", "tier": "tier_3", "payment_amount_usdc": 1200, "payment_status": "unpaid", "payment_email": "reviews@saasbreakdown.io", "content_url": "", "payment_ref": "", "outreach_message": "", "verification_verdict": "", "verification_score": 0, "rejection_reason": "", "score_breakdown": {"engagement_authenticity": 25, "reputation_trust": 18, "audience_fit": 14, "content_quality": 12}, "key_strengths": ["Highest engagement rate in pool", "SaaS-specific review audience"], "key_risks": ["Smaller total reach", "Review style may be too critical"]},
        {"handle": "@remote_work_hub", "followers": 55000, "engagement_rate": 6.0, "score": 66, "verdict": "approved", "tier": "tier_3", "payment_amount_usdc": 1200, "payment_status": "unpaid", "payment_email": "hello@remoteworkhub.com", "content_url": "", "payment_ref": "", "outreach_message": "", "verification_verdict": "", "verification_score": 0, "rejection_reason": "", "score_breakdown": {"engagement_authenticity": 20, "reputation_trust": 18, "audience_fit": 16, "content_quality": 12}, "key_strengths": ["Targeted remote work audience", "Practical tool recommendation style"], "key_risks": ["Smallest reach in roster", "Newer account"]}
    ],
    "rejected_kols": [
        {"handle": "@controversy_king", "score": 22, "verdict": "hard_rejected", "rejection_reason": "Brand safety: controversial. Multiple instances of inflammatory content incompatible with brand partnership.", "tier": ""},
        {"handle": "@bot_network", "score": 18, "verdict": "hard_rejected", "rejection_reason": "94% fake engagement detected. Follower-to-engagement ratio (0.3%) indicates purchased followers.", "tier": ""}
    ],
    "proposal": {
        "campaign_summary": "Notion AI Workspace Launch campaign targeting productivity enthusiasts and remote workers with 5 vetted creators across 3 tiers. The roster combines YouTube depth with LinkedIn authority and Instagram visual reach.",
        "kol_roster": [
            {"handle": "@productivity_pro", "tier": "tier_1", "role": "YouTube deep-dive: Notion AI features workflow demo", "budget_usdc": 4800, "expected_reach": 620000},
            {"handle": "@lifestyle_lea", "tier": "tier_2", "role": "Instagram: day-in-the-life using Notion AI", "budget_usdc": 2400, "expected_reach": 580000},
            {"handle": "@startup_lea", "tier": "tier_2", "role": "LinkedIn: how Notion AI changes team workflows", "budget_usdc": 2400, "expected_reach": 350000},
            {"handle": "@saas_breakdown", "tier": "tier_3", "role": "YouTube review: honest Notion AI vs competitors", "budget_usdc": 1200, "expected_reach": 280000},
            {"handle": "@remote_work_hub", "tier": "tier_3", "role": "Twitter thread: remote team Notion AI setup guide", "budget_usdc": 1200, "expected_reach": 170000}
        ],
        "timeline": [
            {"day": 1, "action": "Campaign kickoff — lock $12,000 budget"},
            {"day": 2, "action": "Distribute briefs to all 5 creators"},
            {"day": 3, "action": "Tier 1: @productivity_pro publishes YouTube video"},
            {"day": 5, "action": "Tier 2: @lifestyle_lea and @startup_lea publish"},
            {"day": 7, "action": "Mid-campaign engagement check"},
            {"day": 8, "action": "Tier 3: @saas_breakdown and @remote_work_hub publish"},
            {"day": 10, "action": "Content verification window opens"},
            {"day": 12, "action": "Final payments released"},
            {"day": 14, "action": "Campaign complete — performance report"}
        ],
        "total_expected_reach": 2000000,
        "agent_recommendation": "Solid roster for a SaaS product launch. @productivity_pro as the Tier 1 anchor provides credible, in-depth YouTube coverage that will serve as evergreen content. The mix of LinkedIn and Instagram in Tier 2 covers both B2B decision-makers and individual users. Recommend proceeding with approval.",
        "total_approved": 5,
        "total_rejected": 2
    },
    "activity_log": [
        {"event_type": "proposal_done", "message": "✓ Proposal generated — ready for brand approval", "detail": "Expected reach: 2.0M · 5 KOLs · $12,000 budget", "timestamp": "2026-02-27T09:38:00Z"},
        {"event_type": "kol_approved", "message": "✓ @remote_work_hub approved", "detail": "Score: 66/100 — Tier 3", "timestamp": "2026-02-27T09:37:00Z"},
        {"event_type": "kol_approved", "message": "✓ @saas_breakdown approved", "detail": "Score: 69/100 — Tier 3", "timestamp": "2026-02-27T09:36:30Z"},
        {"event_type": "kol_rejected", "message": "✗ @bot_network hard rejected", "detail": "94% fake engagement detected", "timestamp": "2026-02-27T09:36:00Z"},
        {"event_type": "kol_rejected", "message": "✗ @controversy_king hard rejected", "detail": "Brand safety: controversial content", "timestamp": "2026-02-27T09:35:30Z"},
        {"event_type": "kol_approved", "message": "✓ @startup_lea approved", "detail": "Score: 77/100 — Tier 2", "timestamp": "2026-02-27T09:35:00Z"},
        {"event_type": "kol_approved", "message": "✓ @lifestyle_lea approved", "detail": "Score: 81/100 — Tier 2", "timestamp": "2026-02-27T09:34:30Z"},
        {"event_type": "kol_approved", "message": "✓ @productivity_pro approved", "detail": "Score: 88/100 — Tier 1", "timestamp": "2026-02-27T09:34:00Z"},
        {"event_type": "discovery_done", "message": "15 candidates found via Influur", "detail": "Passing to vetting engine", "timestamp": "2026-02-27T09:33:00Z"},
        {"event_type": "profile_done", "message": "✓ Campaign Intelligence Profile generated", "detail": "Targeting: Productivity, Remote Work, SaaS", "timestamp": "2026-02-27T09:31:30Z"},
        {"event_type": "campaign_created", "message": "Campaign created — Notion Product Launch", "detail": "$12,000 · 14 days · Web2 mode", "timestamp": "2026-02-27T09:30:00Z"}
    ]
};

"""Return both demo campaigns as a dict keyed by campaign id."""
def:pub get_demo_campaigns() -> dict {
    return {
        "demo-doge-001": DEMO_WEB3_CAMPAIGN,
        "demo-saas-001": DEMO_WEB2_CAMPAIGN
    };
}
