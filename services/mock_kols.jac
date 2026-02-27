"""Mock KOL dataset for CampaignMind MVP demo.

WEB3_KOLS: 20 crypto KOL profiles distributed across quality tiers:
  5 excellent (85-100), 5 good (70-84), 4 borderline (60-70),
  4 bad (<65), 2 hard-disqualified (rug_promotions >= 1).

WEB2_KOLS: 15 traditional influencer profiles across quality tiers:
  5 excellent (85-100), 5 good (70-84), 3 borderline (60-70),
  2 bad / hard-disqualified.
"""

glob WEB3_KOLS: list = [
    # ─── EXCELLENT (will score 85-100) ─────────────────────
    {
        "handle": "@based_builder",
        "followers": 187000,
        "engagement_rate": 8.4,
        "account_age_days": 1420,
        "categories": ["Base", "DeFi", "AI"],
        "rug_promotions": 0,
        "disclosure_rate": 0.95,
        "estimated_price_usd": 4500,
        "wallet_address": "0x4f2a8B3c91D7eF06A42b1C9dE5f8A3e71c2B09aD",
        "comment_quality": "high",
        "recent_posts": [
            "Thread: Why Base L2 throughput is underpriced right now",
            "Deep dive into the new Aerodrome veTokenomics update",
            "Built a real-time agent that monitors Base mempool — open source"
        ]
    },
    {
        "handle": "@defi_maven",
        "followers": 224000,
        "engagement_rate": 7.9,
        "account_age_days": 1680,
        "categories": ["DeFi", "Trading", "Base"],
        "rug_promotions": 0,
        "disclosure_rate": 0.92,
        "estimated_price_usd": 6000,
        "wallet_address": "0x7aE1c3D9f5B24680eA31d8C7bF09e4A62dF8c11B",
        "comment_quality": "high",
        "recent_posts": [
            "Comparing yields across Base DEXs — full spreadsheet included",
            "How I built a $400k DeFi portfolio using only Base protocols",
            "Disclosure: this is a paid post for Moonwell. Here's my honest take."
        ]
    },
    {
        "handle": "@ai_agent_alpha",
        "followers": 156000,
        "engagement_rate": 9.1,
        "account_age_days": 890,
        "categories": ["AI", "Base", "DeFi"],
        "rug_promotions": 0,
        "disclosure_rate": 0.98,
        "estimated_price_usd": 5000,
        "wallet_address": "0xB3d7F2a9c8E14D6b5A0f3C7e9d1B8A4F6c2E50aA",
        "comment_quality": "high",
        "recent_posts": [
            "I tested 12 AI agent frameworks on Base — here's what actually works",
            "Tutorial: Deploy your first autonomous agent on Base in 30 min",
            "The convergence of DeFi × AI agents is the alpha no one's talking about"
        ]
    },
    {
        "handle": "@onchain_sage",
        "followers": 298000,
        "engagement_rate": 6.8,
        "account_age_days": 2100,
        "categories": ["Base", "Education", "DeFi"],
        "rug_promotions": 0,
        "disclosure_rate": 0.90,
        "estimated_price_usd": 7500,
        "wallet_address": "0x1cF8e4A2b6D93E7f0C5d8B1a4F9e6C3d7A2B80eE",
        "comment_quality": "high",
        "recent_posts": [
            "Beginner guide: How to bridge to Base and start earning yield",
            "Analyzed 50 Base protocols — these 5 have real product-market fit",
            "On-chain data shows Base TVL growing 40% MoM. Here's why."
        ]
    },
    {
        "handle": "@base_native",
        "followers": 142000,
        "engagement_rate": 8.8,
        "account_age_days": 1050,
        "categories": ["Base", "AI", "Trading"],
        "rug_promotions": 0,
        "disclosure_rate": 0.93,
        "estimated_price_usd": 4000,
        "wallet_address": "0xD9a2E7c1B3f4680dC5e8A9b1D6F3c7E2a4B9f01C",
        "comment_quality": "high",
        "recent_posts": [
            "Base ecosystem map updated — 180+ protocols now live",
            "Why I'm mass migrating my bots from Ethereum L1 to Base",
            "AI agent staking is the next narrative. Here's the thesis."
        ]
    },

    # ─── GOOD (will score 70-84) ──────────────────────────
    {
        "handle": "@yield_hunter_ct",
        "followers": 98000,
        "engagement_rate": 5.6,
        "account_age_days": 920,
        "categories": ["DeFi", "Trading"],
        "rug_promotions": 0,
        "disclosure_rate": 0.80,
        "estimated_price_usd": 2800,
        "wallet_address": "0x5eB1d8C3a7F9420bE6c1D9A4f3B7E8c2d6A1F09B",
        "comment_quality": "medium",
        "recent_posts": [
            "Found a 22% APY farm on Base — legit protocol, audited",
            "My weekly DeFi portfolio update: +3.2% this week",
            "Stop sleeping on Seamless Protocol lending rates"
        ]
    },
    {
        "handle": "@crypto_educator",
        "followers": 175000,
        "engagement_rate": 4.9,
        "account_age_days": 1800,
        "categories": ["Education", "DeFi", "Base"],
        "rug_promotions": 0,
        "disclosure_rate": 0.85,
        "estimated_price_usd": 3500,
        "wallet_address": "0xA8c3E1d7B2f6490eC5b8D1a3F9e7C4b6d2A8F01E",
        "comment_quality": "medium",
        "recent_posts": [
            "ELI5: What is Base and why should you care?",
            "Video: Setting up your first Base wallet step by step",
            "Common DeFi mistakes that cost beginners thousands"
        ]
    },
    {
        "handle": "@alpha_signals_base",
        "followers": 67000,
        "engagement_rate": 6.2,
        "account_age_days": 680,
        "categories": ["Trading", "Base", "AI"],
        "rug_promotions": 0,
        "disclosure_rate": 0.78,
        "estimated_price_usd": 2000,
        "wallet_address": "0x3dF7a9C1e8B2460bD5c1A8E4f6B9D3c7a1E2F08A",
        "comment_quality": "medium",
        "recent_posts": [
            "3 Base tokens with strong accumulation patterns right now",
            "My AI bot detected unusual volume on AERO — watching closely",
            "Weekly alpha recap: what moved on Base this week"
        ]
    },
    {
        "handle": "@defi_degen_dao",
        "followers": 112000,
        "engagement_rate": 5.1,
        "account_age_days": 760,
        "categories": ["DeFi", "Base"],
        "rug_promotions": 0,
        "disclosure_rate": 0.75,
        "estimated_price_usd": 2500,
        "wallet_address": "0x6bE4d1A8c3F7920eB5a1C9D3f8E6B4c2a7D1F05C",
        "comment_quality": "medium",
        "recent_posts": [
            "Aping into this new Base DEX — UI is clean, liquidity growing",
            "DeFi governance update: voted on 3 proposals this week",
            "Base DeFi summer is coming and most people aren't ready"
        ]
    },
    {
        "handle": "@agent_maxi",
        "followers": 89000,
        "engagement_rate": 6.5,
        "account_age_days": 540,
        "categories": ["AI", "Base"],
        "rug_promotions": 0,
        "disclosure_rate": 0.82,
        "estimated_price_usd": 2200,
        "wallet_address": "0x9cA1e3D7b2F8460dE5a8C1B4f6D9E3c7a2B1F04D",
        "comment_quality": "medium",
        "recent_posts": [
            "Reviewed 5 AI agent tokens — only 2 have working products",
            "The agent economy on Base is still early but accelerating",
            "How autonomous agents will change how we interact with DeFi"
        ]
    },

    # ─── BORDERLINE (will score 60-70) ────────────────────
    {
        "handle": "@ct_whisperer",
        "followers": 45000,
        "engagement_rate": 3.8,
        "account_age_days": 420,
        "categories": ["Trading", "DeFi"],
        "rug_promotions": 0,
        "disclosure_rate": 0.55,
        "estimated_price_usd": 1200,
        "wallet_address": "0x2aD8c1E3b7F4960eA5b1C9D4f8E3B6c2a1D7F08E",
        "comment_quality": "medium",
        "recent_posts": [
            "This token is about to breakout — chart looks bullish",
            "My calls have been 60% accurate this month, improving",
            "Quick take on today's Base market moves"
        ]
    },
    {
        "handle": "@nft_meets_defi",
        "followers": 38000,
        "engagement_rate": 4.2,
        "account_age_days": 350,
        "categories": ["Base", "DeFi"],
        "rug_promotions": 0,
        "disclosure_rate": 0.60,
        "estimated_price_usd": 1000,
        "wallet_address": "0x8bE1d4A9c3F7260eD5a1C8B4f6E9D3c7a2B1F06A",
        "comment_quality": "low",
        "recent_posts": [
            "NFTs on Base are heating up — minted 3 collections this week",
            "DeFi + NFT composability is underrated on Base",
            "GM. What are we buying today?"
        ]
    },
    {
        "handle": "@micro_cap_gems",
        "followers": 52000,
        "engagement_rate": 3.4,
        "account_age_days": 290,
        "categories": ["Trading", "Base"],
        "rug_promotions": 0,
        "disclosure_rate": 0.50,
        "estimated_price_usd": 800,
        "wallet_address": "0x4cF1e8A3b7D2960eC5a1B9D4f3E6C8c2a7D1F03B",
        "comment_quality": "low",
        "recent_posts": [
            "Found a sub-$1M mcap gem on Base — DYOR but looks interesting",
            "3 micro caps I'm watching this week",
            "Low cap szn incoming on Base"
        ]
    },
    {
        "handle": "@base_intern",
        "followers": 28000,
        "engagement_rate": 4.5,
        "account_age_days": 210,
        "categories": ["Base", "Education"],
        "rug_promotions": 0,
        "disclosure_rate": 0.65,
        "estimated_price_usd": 600,
        "wallet_address": "0x7dA2e1C3b8F4960eB5c1D8A4f9E3B6c2a1D7F02C",
        "comment_quality": "low",
        "recent_posts": [
            "Just started learning about Base — sharing my journey",
            "Day 30 of building on Base: here's what I've learned",
            "Simple thread on how gas works on L2s"
        ]
    },

    # ─── BAD (will score under 65) ────────────────────────
    {
        "handle": "@pump_king",
        "followers": 320000,
        "engagement_rate": 1.2,
        "account_age_days": 180,
        "categories": ["Trading"],
        "rug_promotions": 0,
        "disclosure_rate": 0.10,
        "estimated_price_usd": 3000,
        "wallet_address": "0x1aB2c3D4e5F6a7B8c9D0e1F2a3B4c5D6e7F8a9B0",
        "comment_quality": "low",
        "recent_posts": [
            "THIS WILL 100X 🚀🚀🚀 BUY NOW OR CRY LATER",
            "LAST CHANCE to get in before moonshot 📈",
            "I called the last 5 pumps. Trust me on this one."
        ]
    },
    {
        "handle": "@shillmaster_9000",
        "followers": 195000,
        "engagement_rate": 1.8,
        "account_age_days": 240,
        "categories": ["Trading", "DeFi"],
        "rug_promotions": 0,
        "disclosure_rate": 0.05,
        "estimated_price_usd": 2500,
        "wallet_address": "0xF9e8D7c6B5a4F3e2D1c0B9a8F7e6D5c4B3a2F1e0",
        "comment_quality": "low",
        "recent_posts": [
            "PAID PROMO but this token is actually good trust me bro",
            "Join my premium group for 50x calls — only $500/month",
            "Another banger call ✅ (deleted the 10 that didn't hit)"
        ]
    },
    {
        "handle": "@anon_trader_xyz",
        "followers": 15000,
        "engagement_rate": 2.1,
        "account_age_days": 90,
        "categories": ["Trading"],
        "rug_promotions": 0,
        "disclosure_rate": 0.20,
        "estimated_price_usd": 400,
        "wallet_address": "0xA1b2C3d4E5f6A7b8C9d0E1f2A3b4C5d6E7f8A9b0",
        "comment_quality": "low",
        "recent_posts": [
            "New account who dis. Anyway buy this token.",
            "I'm anon for a reason. My alpha speaks for itself.",
            "DM me for calls. Free for now."
        ]
    },
    {
        "handle": "@copypasta_ct",
        "followers": 72000,
        "engagement_rate": 1.5,
        "account_age_days": 300,
        "categories": ["Base", "Trading"],
        "rug_promotions": 0,
        "disclosure_rate": 0.15,
        "estimated_price_usd": 1500,
        "wallet_address": "0xD4e5F6a7B8c9D0e1F2a3B4c5D6e7F8a9B0c1D2e3",
        "comment_quality": "low",
        "recent_posts": [
            "Reposting this alpha from someone else (no credit)",
            "Same thread as yesterday but slightly reworded",
            "Engagement farming: like if you're bullish, RT if bearish"
        ]
    },

    # ─── HARD DISQUALIFIED (rug_promotions >= 1) ──────────
    {
        "handle": "@rug_radio_host",
        "followers": 410000,
        "engagement_rate": 3.2,
        "account_age_days": 1100,
        "categories": ["Trading", "DeFi", "Base"],
        "rug_promotions": 3,
        "disclosure_rate": 0.30,
        "estimated_price_usd": 8000,
        "wallet_address": "0xE5f6A7b8C9d0E1f2A3b4C5d6E7f8A9b0C1d2E3f4",
        "comment_quality": "medium",
        "recent_posts": [
            "This new DeFi protocol is revolutionary (paid, not disclosed)",
            "Promoted SafeMoonX before it rugged — my bad, moving on",
            "New partnership announcement — this one is different I promise"
        ]
    },
    {
        "handle": "@whale_catcher",
        "followers": 265000,
        "engagement_rate": 2.8,
        "account_age_days": 850,
        "categories": ["Trading", "Base"],
        "rug_promotions": 2,
        "disclosure_rate": 0.25,
        "estimated_price_usd": 5500,
        "wallet_address": "0xC9d0E1f2A3b4C5d6E7f8A9b0C1d2E3f4A5b6C7d8",
        "comment_quality": "medium",
        "recent_posts": [
            "Whale wallets are accumulating this Base token (promoted the last rug too)",
            "On-chain analysis shows smart money flowing in (same thing I said about PonziSwap)",
            "My track record speaks for itself (don't check the archives)"
        ]
    }
];

glob WEB2_KOLS: list = [
    # ——— EXCELLENT (will score 85-100) ———
    {
        "handle": "@productivity_pro",
        "followers": 175000,
        "engagement_rate": 7.2,
        "account_age_days": 1400,
        "categories": ["Tech", "Business"],
        "brand_safety": "clean",
        "ftc_compliance": 0.95,
        "platforms": ["YouTube", "LinkedIn"],
        "content_style": "educational",
        "estimated_price_usd": 4800,
        "payment_email": "prodpro@creator.com",
        "comment_quality": "high",
        "recent_posts": [
            "Deep dive: How I automated my entire workflow with 5 tools",
            "Honest review of the new Notion AI features — what works and what doesn't",
            "Tutorial: Build a second brain system that actually sticks"
        ]
    },
    {
        "handle": "@lifestyle_lea",
        "followers": 320000,
        "engagement_rate": 6.8,
        "account_age_days": 1200,
        "categories": ["Lifestyle", "Tech"],
        "brand_safety": "clean",
        "ftc_compliance": 0.92,
        "platforms": ["Instagram", "Twitter"],
        "content_style": "lifestyle",
        "estimated_price_usd": 5500,
        "payment_email": "lea@lifestyle.co",
        "comment_quality": "high",
        "recent_posts": [
            "My morning routine as a remote founder — tools I actually use",
            "Switching to a minimalist desk setup changed my productivity",
            "#ad Tried this new planner app for 30 days — full transparency review"
        ]
    },
    {
        "handle": "@saas_breakdown",
        "followers": 92000,
        "engagement_rate": 8.1,
        "account_age_days": 980,
        "categories": ["Tech", "Business"],
        "brand_safety": "clean",
        "ftc_compliance": 0.90,
        "platforms": ["YouTube", "Twitter"],
        "content_style": "review",
        "estimated_price_usd": 3200,
        "payment_email": "reviews@saasbreakdown.io",
        "comment_quality": "high",
        "recent_posts": [
            "I tested every project management tool so you don't have to",
            "SaaS pricing breakdown: why most tools overcharge for AI features",
            "Video: 7 underrated tools for startup teams under 10 people"
        ]
    },
    {
        "handle": "@fit_science",
        "followers": 280000,
        "engagement_rate": 6.5,
        "account_age_days": 1600,
        "categories": ["Fitness", "Lifestyle"],
        "brand_safety": "clean",
        "ftc_compliance": 0.86,
        "platforms": ["Instagram", "TikTok"],
        "content_style": "educational",
        "estimated_price_usd": 4200,
        "payment_email": "collab@fitscience.me",
        "comment_quality": "high",
        "recent_posts": [
            "The science behind why morning workouts boost focus — real studies",
            "Tested 5 recovery tools with HRV tracking — here's what worked",
            "Reel: 3 exercises every desk worker needs (backed by research)"
        ]
    },
    {
        "handle": "@nomad_eats",
        "followers": 410000,
        "engagement_rate": 5.9,
        "account_age_days": 1350,
        "categories": ["Food", "Lifestyle"],
        "brand_safety": "clean",
        "ftc_compliance": 0.91,
        "platforms": ["Instagram", "YouTube"],
        "content_style": "entertainment",
        "estimated_price_usd": 6000,
        "payment_email": "hello@nomadeats.co",
        "comment_quality": "high",
        "recent_posts": [
            "Street food tour: Miami's hidden gems that locals don't share",
            "Cooking challenge: recreating a $200 meal for under $20",
            "#sponsored Tried this meal kit service for a month in 3 countries"
        ]
    },

    # ——— GOOD (will score 70-84) ———
    {
        "handle": "@startup_lea",
        "followers": 140000,
        "engagement_rate": 5.4,
        "account_age_days": 900,
        "categories": ["Business", "Tech"],
        "brand_safety": "clean",
        "ftc_compliance": 0.94,
        "platforms": ["LinkedIn", "Twitter"],
        "content_style": "educational",
        "estimated_price_usd": 3500,
        "payment_email": "lea@startupinsights.co",
        "comment_quality": "medium",
        "recent_posts": [
            "Lessons from scaling my startup from 0 to 50K users in 6 months",
            "The tools I recommend to every early-stage founder",
            "LinkedIn post: Why most SaaS onboarding flows are broken"
        ]
    },
    {
        "handle": "@indie_gamer_hub",
        "followers": 210000,
        "engagement_rate": 5.8,
        "account_age_days": 800,
        "categories": ["Gaming", "Tech"],
        "brand_safety": "clean",
        "ftc_compliance": 0.78,
        "platforms": ["YouTube", "Twitch"],
        "content_style": "entertainment",
        "estimated_price_usd": 3800,
        "payment_email": "biz@indiegamerhub.gg",
        "comment_quality": "medium",
        "recent_posts": [
            "Reviewing 10 indie games you've never heard of — all bangers",
            "My streaming setup tour and what I'd change after 2 years",
            "Live: playing community picks for 8 hours straight"
        ]
    },
    {
        "handle": "@remote_work_hub",
        "followers": 55000,
        "engagement_rate": 6.0,
        "account_age_days": 650,
        "categories": ["Business", "Lifestyle"],
        "brand_safety": "clean",
        "ftc_compliance": 0.88,
        "platforms": ["Twitter", "LinkedIn"],
        "content_style": "educational",
        "estimated_price_usd": 1800,
        "payment_email": "hello@remoteworkhub.com",
        "comment_quality": "medium",
        "recent_posts": [
            "My favorite async communication tools for distributed teams",
            "Thread: how to run effective meetings with a global team",
            "The remote work tech stack I recommend to every new manager"
        ]
    },
    {
        "handle": "@glam_by_nina",
        "followers": 520000,
        "engagement_rate": 4.8,
        "account_age_days": 1100,
        "categories": ["Beauty", "Lifestyle"],
        "brand_safety": "clean",
        "ftc_compliance": 0.89,
        "platforms": ["TikTok", "Instagram"],
        "content_style": "entertainment",
        "estimated_price_usd": 7000,
        "payment_email": "mgmt@glambynina.com",
        "comment_quality": "medium",
        "recent_posts": [
            "Get ready with me: using only drugstore products under $15",
            "Honest brand review: I tried their full line for 2 weeks",
            "Tutorial: 5-minute office look that actually works"
        ]
    },
    {
        "handle": "@home_workout_daily",
        "followers": 120000,
        "engagement_rate": 5.5,
        "account_age_days": 700,
        "categories": ["Fitness", "Lifestyle"],
        "brand_safety": "clean",
        "ftc_compliance": 0.80,
        "platforms": ["Instagram", "TikTok"],
        "content_style": "educational",
        "estimated_price_usd": 2200,
        "payment_email": "partner@homeworkoutdaily.fit",
        "comment_quality": "medium",
        "recent_posts": [
            "No-equipment full body workout you can do in 20 minutes",
            "I tracked my progress for 90 days with just bodyweight — results",
            "Reel: The one stretch most people skip (and shouldn't)"
        ]
    },

    # ——— BORDERLINE (will score 60-70) ———
    {
        "handle": "@minimal_living",
        "followers": 180000,
        "engagement_rate": 3.6,
        "account_age_days": 450,
        "categories": ["Lifestyle"],
        "brand_safety": "clean",
        "ftc_compliance": 0.85,
        "platforms": ["Instagram"],
        "content_style": "lifestyle",
        "estimated_price_usd": 2800,
        "payment_email": "collab@minimalliving.me",
        "comment_quality": "medium",
        "recent_posts": [
            "Decluttered my entire apartment — here's what I kept",
            "The 10-item wardrobe experiment: month 3 update",
            "Aesthetic morning routine — slow living in Miami"
        ]
    },
    {
        "handle": "@retro_plays",
        "followers": 68000,
        "engagement_rate": 4.0,
        "account_age_days": 380,
        "categories": ["Gaming"],
        "brand_safety": "minor_issues",
        "ftc_compliance": 0.65,
        "platforms": ["YouTube", "Twitch"],
        "content_style": "entertainment",
        "estimated_price_usd": 1200,
        "payment_email": "retro@plays.gg",
        "comment_quality": "low",
        "recent_posts": [
            "Playing every N64 game ever made — day 47",
            "This game was WAY ahead of its time and nobody talks about it",
            "Stream highlight: rage quit compilation (viewers loved it)"
        ]
    },
    {
        "handle": "@kitchen_experiments",
        "followers": 75000,
        "engagement_rate": 3.8,
        "account_age_days": 320,
        "categories": ["Food", "Lifestyle"],
        "brand_safety": "minor_issues",
        "ftc_compliance": 0.70,
        "platforms": ["Instagram", "TikTok"],
        "content_style": "entertainment",
        "estimated_price_usd": 1000,
        "payment_email": "chef@kitchenexp.com",
        "comment_quality": "low",
        "recent_posts": [
            "Can I make a 5-star meal with only gas station ingredients?",
            "Taste-testing every hot sauce at the store — ranked",
            "I let my followers pick my meals for a week (regrets)"
        ]
    },

    # ——— BAD / HARD DISQUALIFIED ———
    {
        "handle": "@controversy_king",
        "followers": 290000,
        "engagement_rate": 2.1,
        "account_age_days": 600,
        "categories": ["Lifestyle", "Business"],
        "brand_safety": "controversial",
        "ftc_compliance": 0.10,
        "platforms": ["Twitter", "YouTube"],
        "content_style": "entertainment",
        "estimated_price_usd": 4000,
        "payment_email": "king@controversy.lol",
        "comment_quality": "low",
        "recent_posts": [
            "Hot take that got me cancelled (I stand by it)",
            "Brand deal gone wrong — exposing the company that scammed me",
            "Reacting to my haters — they're not wrong but they're not right"
        ]
    },
    {
        "handle": "@bot_network",
        "followers": 450000,
        "engagement_rate": 0.3,
        "account_age_days": 200,
        "categories": ["Lifestyle", "Tech"],
        "brand_safety": "clean",
        "ftc_compliance": 0.05,
        "platforms": ["Instagram"],
        "content_style": "lifestyle",
        "estimated_price_usd": 3000,
        "payment_email": "contact@totallyreal.com",
        "comment_quality": "low",
        "recent_posts": [
            "Amazing day! #blessed #lifestyle #inspo #follow4follow",
            "So grateful for all my followers! (identical comment pattern x500)",
            "New post! Link in bio! #ad #sponsored #collab"
        ]
    }
];

"""Return KOL candidates from web3 or web2 pool, optionally filtered by categories."""
def:pub get_candidates(filters: dict = {}, mode: str = "web3") -> list {
    pool: list = [];
    if (mode == "web2") {
        pool = WEB2_KOLS;
    } else {
        pool = WEB3_KOLS;
    }
    if (not filters) {
        return pool;
    }
    filter_cats = filters.get("categories", []);
    if (not filter_cats) {
        return pool;
    }
    result: list = [];
    for kol in pool {
        for cat in kol["categories"] {
            if (cat in filter_cats) {
                result.append(kol);
                break;
            }
        }
    }
    return result;
}
