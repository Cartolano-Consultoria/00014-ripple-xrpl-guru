# Architecture

## Executive Summary

XRPL Guru architecture is built on the **Full Stack FastAPI Template** foundation, extended with multi-channel chat capabilities, AI/ML orchestration (Azure OpenAI + Ripple RAG), and XRPL blockchain integration. The system uses a cloud-native Azure architecture with FastAPI backend, PostgreSQL database, Redis caching, and React web dashboard.

## Project Initialization

**First implementation story must execute:**

```bash
# Install copier (if not already installed)
pip install copier

# Generate project from Full Stack FastAPI Template
copier copy https://github.com/fastapi/full-stack-fastapi-template xrpl-guru --trust
```

**Configuration prompts:**
- `project_name`: "XRPL Guru"
- `stack_name`: "xrpl-guru"
- `secret_key`: (generate secure key)
- `first_superuser_email`: (admin email)
- `postgres_password`: (secure password)
- `smtp_server`: (email service for notifications)

**Post-initialization additions:**
1. Add Redis service to `docker-compose.yml`
2. Add chat bot adapter modules (Slack, Discord, WhatsApp)
3. Add Azure deployment configuration (Bicep templates)
4. Add XRPL integration module (xrpl-py)
5. Add background job system (Celery + Redis)
6. Add AI/ML services (Azure OpenAI, RAG integration)

### Architectural Decisions Provided by Starter Template

The Full Stack FastAPI Template establishes these foundational decisions:

| Decision | Provided by Starter | Version |
|----------|-------------------|---------|
| **Backend Framework** | FastAPI | 0.121.0 |
| **Python Version** | Python 3.12+ | 3.12 |
| **Database** | PostgreSQL | 17+ |
| **ORM** | SQLModel (async) | Latest |
| **Database Migrations** | Alembic | Latest |
| **Authentication** | JWT (with OAuth2) | Included |
| **Frontend Framework** | React + TypeScript | Latest |
| **Build Tool** | Vite | Latest |
| **UI Library** | Chakra UI | Latest |
| **State Management** | TanStack Query (React Query) | Latest |
| **Routing** | TanStack Router | Latest |
| **API Client** | Generated TypeScript SDK | Auto-generated |
| **Linting (Python)** | Ruff | Latest |
| **Type Checking** | mypy | Latest |
| **Linting (Frontend)** | ESLint + Prettier | Latest |
| **Testing (Backend)** | Pytest | Latest |
| **Testing (Frontend)** | Playwright (E2E) | Latest |
| **Containerization** | Docker + Docker Compose | Latest |
| **CI/CD** | GitHub Actions | Pre-configured |
| **Pre-commit Hooks** | Pre-commit (Ruff, Prettier) | Configured |

### Additional Technologies (To Be Added)

| Technology | Purpose | Version | Status |
|-----------|---------|---------|--------|
| **Redis** | Session cache, message broker | 7.2+ | To Add |
| **Celery** | Background job processing | 5.3+ | To Add |
| **Azure OpenAI** | LLM for conversations | GPT-4 Turbo | To Add |
| **xrpl-py** | XRPL blockchain integration | 2.6+ | To Add |
| **Slack SDK** | Slack bot integration | Latest | To Add |
| **Discord.py** | Discord bot integration | 2.3+ | To Add |
| **WhatsApp Business API** | WhatsApp bot integration | Latest | To Add |
| **Azure Services** | OpenAI, Blob, Key Vault, etc. | N/A | To Add |

## Decision Summary

| Category | Decision | Version | Affects Epics | Rationale |
|----------|----------|---------|---------------|-----------|
| **Multi-Channel Architecture** | Adapter Pattern with Unified Bot Service | N/A | All chat features | Clean separation, easy to add channels, Redis pub/sub for events |
| **AI/ML Integration** | AI Gateway Service (centralized) | N/A | Code Partner, Adaptive Path | Single point for AI logic, caching, retry, fallback to RAG first |
| **Background Jobs** | Specialized Celery Workers | Celery 5.3+ | Proactive Guidance, Monitoring | Isolation by workload type, prevents blocking |
| **Proactive Matching** | Hybrid: PostgreSQL + Redis Cache | N/A | Proactive Guidance | Incremental matching (delta only), Redis for fast reads |
| **XRPL Integration** | Service Layer with Circuit Breaker | xrpl-py 2.6+ | Code Partner, Learning | Failover between nodes, caching, production-grade reliability |
| **Azure Deployment** | Azure Container Apps | N/A | All services | Serverless containers, scale-to-zero, KEDA auto-scaling |
| **Database Schema** | Hybrid SQL + JSONB + pgvector | PostgreSQL 17 | All data storage | Flexibility (JSONB) + ML vectors + relational integrity |
| **API Response Format** | Direct Response (REST standard) | N/A | All API endpoints | FastAPI default, simple, REST-compliant |
| **Error Handling** | Exception Hierarchy | N/A | All services | Pythonic, FastAPI exception handlers automatic |
| **Logging** | Structured JSON (structlog) | structlog 24+ | All services | Azure App Insights integration, queryable |
| **Datetime Handling** | UTC everywhere | N/A | All services | Avoid timezone bugs, frontend converts |
| **Email Notifications** | Transactional Service (SendGrid) | N/A | Onboarding, Notifications | Deliverability, analytics, versioned templates |
| **Redis Usage** | Cache + Message Broker + Sessions | Redis 7.2+ | All services | Multi-purpose: RAG cache, Celery broker, conversation context |
| **Message Partitioning** | Monthly partitions | PostgreSQL | Messages table | Performance, easy purge of old data |
| **Vector Similarity** | pgvector extension | pgvector 0.5+ | Matching engine | Cosine similarity for skill/opportunity matching |

## Project Structure

```
xrpl-guru/
├── backend/
│   ├── app/
│   │   ├── main.py                      # FastAPI application entry
│   │   ├── api/
│   │   │   ├── main.py                  # API router aggregator
│   │   │   ├── routes/
│   │   │   │   ├── auth.py              # Email auth, verification codes
│   │   │   │   ├── developers.py        # Developer profile endpoints
│   │   │   │   ├── conversations.py     # Conversation history
│   │   │   │   ├── opportunities.py     # Opportunity pipeline
│   │   │   │   └── webhooks.py          # Chat platform webhooks (Slack, Discord, WhatsApp)
│   │   │   └── deps.py                  # Dependency injection (DB, Redis, current user)
│   │   ├── core/
│   │   │   ├── config.py                # Settings (Pydantic BaseSettings)
│   │   │   ├── security.py              # JWT, password hashing, email codes
│   │   │   ├── db.py                    # SQLModel async engine
│   │   │   └── redis.py                 # Redis connection pool
│   │   ├── models/
│   │   │   ├── user.py                  # User, DeveloperProfile (SQLModel)
│   │   │   ├── channel.py               # Channel model
│   │   │   ├── conversation.py          # Conversation, Message (with partitioning)
│   │   │   ├── opportunity.py           # Opportunity model
│   │   │   └── match.py                 # Match model
│   │   ├── schemas/
│   │   │   ├── auth.py                  # Pydantic schemas for auth
│   │   │   ├── developer.py             # Developer profile schemas
│   │   │   ├── conversation.py          # Message schemas
│   │   │   └── opportunity.py           # Opportunity schemas
│   │   ├── services/
│   │   │   ├── ai/
│   │   │   │   ├── gateway.py           # AI Gateway Service (main)
│   │   │   │   ├── openai_client.py     # Azure OpenAI wrapper
│   │   │   │   ├── rag_client.py        # Ripple RAG integration
│   │   │   │   ├── embeddings.py        # Vector embedding service
│   │   │   │   └── conversation_manager.py  # Context management
│   │   │   ├── chat/
│   │   │   │   ├── unified_bot.py       # Unified Bot Service (core logic)
│   │   │   │   ├── adapters/
│   │   │   │   │   ├── base.py          # Base adapter interface
│   │   │   │   │   ├── slack.py         # Slack adapter
│   │   │   │   │   ├── discord.py       # Discord adapter
│   │   │   │   │   └── whatsapp.py      # WhatsApp adapter
│   │   │   │   └── context_sync.py      # Cross-channel context sync (Redis)
│   │   │   ├── matching/
│   │   │   │   ├── engine.py            # Matching algorithm (calculate_match_score)
│   │   │   │   ├── scorer.py            # Score components (skill, interest, readiness)
│   │   │   │   └── notifier.py          # Notification decision logic
│   │   │   ├── xrpl/
│   │   │   │   ├── service.py           # XRPL Service with circuit breaker
│   │   │   │   ├── client.py            # xrpl-py wrapper with failover
│   │   │   │   └── code_examples.py     # Generate XRPL code samples
│   │   │   ├── monitoring/
│   │   │   │   ├── grants_scraper.py    # XRPL Grants portal scraper
│   │   │   │   ├── hackathon_scraper.py # DevPost, ETHGlobal scrapers
│   │   │   │   └── opportunity_parser.py # Parse scraped data to Opportunity model
│   │   │   ├── email/
│   │   │   │   └── sendgrid.py          # SendGrid transactional email
│   │   │   └── profile/
│   │   │       ├── profiler.py          # Progressive profiling logic
│   │   │       └── resistance_detector.py # Detect resistance signals
│   │   ├── tasks/
│   │   │   ├── celery_app.py            # Celery configuration
│   │   │   ├── notifications.py         # Email, push notification tasks
│   │   │   ├── monitoring.py            # Ecosystem monitoring tasks
│   │   │   ├── matching.py              # Opportunity matching tasks
│   │   │   └── scheduler.py             # Celery beat schedule
│   │   ├── tests/
│   │   │   ├── api/                     # API endpoint tests
│   │   │   ├── services/                # Service layer tests
│   │   │   └── tasks/                   # Celery task tests
│   │   └── alembic/                     # Database migrations
│   ├── scripts/
│   │   ├── init_db.py                   # Create tables, extensions
│   │   └── seed_data.py                 # Seed test data
│   ├── Dockerfile
│   ├── requirements.txt
│   └── pyproject.toml
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   │   ├── auth/                    # Login, email verification
│   │   │   ├── dashboard/               # Progress overview
│   │   │   ├── profile/                 # Developer profile editor
│   │   │   ├── opportunities/           # Opportunity pipeline
│   │   │   ├── conversations/           # Conversation history search
│   │   │   └── settings/                # Channels, notifications, privacy
│   │   ├── routes/
│   │   │   ├── login.tsx
│   │   │   ├── dashboard.tsx
│   │   │   ├── profile.tsx
│   │   │   └── opportunities.tsx
│   │   ├── client/                      # Generated TypeScript SDK
│   │   ├── hooks/                       # TanStack Query hooks
│   │   └── main.tsx
│   ├── Dockerfile
│   ├── package.json
│   └── vite.config.ts
├── infra/
│   ├── bicep/                           # Azure infrastructure as code
│   │   ├── main.bicep                   # Main template
│   │   ├── container-apps.bicep         # Container Apps
│   │   ├── database.bicep               # PostgreSQL + Redis
│   │   ├── storage.bicep                # Blob Storage
│   │   ├── key-vault.bicep              # Key Vault
│   │   └── monitoring.bicep             # Application Insights
│   └── scripts/
│       └── deploy.sh                    # Deployment script
├── docker-compose.yml                   # Local development
├── docker-compose.override.yml          # Local overrides
├── .env.example                         # Environment variables template
├── .github/
│   └── workflows/
│       ├── test.yml                     # Run tests on PR
│       ├── build.yml                    # Build Docker images
│       └── deploy.yml                   # Deploy to Azure
└── README.md
```

## Epic to Architecture Mapping

| Epic/Requirement | Architecture Components | Technology | Files/Modules |
|------------------|-------------------------|------------|---------------|
| **Smart Onboarding (FR-1)** | Email Auth + Progressive Profiling | JWT + SendGrid | `api/routes/auth.py`, `services/profile/profiler.py`, `services/email/sendgrid.py` |
| **Adaptive Learning Path (FR-2)** | AI Gateway + Conversation Manager | Azure OpenAI + RAG | `services/ai/gateway.py`, `services/ai/conversation_manager.py`, `services/ai/rag_client.py` |
| **Proactive Success Guidance (FR-3)** | Matching Engine + Ecosystem Monitoring | pgvector + Celery | `services/matching/engine.py`, `services/monitoring/`, `tasks/matching.py` |
| **Code Partner Bot (FR-4)** | Unified Bot + Multi-Channel Adapters | Slack SDK + Discord.py | `services/chat/unified_bot.py`, `services/chat/adapters/`, `services/xrpl/code_examples.py` |
| **Empower Loop (FR-5)** | Challenge Engine + Gamification Service | Celery + PostgreSQL + Redis | `services/gamification/challenge_engine.py`, `services/gamification/xp_tracker.py`, `models/challenge.py`, `tasks/daily_challenges.py` |
| **Market Bridge (FR-6)** | Job Monitor + Matching Engine + Mentor DB | Celery + pgvector + PostgreSQL | `services/market/job_monitor.py`, `services/market/mentor_matcher.py`, `models/job.py`, `tasks/job_scraping.py` |
| **Impact Dashboard (FR-7)** | Analytics Engine + Portfolio Builder | PostgreSQL + React + Azure Blob | `services/analytics/metrics.py`, `services/analytics/portfolio_builder.py`, `api/routes/analytics.py`, `frontend/src/routes/impact.tsx` |
| **Multi-Channel Support (FR-8)** | Adapter Pattern + Context Sync | Redis pub/sub | `services/chat/adapters/base.py`, `services/chat/context_sync.py` |
| **Developer Dashboard (FR-9)** | React Frontend + TypeScript SDK | React + TanStack | `frontend/src/routes/dashboard.tsx`, `frontend/src/client/` |
| **Privacy Controls (FR-10)** | User Settings + GDPR Tools | PostgreSQL JSONB | `api/routes/developers.py`, `models/user.py` |
| **Opportunity Pipeline (FR-11)** | Opportunity API + Match Storage | PostgreSQL + Redis | `api/routes/opportunities.py`, `models/match.py` |
| **Performance (NFR-1)** | Redis Cache + Async I/O | Redis + FastAPI | All services use `async/await`, RAG cache in `services/ai/gateway.py` |
| **Scalability (NFR-2)** | Azure Container Apps + KEDA | Azure | `infra/bicep/container-apps.bicep` |
| **Security (NFR-3)** | AES-256 + Key Vault + JWT | Azure Key Vault | `core/security.py`, `infra/bicep/key-vault.bicep` |
| **Reliability (NFR-4)** | Circuit Breaker + Failover | xrpl-py | `services/xrpl/service.py` (99.9% uptime target) |
| **Maintainability (NFR-5)** | Structured Logging + Monitoring | structlog + App Insights | All services, `infra/bicep/monitoring.bicep` |
| **Compliance (NFR-6)** | GDPR Tools + Data Retention | PostgreSQL partitions | Monthly partitions for messages, user deletion in `api/routes/developers.py` |

## Technology Stack Details

### Core Technologies

**Backend Stack:**
- **FastAPI 0.121.0** - High-performance async web framework with automatic OpenAPI docs
- **Python 3.12+** - Type hints, pattern matching, improved error messages
- **SQLModel** - ORM combining SQLAlchemy + Pydantic for async operations
- **Pydantic v2** - Data validation with 5-50x performance improvements
- **Alembic** - Database migration management with version control
- **uvicorn** - Lightning-fast ASGI server

**Database Layer:**
- **PostgreSQL 17** - Primary relational database with ACID guarantees
- **pgvector 0.5+** - Vector similarity search for ML embeddings (384 dimensions)
- **Redis 7.2+** - Three uses: (1) RAG response cache, (2) Celery message broker, (3) cross-channel session storage

**Background Processing:**
- **Celery 5.3+** - Distributed task queue with priority queues
- **Celery Beat** - Cron-like scheduler for periodic tasks (ecosystem monitoring every 6 hours)
- **Flower** - Real-time Celery monitoring dashboard

**AI/ML Services:**
- **Azure OpenAI Service** - GPT-4 Turbo (128k context window) for conversations
- **Ripple RAG Service** - Enterprise-grade XRPL documentation retrieval
- **text-embedding-ada-002** - OpenAI embeddings (384-dimensional vectors)

**Frontend Stack:**
- **React 18** - UI library with concurrent features
- **TypeScript 5+** - Type safety for frontend code
- **Vite 5+** - Build tool with <50ms HMR (Hot Module Replacement)
- **Chakra UI 2+** - WCAG AA accessible component library
- **TanStack Query v5** - Server state management with caching
- **TanStack Router v1** - Type-safe routing with code splitting
- **Axios** - HTTP client for API calls (generated SDK)

**Testing & Quality:**
- **Pytest** - Backend unit and integration tests with async support
- **Playwright** - End-to-end browser testing across Chromium, Firefox, WebKit
- **Ruff** - Blazing-fast Python linter (10-100x faster than Flake8)
- **mypy** - Static type checking for Python
- **ESLint + Prettier** - Frontend linting and formatting

**DevOps & Infrastructure:**
- **Docker + Docker Compose** - Local development environment
- **Azure Bicep** - Infrastructure as Code (IaC) for Azure resources
- **GitHub Actions** - CI/CD pipelines for test, build, deploy
- **Pre-commit hooks** - Automated code quality checks before commit

### Integration Points

**External Service Integration:**

1. **Chat Platform APIs**
   - **Slack API** - OAuth2 authentication, Events API for real-time messages, Block Kit for rich formatting
   - **Discord API** - Gateway WebSocket for events, embeds for rich cards, slash commands
   - **WhatsApp Business API** - Webhook for incoming messages, 24-hour message window constraint
   - **Integration Pattern:** Each adapter implements `BaseChatAdapter` interface, publishes events to Redis pub/sub

2. **XRPL Blockchain**
   - **Primary Nodes:** `s1.ripple.com:51234` (mainnet), `s.altnet.rippletest.net:51234` (testnet)
   - **Fallback Nodes:** XRPL Labs public nodes
   - **Protocol:** JSON-RPC over HTTPS
   - **Circuit Breaker:** Automatic failover on timeout (>5s) or HTTP 5xx errors

3. **Azure Services**
   - **Azure OpenAI:** REST API with streaming support, API key authentication
   - **Azure Key Vault:** Secrets stored encrypted, retrieved at runtime via Managed Identity
   - **Azure Blob Storage:** Developer exports (CSV, JSON), conversation logs
   - **Azure Application Insights:** Structured JSON logs, custom metrics, distributed tracing

4. **Email Service**
   - **SendGrid API** - Transactional email with templates, webhook for delivery events
   - **Templates:** Verification code, opportunity alert, weekly digest
   - **Deliverability:** SPF, DKIM, DMARC configured for domain

5. **Ripple RAG Service**
   - **Endpoint:** `https://rag.ripple.com/api/v1/query` (hypothetical - confirm with Ripple)
   - **Authentication:** API key in header
   - **Response Format:** JSON with `answer`, `confidence`, `sources`
   - **Fallback Strategy:** If confidence < 0.8, route to Azure OpenAI

## Novel Architectural Pattern: Proactive Success Orchestration

**Pattern Name:** Proactive Success Orchestration Engine (PSOE)

**Problem Statement:** Traditional developer tools are reactive - they wait for developers to search for opportunities. XRPL Guru must proactively identify the perfect opportunity at the perfect moment for each developer, considering skill match, readiness, timing, and personal interests. This requires continuous ecosystem monitoring, intelligent matching, and context-aware notification logic - a pattern not found in standard SaaS architectures.

**Solution Architecture:**

### Components

```
┌─────────────────────────────────────────────────────────────────┐
│                  Proactive Success Orchestration                 │
└─────────────────────────────────────────────────────────────────┘
           ▲                    ▲                    ▲
           │                    │                    │
    ┌──────┴──────┐      ┌─────┴──────┐      ┌─────┴──────┐
    │  Ecosystem  │      │  Matching  │      │   Smart    │
    │  Monitors   │      │   Engine   │      │ Notifier   │
    │  (Scrapers) │      │  (ML-based)│      │ (Context)  │
    └──────┬──────┘      └─────┬──────┘      └─────┬──────┘
           │                    │                    │
           │                    │                    │
    ┌──────▼────────────────────▼────────────────────▼──────┐
    │              PostgreSQL + pgvector + Redis            │
    │   (Opportunities, Developer Profiles, Match Cache)    │
    └───────────────────────────────────────────────────────┘
```

### Data Flow

**Phase 1: Continuous Ecosystem Monitoring** (Every 6 hours via Celery Beat)
```python
# tasks/monitoring.py
@celery.app.task
def monitor_xrpl_ecosystem():
    """Scrape all opportunity sources in parallel"""
    sources = [
        scrape_xrpl_grants(),      # XRPL Grants portal
        scrape_devpost_hackathons(), # DevPost API
        scrape_ethglobal(),          # ETHGlobal GraphQL
        scrape_ripple_careers()      # Ripple jobs page
    ]

    new_opportunities = await asyncio.gather(*sources)

    for opp in new_opportunities:
        # Generate embedding for opportunity skills
        opp_vector = await embeddings_service.embed(opp.skills_text)

        # Store in database
        await db.execute(
            INSERT INTO opportunities (type, data, required_skills_vector, deadline)
            VALUES (:type, :data, :vector, :deadline)
        )

        # Trigger incremental matching
        trigger_incremental_match.delay(opp.id)
```

**Phase 2: Incremental Matching** (Delta only - triggered by new opportunities)
```python
# services/matching/engine.py
async def calculate_match_score(dev: Developer, opp: Opportunity) -> float:
    """
    Multi-dimensional scoring algorithm (0-100 points)

    Components:
    - Skill Match (30 pts): Cosine similarity between dev.skill_vector and opp.required_skills_vector
    - Interest Match (25 pts): Overlap between dev.interests and opp.category
    - Readiness Match (25 pts): Experience level + project count vs. opp requirements
    - Timing Intelligence (15 pts): Days until deadline (sweet spot: 7-21 days)
    - Location Match (5 pts): Remote-friendly or location overlap
    """

    # 1. Skill Match (30 points) - Semantic similarity via ML embeddings
    skill_score = cosine_similarity(dev.skill_vector, opp.required_skills_vector) * 30

    # 2. Interest Match (25 points) - Explicit preferences
    interest_overlap = len(set(dev.interests) & set(opp.tags))
    interest_score = min(interest_overlap / 3, 1.0) * 25  # Max at 3+ matching interests

    # 3. Readiness Match (25 points) - Experience gates
    has_min_projects = dev.projects_count >= opp.min_projects
    has_min_experience = dev.xrpl_experience_months >= opp.min_experience
    readiness_score = (has_min_projects and has_min_experience) * 25

    # 4. Timing Intelligence (15 points) - Deadline proximity
    days_until_deadline = (opp.deadline - datetime.utcnow()).days
    if 7 <= days_until_deadline <= 21:
        timing_score = 15  # Sweet spot: enough time but urgent
    elif 3 <= days_until_deadline <= 30:
        timing_score = 10  # Acceptable window
    else:
        timing_score = 5   # Too soon or too far

    # 5. Location Match (5 points) - Geography or remote
    location_score = 5 if (opp.remote or dev.location == opp.location) else 0

    total_score = skill_score + interest_score + readiness_score + timing_score + location_score

    # Store match result with metadata
    await db.execute(
        INSERT INTO matches (developer_id, opportunity_id, score, metadata, created_at)
        VALUES (:dev_id, :opp_id, :score, :breakdown, NOW())
        ON CONFLICT (developer_id, opportunity_id) DO UPDATE SET score = :score
    )

    return total_score

# Incremental matching (process only new opportunities)
async def match_new_opportunity(opp_id: UUID):
    """Match single opportunity against ALL active developers"""
    opp = await db.get(Opportunity, opp_id)

    # Use pgvector for pre-filtering (find top 1000 by skill similarity)
    candidates = await db.execute(
        SELECT user_id, skill_vector <=> :opp_vector AS distance
        FROM developer_profiles
        WHERE profile_data->>'active' = 'true'
        ORDER BY skill_vector <=> :opp_vector
        LIMIT 1000
    )

    # Calculate full scores for candidates
    scores = await asyncio.gather(*[
        calculate_match_score(dev, opp) for dev in candidates
    ])

    # Cache high-scoring matches in Redis (score >= 70)
    high_matches = [m for m in scores if m.score >= 70]
    await redis.zadd(f"matches:{opp_id}", {m.dev_id: m.score for m in high_matches})
```

**Phase 3: Context-Aware Notification** (Respects conversation state + resistance signals)
```python
# services/matching/notifier.py
async def should_notify_developer(dev_id: UUID, match: Match) -> bool:
    """
    Intelligent notification logic - avoid notification fatigue

    Rules:
    1. Threshold: Only notify if match score >= 75/100
    2. Frequency cap: Max 2 opportunity alerts per week
    3. Conversation state: Don't interrupt active learning sessions
    4. Resistance detection: If dev dismissed last 3 suggestions, pause for 2 weeks
    5. Time of day: Respect dev timezone (9 AM - 9 PM local time)
    """

    # Rule 1: Score threshold
    if match.score < 75:
        return False

    # Rule 2: Frequency cap
    recent_notifications = await redis.zcount(
        f"notifications:{dev_id}",
        datetime.utcnow() - timedelta(days=7),
        datetime.utcnow()
    )
    if recent_notifications >= 2:
        return False

    # Rule 3: Conversation state (check Redis for active session)
    active_session = await redis.get(f"session:{dev_id}")
    if active_session and json.loads(active_session).get('topic') == 'learning':
        return False  # Don't interrupt active learning

    # Rule 4: Resistance detection
    dismissal_count = await db.execute(
        SELECT COUNT(*) FROM match_interactions
        WHERE developer_id = :dev_id
        AND action = 'dismissed'
        AND created_at > NOW() - INTERVAL '14 days'
    )
    if dismissal_count >= 3:
        return False  # Pause notifications

    # Rule 5: Time of day (use dev timezone from profile)
    dev_hour = datetime.now(tz=dev.timezone).hour
    if not (9 <= dev_hour <= 21):
        return False  # Outside waking hours

    return True  # All gates passed - notify!

# Notification delivery
async def deliver_notification(dev_id: UUID, match: Match):
    """Send via preferred channel with rich context"""
    dev = await db.get(Developer, dev_id)
    opp = await db.get(Opportunity, match.opportunity_id)

    # Get active channel
    preferred_channel = await db.execute(
        SELECT * FROM channels
        WHERE user_id = :dev_id
        ORDER BY last_used_at DESC
        LIMIT 1
    )

    # Send via appropriate adapter
    adapter = get_adapter(preferred_channel.platform)  # SlackAdapter, DiscordAdapter, etc.

    await adapter.send_opportunity_alert(
        user_id=preferred_channel.platform_user_id,
        opportunity=opp,
        match_score=match.score,
        personalized_message=f"Based on your {dev.top_skill} expertise and interest in {opp.category}"
    )

    # Track notification
    await redis.zadd(f"notifications:{dev_id}", {opp.id: time.time()})
```

### Implementation Strategy

**Database Optimization:**
```sql
-- pgvector index for fast similarity search (IVFFlat algorithm)
CREATE INDEX idx_skill_similarity ON developer_profiles
USING ivfflat (skill_vector vector_cosine_ops)
WITH (lists = 100);  -- Divide space into 100 clusters

-- Partial index for active developers only
CREATE INDEX idx_active_developers ON developer_profiles (user_id)
WHERE (profile_data->>'active')::boolean = true;

-- Composite index for match lookups
CREATE INDEX idx_matches_score ON matches (opportunity_id, score DESC)
WHERE score >= 70;
```

**Celery Specialized Workers:**
```yaml
# docker-compose.yml
services:
  worker-matching:
    image: xrpl-guru-backend
    command: celery -A app.tasks worker -Q matching -c 5 --max-tasks-per-child=100
    environment:
      - WORKER_TYPE=matching
    deploy:
      replicas: 3  # Scale for 100 opps × 10K devs = 1M calculations daily

  worker-monitoring:
    image: xrpl-guru-backend
    command: celery -A app.tasks worker -Q monitoring -c 2
    deploy:
      replicas: 2  # Redundancy for critical monitoring
```

**Redis Caching Strategy:**
```python
# Cache match results for 24 hours (opportunities don't change daily)
MATCH_CACHE_TTL = 86400  # 24 hours

# Cache structure
# matches:{opp_id} -> sorted set {dev_id: score} (top 100 only)
# notifications:{dev_id} -> sorted set {opp_id: timestamp}
# session:{dev_id} -> JSON {topic, last_interaction, context}
```

### Monitoring & Metrics

**Key Performance Indicators:**
- **Matching Throughput:** Process 100 new opportunities × 10K developers in < 6 hours
- **Notification Precision:** >40% click-through rate on opportunity alerts (vs. industry 5-15%)
- **Latency:** Match calculation < 50ms per developer (vectorized operations)
- **Cache Hit Rate:** >90% for repeat opportunity queries

**Application Insights Custom Metrics:**
```python
# Log match quality for ML improvement
telemetry.track_metric("match_score_distribution", match.score, {
    "opportunity_type": opp.type,
    "developer_experience": dev.xrpl_experience_months
})

# Track notification effectiveness
telemetry.track_event("opportunity_notification", {
    "match_score": match.score,
    "channel": preferred_channel.platform,
    "action": "clicked" | "dismissed" | "applied"
})
```

## Gamification Architecture: Empower Loop (FR-5)

The Empower Loop provides challenge-based learning with XP/badge progression to maintain developer engagement through gamification.

### Components

```
┌─────────────────────────────────────────────────────────────────┐
│                    Gamification Orchestration                    │
└─────────────────────────────────────────────────────────────────┘
           ▲                    ▲                    ▲
           │                    │                    │
    ┌──────┴──────┐      ┌─────┴──────┐      ┌─────┴──────┐
    │  Challenge  │      │   XP & Badge│      │ Leaderboard│
    │   Engine    │      │   Tracker   │      │   Service  │
    │  (Daily)    │      │  (Rewards)  │      │  (Rankings)│
    └──────┬──────┘      └─────┬──────┘      └─────┬──────┘
           │                    │                    │
           │                    │                    │
    ┌──────▼────────────────────▼────────────────────▼──────┐
    │         PostgreSQL (Challenges, XP, Badges)           │
    │         Redis (Leaderboard Cache, Streaks)            │
    └───────────────────────────────────────────────────────┘
```

### Data Flow

**Phase 1: Daily Challenge Generation** (9 AM developer timezone via Celery Beat)
```python
# tasks/daily_challenges.py
@celery.app.task
def generate_daily_challenges():
    """Generate personalized challenges for all active developers"""
    active_devs = await db.execute(
        SELECT user_id, skill_level, recent_activity
        FROM developer_profiles
        WHERE (profile_data->>'active')::boolean = true
    )

    for dev in active_devs:
        # Match challenge difficulty to developer capability
        challenge = await challenge_engine.generate_challenge(
            skill_level=dev.skill_level,
            interests=dev.interests,
            recent_topics=dev.recent_activity
        )

        # Send via preferred channel
        await bot_service.send_challenge(
            dev_id=dev.user_id,
            challenge=challenge,
            estimated_time=challenge.estimated_minutes
        )
```

**Phase 2: XP & Badge Award** (On challenge completion)
```python
# services/gamification/xp_tracker.py
async def award_challenge_completion(dev_id: UUID, challenge_id: UUID):
    """Award XP and check badge eligibility"""
    challenge = await db.get(Challenge, challenge_id)

    # Award XP based on difficulty
    xp_award = {
        "easy": 25,      # ⭐
        "medium": 50,    # ⭐⭐
        "hard": 100,     # ⭐⭐⭐
        "expert": 200    # ⭐⭐⭐⭐
    }[challenge.difficulty]

    # Bonus for streak
    streak_days = await redis.get(f"streak:{dev_id}") or 0
    if streak_days >= 7:
        xp_award *= 1.5  # 50% bonus for 7+ day streak

    # Update developer XP
    await db.execute(
        UPDATE developer_profiles
        SET total_xp = total_xp + :xp,
            level = floor(sqrt(total_xp / 100))
        WHERE user_id = :dev_id
    )

    # Check badge eligibility
    await check_and_award_badges(dev_id, challenge.category)

    # Update leaderboard cache
    await redis.zadd("leaderboard:global", {dev_id: total_xp})
```

**Phase 3: Leaderboard Management** (Real-time via Redis sorted sets)
```python
# services/gamification/leaderboard.py
async def get_leaderboard(dev_id: UUID, scope: str = "global"):
    """Get leaderboard with developer's position"""

    # Redis sorted set: O(log N) for position lookup
    rank = await redis.zrevrank(f"leaderboard:{scope}", dev_id)
    top_10 = await redis.zrevrange(
        f"leaderboard:{scope}",
        0, 9,
        withscores=True
    )

    # Get developer's neighbors (±5 positions)
    neighbors = await redis.zrevrange(
        f"leaderboard:{scope}",
        max(0, rank - 5),
        rank + 5,
        withscores=True
    )

    return {
        "your_rank": rank + 1,
        "your_xp": await redis.zscore(f"leaderboard:{scope}", dev_id),
        "top_10": top_10,
        "neighbors": neighbors
    }
```

### Implementation Strategy

**Database Schema:**
```sql
-- Challenges table
CREATE TABLE challenges (
    id UUID PRIMARY KEY,
    category VARCHAR(50),  -- 'payment', 'nft', 'defi', 'amm', etc.
    difficulty VARCHAR(20), -- 'easy', 'medium', 'hard', 'expert'
    title VARCHAR(200),
    description TEXT,
    validation_criteria JSONB,  -- How to verify completion
    estimated_minutes INTEGER,
    xp_reward INTEGER,
    badge_id UUID REFERENCES badges(id),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Developer challenges (completion tracking)
CREATE TABLE developer_challenges (
    developer_id UUID REFERENCES users(id),
    challenge_id UUID REFERENCES challenges(id),
    status VARCHAR(20),  -- 'active', 'completed', 'abandoned'
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    completion_proof JSONB,  -- Transaction hash, code snippet, etc.
    xp_awarded INTEGER,
    PRIMARY KEY (developer_id, challenge_id)
);

-- Badges
CREATE TABLE badges (
    id UUID PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    icon_url VARCHAR(500),
    criteria JSONB,  -- Unlock conditions
    rarity VARCHAR(20)  -- 'common', 'rare', 'epic', 'legendary'
);

-- Developer badges (awards)
CREATE TABLE developer_badges (
    developer_id UUID REFERENCES users(id),
    badge_id UUID REFERENCES badges(id),
    awarded_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (developer_id, badge_id)
);
```

**Redis Caching:**
```python
# Leaderboards (sorted sets for O(log N) lookups)
# leaderboard:global -> {dev_id: total_xp}
# leaderboard:monthly -> {dev_id: monthly_xp}

# Streaks (strings with expiry)
# streak:{dev_id} -> consecutive_days (expires if >48h without activity)

# Active challenges (hashes)
# active_challenge:{dev_id} -> {challenge_id, started_at, progress}
```

## Market Bridge Architecture: Jobs, Mentors, Startups (FR-6)

The Market Bridge connects developers to XRPL ecosystem opportunities: job openings, mentor relationships, and startup collaborations.

### Components

```
┌─────────────────────────────────────────────────────────────────┐
│                  Market Bridge Orchestration                     │
└─────────────────────────────────────────────────────────────────┘
           ▲                    ▲                    ▲
           │                    │                    │
    ┌──────┴──────┐      ┌─────┴──────┐      ┌─────┴──────┐
    │   Job       │      │   Mentor   │      │  Startup   │
    │  Monitor    │      │  Matcher   │      │  Discovery │
    │ (Scraping)  │      │(Expertise) │      │(Ecosystem) │
    └──────┬──────┘      └─────┬──────┘      └─────┬──────┘
           │                    │                    │
           │                    │                    │
    ┌──────▼────────────────────▼────────────────────▼──────┐
    │   PostgreSQL (Jobs, Mentors, Startups) + pgvector    │
    └───────────────────────────────────────────────────────┘
```

### Data Flow

**Phase 1: Job Monitoring** (Daily scraping via Celery Beat)
```python
# tasks/job_scraping.py
@celery.app.task
def scrape_xrpl_jobs():
    """Scrape XRPL ecosystem job boards"""
    sources = [
        scrape_ripple_careers(),      # Ripple official jobs
        scrape_xrpl_labs_careers(),   # XRPL Labs
        scrape_ecosystem_startups(),  # Partner companies
        scrape_remote_boards()        # We Work Remotely, Remote.co
    ]

    new_jobs = await asyncio.gather(*sources)

    for job in new_jobs:
        # Generate skill embedding
        job_vector = await embeddings_service.embed(
            f"{job.title} {job.description} {job.required_skills}"
        )

        # Store with deduplication
        await db.execute(
            INSERT INTO jobs (company, title, description, skills_vector, posted_at)
            VALUES (:company, :title, :desc, :vector, :posted)
            ON CONFLICT (company, title) DO UPDATE
            SET updated_at = NOW()
        )

        # Trigger matching
        await match_job_to_developers.delay(job.id)
```

**Phase 2: Mentor Matching Algorithm**
```python
# services/market/mentor_matcher.py
async def find_mentors(dev_id: UUID, focus_area: str):
    """Match developer with relevant mentors"""
    dev = await db.get(Developer, dev_id)

    # Find mentors with expertise in focus area
    mentors = await db.execute(
        SELECT m.*, m.expertise_vector <=> :dev_vector AS distance
        FROM mentors m
        WHERE :focus_area = ANY(m.expertise_areas)
        AND m.accepting_mentees = true
        ORDER BY m.expertise_vector <=> :dev_vector
        LIMIT 5
    )

    # Score mentors (0-100)
    for mentor in mentors:
        score = calculate_mentor_match(
            dev_skills=dev.skill_vector,
            mentor_expertise=mentor.expertise_vector,
            dev_interests=dev.interests,
            mentor_focus=mentor.expertise_areas,
            language_overlap=set(dev.languages) & set(mentor.languages)
        )
        mentor.match_score = score

    # Return top 3 with match explanations
    return sorted(mentors, key=lambda m: m.match_score, reverse=True)[:3]
```

**Phase 3: Startup Discovery**
```python
# services/market/startup_discovery.py
async def discover_startups(dev_id: UUID):
    """Surface XRPL startups matching developer interests"""
    dev = await db.get(Developer, dev_id)

    # Query startups in ecosystem
    startups = await db.execute(
        SELECT s.*
        FROM startups s
        WHERE s.status = 'active'
        AND s.category && :dev_interests  -- PostgreSQL array overlap
        ORDER BY s.founded_date DESC
        LIMIT 10
    )

    # Enrich with context
    for startup in startups:
        startup.why_relevant = f"Building in {startup.category} - matches your interest"
        startup.open_roles = await db.execute(
            SELECT COUNT(*) FROM jobs
            WHERE company = :startup_name
            AND status = 'open'
        )

    return startups
```

### Implementation Strategy

**Database Schema:**
```sql
-- Jobs table
CREATE TABLE jobs (
    id UUID PRIMARY KEY,
    company VARCHAR(200),
    title VARCHAR(200),
    description TEXT,
    required_skills TEXT[],
    skills_vector vector(384),  -- Embedding for semantic search
    location VARCHAR(100),
    remote_friendly BOOLEAN,
    salary_range_min INTEGER,
    salary_range_max INTEGER,
    posted_at TIMESTAMP,
    deadline TIMESTAMP,
    status VARCHAR(20) DEFAULT 'open',
    UNIQUE(company, title)
);

-- Mentors table
CREATE TABLE mentors (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    name VARCHAR(200),
    expertise_areas TEXT[],  -- ['defi', 'nft', 'payments']
    expertise_vector vector(384),  -- Embedding of expertise
    bio TEXT,
    languages TEXT[],  -- ['en', 'es', 'pt']
    accepting_mentees BOOLEAN DEFAULT true,
    max_mentees INTEGER DEFAULT 5,
    current_mentees INTEGER DEFAULT 0,
    calendar_link VARCHAR(500)
);

-- Startups table
CREATE TABLE startups (
    id UUID PRIMARY KEY,
    name VARCHAR(200),
    category TEXT[],  -- ['defi', 'remittance', 'gaming']
    description TEXT,
    founded_date DATE,
    team_size VARCHAR(20),  -- '1-10', '11-50', '51-200'
    funding_stage VARCHAR(50),  -- 'pre-seed', 'seed', 'series-a'
    website VARCHAR(500),
    status VARCHAR(20) DEFAULT 'active'
);

-- Job applications (tracking)
CREATE TABLE job_applications (
    developer_id UUID REFERENCES users(id),
    job_id UUID REFERENCES jobs(id),
    applied_at TIMESTAMP DEFAULT NOW(),
    status VARCHAR(20),  -- 'applied', 'interviewing', 'accepted', 'rejected'
    PRIMARY KEY (developer_id, job_id)
);
```

## Analytics & Portfolio Architecture: Impact Dashboard (FR-7)

The Impact Dashboard provides developers with progress visualization, metrics analysis, and auto-generated portfolio.

### Components

```
┌─────────────────────────────────────────────────────────────────┐
│                   Analytics Orchestration                        │
└─────────────────────────────────────────────────────────────────┘
           ▲                    ▲                    ▲
           │                    │                    │
    ┌──────┴──────┐      ┌─────┴──────┐      ┌─────┴──────┐
    │  Metrics    │      │ Portfolio  │      │   Export   │
    │  Calculator │      │  Builder   │      │  Service   │
    │ (Real-time) │      │(Auto-gen)  │      │(CSV/JSON)  │
    └──────┬──────┘      └─────┬──────┘      └─────┬──────┘
           │                    │                    │
           │                    │                    │
    ┌──────▼────────────────────▼────────────────────▼──────┐
    │    PostgreSQL (Metrics, Projects, Portfolio Data)     │
    │    Azure Blob Storage (Exports, Portfolio Pages)      │
    └───────────────────────────────────────────────────────┘
```

### Data Flow

**Phase 1: Metrics Calculation** (Real-time aggregation)
```python
# services/analytics/metrics.py
async def calculate_developer_metrics(dev_id: UUID, period: str = "all_time"):
    """Calculate comprehensive developer metrics"""

    # Skills progression
    skill_metrics = await db.execute(
        SELECT
            topic,
            level,
            validated_at
        FROM knowledge_matrix
        WHERE developer_id = :dev_id
        ORDER BY validated_at
    )

    # Learning activity
    activity_metrics = await db.execute(
        SELECT
            COUNT(*) FILTER (WHERE type = 'challenge') as challenges_completed,
            COUNT(*) FILTER (WHERE type = 'conversation') as learning_sessions,
            SUM(xp_gained) as total_xp,
            array_agg(DISTINCT topic) as topics_explored
        FROM developer_activity
        WHERE developer_id = :dev_id
        AND created_at >= :period_start
    )

    # Opportunities
    opportunity_metrics = await db.execute(
        SELECT
            COUNT(*) FILTER (WHERE action = 'applied') as opportunities_applied,
            COUNT(*) FILTER (WHERE action = 'accepted') as opportunities_accepted,
            array_agg(opportunity_type) as opportunity_types
        FROM match_interactions
        WHERE developer_id = :dev_id
    )

    # XRPL Projects
    project_metrics = await db.execute(
        SELECT
            COUNT(*) as total_projects,
            array_agg(tech_stack) as technologies_used,
            array_agg(github_url) as project_links
        FROM developer_projects
        WHERE developer_id = :dev_id
    )

    return {
        "skills": skill_metrics,
        "activity": activity_metrics,
        "opportunities": opportunity_metrics,
        "projects": project_metrics,
        "level": floor(sqrt(activity_metrics.total_xp / 100)),
        "badges_earned": await get_badge_count(dev_id)
    }
```

**Phase 2: Portfolio Auto-Generation**
```python
# services/analytics/portfolio_builder.py
async def generate_portfolio(dev_id: UUID):
    """Auto-generate portfolio webpage at xrplguru.dev/@{username}"""
    dev = await db.get(Developer, dev_id)
    metrics = await calculate_developer_metrics(dev_id)

    # Generate HTML portfolio
    portfolio_html = await render_template("portfolio.html", {
        "developer": dev,
        "bio": dev.bio or auto_generate_bio(dev, metrics),
        "skills": metrics["skills"],
        "badges": await get_developer_badges(dev_id),
        "projects": metrics["projects"],
        "github": dev.github_username,
        "level": metrics["level"],
        "total_xp": metrics["activity"]["total_xp"]
    })

    # Upload to Azure Blob Storage
    blob_client = blob_service.get_blob_client(
        container="portfolios",
        blob=f"{dev.username}.html"
    )
    await blob_client.upload_blob(portfolio_html, overwrite=True)

    # Return public URL
    return f"https://xrplguru.dev/@{dev.username}"
```

**Phase 3: Data Export Service**
```python
# services/analytics/export_service.py
async def export_metrics(dev_id: UUID, format: str = "csv"):
    """Export developer metrics to CSV or JSON"""
    metrics = await calculate_developer_metrics(dev_id)

    if format == "csv":
        # Generate CSV
        csv_data = generate_csv(metrics)
        filename = f"{dev_id}_metrics_{datetime.utcnow().isoformat()}.csv"
    else:
        # Generate JSON
        json_data = json.dumps(metrics, indent=2)
        filename = f"{dev_id}_metrics_{datetime.utcnow().isoformat()}.json"

    # Upload to Azure Blob (expires in 7 days)
    blob_url = await upload_to_blob(
        container="exports",
        filename=filename,
        data=csv_data or json_data,
        expiry_days=7
    )

    # Send download link via chat
    await bot_service.send_message(
        dev_id=dev_id,
        message=f"Your metrics export is ready! Download: {blob_url}\n(Expires in 7 days)"
    )

    return blob_url
```

### Implementation Strategy

**Database Schema:**
```sql
-- Developer projects
CREATE TABLE developer_projects (
    id UUID PRIMARY KEY,
    developer_id UUID REFERENCES users(id),
    title VARCHAR(200),
    description TEXT,
    tech_stack TEXT[],  -- ['xrpl-py', 'react', 'fastapi']
    github_url VARCHAR(500),
    demo_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT NOW(),
    featured BOOLEAN DEFAULT false
);

-- Developer activity log
CREATE TABLE developer_activity (
    id UUID PRIMARY KEY,
    developer_id UUID REFERENCES users(id),
    type VARCHAR(50),  -- 'challenge', 'conversation', 'validation', 'project'
    topic VARCHAR(100),  -- 'nft', 'defi', 'payments'
    xp_gained INTEGER DEFAULT 0,
    metadata JSONB,  -- Activity-specific details
    created_at TIMESTAMP DEFAULT NOW()
);

-- Portfolio settings
CREATE TABLE portfolio_settings (
    developer_id UUID PRIMARY KEY REFERENCES users(id),
    public_visibility BOOLEAN DEFAULT true,
    show_github BOOLEAN DEFAULT true,
    show_badges BOOLEAN DEFAULT true,
    custom_bio TEXT,
    theme VARCHAR(20) DEFAULT 'light',
    updated_at TIMESTAMP DEFAULT NOW()
);
```

**Azure Blob Storage Structure:**
```
portfolios/
  {username}.html        # Auto-generated portfolio pages

exports/
  {dev_id}_metrics_YYYY-MM-DD.csv
  {dev_id}_metrics_YYYY-MM-DD.json
  (auto-deleted after 7 days via lifecycle policy)
```

## Implementation Patterns

These patterns ensure consistent implementation across all AI agents:

### Service Layer Pattern

**All business logic lives in services/** - API routes delegate to services, never contain business logic.

```python
# ❌ BAD: Business logic in API route
@router.post("/opportunities/match")
async def match_opportunity(opp_id: UUID, db: Session = Depends(get_db)):
    developers = db.query(Developer).all()
    scores = []
    for dev in developers:
        skill_score = calculate_similarity(dev.skills, opp.skills)
        scores.append({"dev_id": dev.id, "score": skill_score})
    return scores

# ✅ GOOD: Delegate to service layer
@router.post("/opportunities/match")
async def match_opportunity(
    opp_id: UUID,
    matching_service: MatchingService = Depends(get_matching_service)
):
    """Trigger matching for new opportunity"""
    matches = await matching_service.match_opportunity(opp_id)
    return {"matches": matches, "count": len(matches)}
```

### Dependency Injection Pattern

**Use FastAPI's Depends()** for all external dependencies (DB, Redis, services).

```python
# app/api/deps.py
async def get_db() -> AsyncGenerator[AsyncSession, None]:
    async with AsyncSessionLocal() as session:
        yield session

async def get_redis() -> Redis:
    return redis_client

def get_ai_gateway(
    db: AsyncSession = Depends(get_db),
    redis: Redis = Depends(get_redis)
) -> AIGateway:
    return AIGateway(db=db, cache=redis)

# Usage in routes
@router.post("/chat")
async def chat(
    message: str,
    gateway: AIGateway = Depends(get_ai_gateway),
    current_user: User = Depends(get_current_user)
):
    response = await gateway.process(message, user_id=current_user.id)
    return {"response": response}
```

### Async/Await Everywhere

**All I/O operations must be async** - Database, Redis, HTTP calls, file operations.

```python
# ✅ Database operations
async def get_developer(db: AsyncSession, user_id: UUID) -> Developer:
    result = await db.execute(select(Developer).where(Developer.id == user_id))
    return result.scalar_one_or_none()

# ✅ External API calls
async def query_ripple_rag(query: str) -> RAGResponse:
    async with httpx.AsyncClient() as client:
        response = await client.post(
            settings.RAG_ENDPOINT,
            json={"query": query},
            headers={"Authorization": f"Bearer {settings.RAG_API_KEY}"}
        )
        return RAGResponse(**response.json())

# ✅ Redis operations
async def cache_response(redis: Redis, key: str, value: str, ttl: int = 3600):
    await redis.setex(key, ttl, value)
```

### Type Hints Everywhere

**100% type coverage** - All functions, variables, return types must have type hints.

```python
from typing import Optional, List, Dict, Any
from uuid import UUID

async def calculate_match_score(
    dev: Developer,
    opp: Opportunity,
    weights: Optional[Dict[str, float]] = None
) -> float:
    """Calculate match score between developer and opportunity"""
    if weights is None:
        weights = {"skill": 0.3, "interest": 0.25, "readiness": 0.25}

    score: float = 0.0
    score += cosine_similarity(dev.skill_vector, opp.required_skills_vector) * weights["skill"]
    return score
```

### Pydantic Schemas for Validation

**All API inputs/outputs use Pydantic schemas** - Never use raw dicts or SQLModel directly in responses.

```python
# schemas/opportunity.py
from pydantic import BaseModel, Field, validator
from datetime import datetime
from typing import List

class OpportunityCreate(BaseModel):
    title: str = Field(..., min_length=5, max_length=200)
    type: str = Field(..., pattern="^(grant|hackathon|job|event)$")
    deadline: datetime
    required_skills: List[str] = Field(..., min_items=1)

    @validator("deadline")
    def deadline_must_be_future(cls, v):
        if v < datetime.utcnow():
            raise ValueError("Deadline must be in the future")
        return v

class OpportunityResponse(BaseModel):
    id: UUID
    title: str
    type: str
    deadline: datetime
    created_at: datetime

    class Config:
        from_attributes = True  # Pydantic v2 (formerly orm_mode)
```

### Circuit Breaker for External Services

**Wrap all external integrations** with retry + fallback logic.

```python
from tenacity import retry, stop_after_attempt, wait_exponential

class XRPLService:
    def __init__(self):
        self.nodes = ["https://s1.ripple.com:51234", "https://s.altnet.rippletest.net:51234"]
        self.current_node_index = 0

    @retry(
        stop=stop_after_attempt(3),
        wait=wait_exponential(multiplier=1, min=2, max=10)
    )
    async def get_account_info(self, address: str) -> Dict[str, Any]:
        """Get XRPL account info with automatic failover"""
        for i in range(len(self.nodes)):
            node = self.nodes[(self.current_node_index + i) % len(self.nodes)]
            try:
                async with httpx.AsyncClient(timeout=5.0) as client:
                    response = await client.post(
                        node,
                        json={"method": "account_info", "params": [{"account": address}]}
                    )
                    if response.status_code == 200:
                        self.current_node_index = (self.current_node_index + i) % len(self.nodes)
                        return response.json()
            except (httpx.TimeoutException, httpx.ConnectError) as e:
                logger.warning(f"Node {node} failed: {e}")
                continue

        raise XRPLServiceError("All XRPL nodes unavailable")
```

## Consistency Rules

### Naming Conventions

**Files and Modules:**
- **Files:** `snake_case.py` (e.g., `matching_engine.py`, `slack_adapter.py`)
- **Modules:** Same as file names without `.py` extension
- **Test files:** `test_<module>.py` (e.g., `test_matching_engine.py`)

**Python Code:**
- **Classes:** `PascalCase` (e.g., `MatchingEngine`, `SlackAdapter`, `AIGateway`)
- **Functions/methods:** `snake_case` (e.g., `calculate_match_score`, `send_notification`)
- **Constants:** `UPPER_SNAKE_CASE` (e.g., `MAX_NOTIFICATIONS_PER_WEEK`, `REDIS_CACHE_TTL`)
- **Private methods:** `_leading_underscore` (e.g., `_validate_score`, `_fetch_from_cache`)
- **Type variables:** `PascalCase` (e.g., `T`, `ModelT`, `ResponseT`)

**Database:**
- **Tables:** `snake_case` plural (e.g., `users`, `developer_profiles`, `opportunities`)
- **Columns:** `snake_case` (e.g., `user_id`, `created_at`, `skill_vector`)
- **Indexes:** `idx_<table>_<columns>` (e.g., `idx_matches_score`, `idx_developers_email`)
- **Foreign keys:** `fk_<table>_<reference>` (e.g., `fk_channels_user`)

**Frontend:**
- **Components:** `PascalCase.tsx` (e.g., `DeveloperProfile.tsx`, `OpportunityCard.tsx`)
- **Hooks:** `use<PascalCase>.ts` (e.g., `useDeveloperProfile.ts`, `useOpportunities.ts`)
- **Utilities:** `camelCase.ts` (e.g., `formatDate.ts`, `apiClient.ts`)

### Code Organization

**Backend Service Structure:**
```python
# services/ai/gateway.py
"""
AI Gateway Service - Orchestrates AI/ML requests

Responsibilities:
- Route queries to RAG or OpenAI
- Cache responses in Redis
- Manage conversation context
"""

from typing import Optional, Dict, Any
import structlog

logger = structlog.get_logger(__name__)

class AIGateway:
    """Central orchestration for all AI/ML requests"""

    def __init__(self, db: AsyncSession, cache: Redis):
        self.db = db
        self.cache = cache
        self.openai_client = AzureOpenAIClient()
        self.rag_client = RippleRAGClient()

    async def process(
        self,
        message: str,
        user_id: UUID,
        context: Optional[Dict[str, Any]] = None
    ) -> str:
        """Process user message with AI orchestration"""
        logger.info("ai_gateway.process", user_id=user_id, message_length=len(message))

        # Implementation...
        pass
```

**Frontend Component Structure:**
```typescript
// components/opportunities/OpportunityCard.tsx
import { Box, Heading, Text, Badge } from '@chakra-ui/react';
import { Opportunity } from '@/client';

interface OpportunityCardProps {
  opportunity: Opportunity;
  matchScore?: number;
  onApply: (opportunityId: string) => void;
}

export function OpportunityCard({ opportunity, matchScore, onApply }: OpportunityCardProps) {
  return (
    <Box>
      {/* Implementation */}
    </Box>
  );
}
```

### Error Handling

**Exception Hierarchy:**
```python
# core/exceptions.py
class XRPLGuruException(Exception):
    """Base exception for XRPL Guru"""
    pass

class ServiceException(XRPLGuruException):
    """Base for service-layer exceptions"""
    pass

class XRPLServiceError(ServiceException):
    """XRPL integration failures"""
    pass

class AIGatewayError(ServiceException):
    """AI/ML service failures"""
    pass

class MatchingEngineError(ServiceException):
    """Matching algorithm failures"""
    pass

class ValidationError(XRPLGuruException):
    """Input validation failures"""
    pass
```

**FastAPI Exception Handlers:**
```python
# main.py
from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse

app = FastAPI()

@app.exception_handler(XRPLServiceError)
async def xrpl_service_error_handler(request: Request, exc: XRPLServiceError):
    logger.error("xrpl_service_error", error=str(exc), path=request.url.path)
    return JSONResponse(
        status_code=503,
        content={
            "error": "XRPL service temporarily unavailable",
            "detail": "Please try again later",
            "request_id": request.state.request_id
        }
    )

@app.exception_handler(ValidationError)
async def validation_error_handler(request: Request, exc: ValidationError):
    return JSONResponse(
        status_code=400,
        content={
            "error": "Validation failed",
            "detail": str(exc)
        }
    )
```

**Error Logging:**
```python
# Always log errors with context
try:
    match_score = await matching_engine.calculate_match_score(dev, opp)
except MatchingEngineError as e:
    logger.error(
        "matching_failed",
        developer_id=dev.id,
        opportunity_id=opp.id,
        error=str(e),
        exc_info=True  # Include stack trace
    )
    raise
```

### Logging Strategy

**Structured Logging with structlog:**
```python
# core/logging.py
import structlog
from structlog.processors import JSONRenderer, TimeStamper, add_log_level

structlog.configure(
    processors=[
        structlog.contextvars.merge_contextvars,
        add_log_level,
        TimeStamper(fmt="iso"),
        JSONRenderer()
    ],
    wrapper_class=structlog.make_filtering_bound_logger(logging.INFO),
    context_class=dict,
    logger_factory=structlog.PrintLoggerFactory(),
)

# Usage in services
logger = structlog.get_logger(__name__)

async def match_opportunity(opp_id: UUID):
    logger.info("matching_started", opportunity_id=opp_id)

    start_time = time.time()
    matches = await _calculate_matches(opp_id)

    logger.info(
        "matching_completed",
        opportunity_id=opp_id,
        match_count=len(matches),
        duration_ms=(time.time() - start_time) * 1000
    )
```

**Log Levels:**
- **DEBUG:** Detailed diagnostic info (disabled in production)
- **INFO:** Normal operations (user actions, service calls, match results)
- **WARNING:** Recoverable issues (node failover, cache miss, rate limit)
- **ERROR:** Failures requiring attention (external service down, invalid data)
- **CRITICAL:** System-wide failures (database down, Redis unavailable)

## Data Architecture

### Database Schema

**Core Tables:**

```sql
-- Users and Authentication
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    hashed_password VARCHAR(255),  -- NULL for passwordless auth
    email_verified BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_users_email ON users(email);

-- Developer Profiles (Hybrid: SQL + JSONB + Vector)
CREATE TABLE developer_profiles (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,

    -- Structured fields (frequently queried)
    xrpl_experience_months INTEGER DEFAULT 0,
    projects_count INTEGER DEFAULT 0,
    location VARCHAR(100),
    timezone VARCHAR(50) DEFAULT 'UTC',

    -- Flexible fields (variable structure)
    profile_data JSONB NOT NULL DEFAULT '{}'::jsonb,
    -- profile_data structure:
    -- {
    --   "skills": ["JavaScript", "Python", "Solidity"],
    --   "interests": ["defi", "nft", "payments"],
    --   "goals": ["learn", "build", "contribute"],
    --   "resistance_signals": {"last_dismissal": "2025-01-15", "count": 2},
    --   "active": true
    -- }

    -- ML embedding (384 dimensions from text-embedding-ada-002)
    skill_vector vector(384),

    profile_updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_developer_interests ON developer_profiles USING GIN ((profile_data->'interests'));
CREATE INDEX idx_developer_skills ON developer_profiles USING GIN ((profile_data->'skills'));
CREATE INDEX idx_skill_vector ON developer_profiles USING ivfflat (skill_vector vector_cosine_ops) WITH (lists = 100);
CREATE INDEX idx_active_developers ON developer_profiles (user_id) WHERE (profile_data->>'active')::boolean = true;

-- Chat Channels (Multi-platform)
CREATE TABLE channels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    platform VARCHAR(50) NOT NULL,  -- 'slack', 'discord', 'whatsapp'
    platform_user_id VARCHAR(255) NOT NULL,  -- Platform-specific ID
    platform_team_id VARCHAR(255),  -- For Slack workspaces, Discord servers
    auth_token TEXT,  -- Encrypted OAuth token
    is_active BOOLEAN DEFAULT true,
    connected_at TIMESTAMP DEFAULT NOW(),
    last_used_at TIMESTAMP DEFAULT NOW(),

    UNIQUE(platform, platform_user_id, platform_team_id)
);

CREATE INDEX idx_channels_user ON channels(user_id);
CREATE INDEX idx_channels_platform ON channels(platform, platform_user_id);

-- Conversations (Session management)
CREATE TABLE conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    channel_id UUID REFERENCES channels(id) ON DELETE SET NULL,

    -- Context stored in JSONB for flexibility
    context JSONB DEFAULT '{}'::jsonb,
    -- context structure:
    -- {
    --   "topic": "learning" | "coding" | "opportunity",
    --   "current_lesson": "xrpl_basics_01",
    --   "conversation_stage": "onboarding" | "active" | "dormant",
    --   "last_intent": "ask_question" | "view_opportunity" | "request_code"
    -- }

    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_conversations_user ON conversations(user_id);
CREATE INDEX idx_conversations_updated ON conversations(updated_at DESC);

-- Messages (Partitioned by month for performance)
CREATE TABLE messages (
    id UUID DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
    role VARCHAR(20) NOT NULL CHECK (role IN ('user', 'assistant', 'system')),
    content TEXT NOT NULL,

    -- Optional metadata
    metadata JSONB,
    -- metadata examples:
    -- {"rag_used": true, "confidence": 0.95, "sources": [...]}
    -- {"code_example": true, "language": "javascript"}

    created_at TIMESTAMP DEFAULT NOW(),

    PRIMARY KEY (id, created_at)
) PARTITION BY RANGE (created_at);

-- Create monthly partitions (example for 2025)
CREATE TABLE messages_2025_01 PARTITION OF messages
    FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');

CREATE TABLE messages_2025_02 PARTITION OF messages
    FOR VALUES FROM ('2025-02-01') TO ('2025-03-01');

CREATE INDEX idx_messages_conversation ON messages(conversation_id, created_at DESC);

-- Opportunities
CREATE TABLE opportunities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type VARCHAR(50) NOT NULL CHECK (type IN ('grant', 'hackathon', 'job', 'event')),

    -- Flexible data storage
    data JSONB NOT NULL,
    -- data structure:
    -- {
    --   "title": "XRPL $100K Grants Program",
    --   "description": "...",
    --   "url": "https://...",
    --   "category": "defi",
    --   "tags": ["payment", "cross-border"],
    --   "min_projects": 1,
    --   "min_experience": 3,
    --   "location": "Remote",
    --   "remote": true,
    --   "prize": "$100,000",
    --   "source": "xrpl_grants"
    -- }

    -- ML embedding for required skills
    required_skills_vector vector(384),

    deadline TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_opportunities_type ON opportunities(type);
CREATE INDEX idx_opportunities_deadline ON opportunities(deadline) WHERE deadline > NOW();
CREATE INDEX idx_opportunities_category ON opportunities((data->>'category'));
CREATE INDEX idx_opportunities_vector ON opportunities USING ivfflat (required_skills_vector vector_cosine_ops);

-- Matches (Developer ↔ Opportunity)
CREATE TABLE matches (
    developer_id UUID REFERENCES users(id) ON DELETE CASCADE,
    opportunity_id UUID REFERENCES opportunities(id) ON DELETE CASCADE,

    score FLOAT NOT NULL CHECK (score >= 0 AND score <= 100),

    -- Score breakdown for transparency
    metadata JSONB,
    -- metadata structure:
    -- {
    --   "skill_score": 28.5,
    --   "interest_score": 25.0,
    --   "readiness_score": 25.0,
    --   "timing_score": 15.0,
    --   "location_score": 5.0
    -- }

    notified_at TIMESTAMP,
    viewed_at TIMESTAMP,
    interaction VARCHAR(20),  -- 'clicked', 'dismissed', 'applied'

    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),

    PRIMARY KEY (developer_id, opportunity_id)
);

CREATE INDEX idx_matches_developer ON matches(developer_id, score DESC);
CREATE INDEX idx_matches_opportunity ON matches(opportunity_id, score DESC);
CREATE INDEX idx_matches_high_score ON matches(score DESC) WHERE score >= 70;
CREATE INDEX idx_matches_notified ON matches(notified_at) WHERE notified_at IS NOT NULL;
```

### Data Relationships

```
┌──────────────┐
│    Users     │
└──────┬───────┘
       │ 1
       │
       │ 1                          ┌──────────────────┐
       ├────────────────────────────┤ Developer Profile│
       │                            │ (JSONB + Vector) │
       │                            └──────────────────┘
       │
       │ *                          ┌──────────────┐
       ├────────────────────────────┤   Channels   │
       │                            │ (Multi-platform)│
       │                            └──────────────┘
       │
       │ *                          ┌──────────────┐
       ├────────────────────────────┤ Conversations│
       │                            └──────┬───────┘
       │                                   │ *
       │                                   │
       │                            ┌──────▼───────┐
       │                            │   Messages   │
       │                            │ (Partitioned)│
       │                            └──────────────┘
       │
       │ *                                   * ┌──────────────────┐
       └───────────────────┐  ┌───────────────┤  Opportunities   │
                           │  │               │ (JSONB + Vector) │
                           │  │               └──────────────────┘
                     ┌─────▼──▼─────┐
                     │    Matches   │
                     │ (Score + Meta)│
                     └──────────────┘
```

### Redis Data Structures

**Cache Keys:**
```
# RAG Response Cache (24 hour TTL)
rag:response:{hash_of_query} -> JSON response

# Opportunity Match Cache (score >= 70 only)
matches:{opportunity_id} -> ZSET {developer_id: score}

# Notification Tracking (7 day rolling window)
notifications:{developer_id} -> ZSET {opportunity_id: timestamp}

# Active Session Context (1 hour TTL, refreshed on activity)
session:{developer_id} -> JSON {
    "topic": "learning",
    "last_interaction": "2025-01-15T14:30:00Z",
    "context": {...}
}

# Cross-Channel Context Sync (30 min TTL)
channel:context:{user_id}:{platform} -> JSON conversation_state
```

### Data Flow Patterns

**1. Progressive Profile Building:**
```python
# services/profile/profiler.py
async def update_profile_incrementally(user_id: UUID, new_data: Dict):
    """
    Update profile without overwriting existing data
    Uses PostgreSQL JSONB operators
    """
    await db.execute(
        UPDATE developer_profiles
        SET profile_data = profile_data || :new_data,  -- || merges JSONB
            profile_updated_at = NOW()
        WHERE user_id = :user_id
    )

    # Regenerate skill vector if skills changed
    if 'skills' in new_data:
        skills_text = ' '.join(new_data['skills'])
        vector = await embeddings_service.embed(skills_text)
        await db.execute(
            UPDATE developer_profiles
            SET skill_vector = :vector
            WHERE user_id = :user_id
        )
```

**2. Conversation Context Management:**
```python
# services/ai/conversation_manager.py
async def get_conversation_context(
    user_id: UUID,
    max_messages: int = 10
) -> List[Message]:
    """
    Retrieve recent conversation with Redis cache
    """
    # Try Redis first (hot path)
    cached = await redis.get(f"session:{user_id}")
    if cached:
        return json.loads(cached)['recent_messages']

    # Fallback to database (cold path)
    messages = await db.execute(
        SELECT * FROM messages m
        JOIN conversations c ON m.conversation_id = c.id
        WHERE c.user_id = :user_id
        ORDER BY m.created_at DESC
        LIMIT :max_messages
    )

    # Cache for next request (1 hour TTL)
    await redis.setex(
        f"session:{user_id}",
        3600,
        json.dumps({"recent_messages": messages})
    )

    return messages
```

**3. Efficient Match Queries:**
```python
# services/matching/engine.py
async def get_top_matches_for_developer(
    developer_id: UUID,
    limit: int = 20
) -> List[Match]:
    """
    Get best opportunities with Redis cache
    """
    # Check if cached
    cached_matches = await redis.zrevrange(
        f"dev_matches:{developer_id}",
        0,
        limit - 1,
        withscores=True
    )

    if cached_matches:
        return cached_matches

    # Query from database with vector similarity
    dev = await db.get(DeveloperProfile, developer_id)

    matches = await db.execute("""
        SELECT o.*, m.score,
               o.required_skills_vector <=> :dev_vector AS similarity
        FROM opportunities o
        JOIN matches m ON m.opportunity_id = o.id
        WHERE m.developer_id = :dev_id
          AND m.score >= 70
          AND o.deadline > NOW()
        ORDER BY m.score DESC
        LIMIT :limit
    """, {"dev_id": developer_id, "dev_vector": dev.skill_vector, "limit": limit})

    # Cache for 6 hours
    await redis.zadd(
        f"dev_matches:{developer_id}",
        {m.opportunity_id: m.score for m in matches},
        ex=21600
    )

    return matches
```

## API Contracts

### REST API Endpoints

**Base URL:** `https://api.xrpl-guru.com/v1`

**Authentication:** Bearer token in `Authorization` header

#### Authentication Endpoints

```
POST /auth/email/request-code
Request Body: {"email": "dev@example.com"}
Response: {"message": "Verification code sent", "expires_in": 600}

POST /auth/email/verify
Request Body: {"email": "dev@example.com", "code": "123456"}
Response: {
  "access_token": "eyJ...",
  "token_type": "bearer",
  "expires_in": 86400,
  "user": {"id": "...", "email": "..."}
}

POST /auth/refresh
Request Body: {"refresh_token": "eyJ..."}
Response: {"access_token": "eyJ...", "expires_in": 86400}
```

#### Developer Profile Endpoints

```
GET /developers/me
Response: {
  "id": "uuid",
  "email": "dev@example.com",
  "profile": {
    "xrpl_experience_months": 6,
    "projects_count": 3,
    "skills": ["JavaScript", "React", "XRPL"],
    "interests": ["defi", "nft"],
    "location": "Remote",
    "timezone": "America/New_York"
  },
  "created_at": "2025-01-01T00:00:00Z"
}

PATCH /developers/me/profile
Request Body: {
  "skills": ["JavaScript", "React", "XRPL", "Node.js"],
  "interests": ["defi", "payments"]
}
Response: {"message": "Profile updated", "profile": {...}}

GET /developers/me/progress
Response: {
  "profile_completeness": 85,
  "learning_progress": {
    "completed_lessons": 12,
    "total_lessons": 50,
    "current_module": "xrpl_basics"
  },
  "activity_stats": {
    "total_conversations": 45,
    "questions_asked": 89,
    "code_examples_viewed": 34
  }
}
```

#### Opportunity Endpoints

```
GET /opportunities?type=grant&limit=20&offset=0
Response: {
  "opportunities": [
    {
      "id": "uuid",
      "type": "grant",
      "title": "XRPL $100K Grants Program",
      "description": "...",
      "deadline": "2025-03-15T23:59:59Z",
      "url": "https://...",
      "match_score": 87.5,
      "created_at": "2025-01-01T00:00:00Z"
    }
  ],
  "total": 45,
  "has_more": true
}

GET /opportunities/{id}
Response: {
  "id": "uuid",
  "type": "grant",
  "title": "...",
  "description": "...",
  "requirements": {...},
  "match_score": 87.5,
  "match_breakdown": {
    "skill_match": 28.5,
    "interest_match": 25.0,
    "readiness_match": 25.0,
    "timing_match": 15.0
  }
}

POST /opportunities/{id}/track
Response: {"message": "Opportunity added to pipeline", "status": "tracking"}

POST /opportunities/{id}/dismiss
Response: {"message": "Opportunity dismissed"}
```

#### Conversation Endpoints

```
GET /conversations?limit=50&offset=0
Response: {
  "conversations": [
    {
      "id": "uuid",
      "channel": {"platform": "slack", "name": "#general"},
      "last_message": "How do I create an XRPL wallet?",
      "updated_at": "2025-01-15T14:30:00Z"
    }
  ],
  "total": 120
}

GET /conversations/{id}/messages?limit=100
Response: {
  "messages": [
    {
      "id": "uuid",
      "role": "user",
      "content": "How do I create an XRPL wallet?",
      "created_at": "2025-01-15T14:30:00Z"
    },
    {
      "id": "uuid",
      "role": "assistant",
      "content": "Here's how to create an XRPL wallet...",
      "metadata": {"rag_used": true, "sources": [...]},
      "created_at": "2025-01-15T14:30:05Z"
    }
  ],
  "has_more": false
}
```

#### Webhook Endpoints (Chat Platforms)

```
POST /webhooks/slack/events
Headers: {"X-Slack-Signature": "..."}
Request Body: Slack Event API payload
Response: {"challenge": "..."} or 200 OK

POST /webhooks/discord
Headers: {"X-Signature-Ed25519": "...", "X-Signature-Timestamp": "..."}
Request Body: Discord Interaction payload
Response: Discord Interaction Response

POST /webhooks/whatsapp
Headers: {"X-Hub-Signature-256": "..."}
Request Body: WhatsApp Webhook payload
Response: 200 OK
```

## Security Architecture

### Authentication & Authorization

**Passwordless Email Authentication:**
```python
# core/security.py
import secrets
from datetime import datetime, timedelta

async def generate_verification_code(email: str) -> str:
    """Generate 6-digit code, store in Redis with 10-min TTL"""
    code = ''.join([str(secrets.randbelow(10)) for _ in range(6)])

    await redis.setex(
        f"auth:code:{email}",
        600,  # 10 minutes
        code
    )

    return code

async def verify_code(email: str, code: str) -> bool:
    """Verify code and rate limit attempts"""
    # Rate limiting (5 attempts per email per hour)
    attempts_key = f"auth:attempts:{email}"
    attempts = await redis.incr(attempts_key)
    if attempts == 1:
        await redis.expire(attempts_key, 3600)
    if attempts > 5:
        raise RateLimitExceeded("Too many attempts, try again in 1 hour")

    stored_code = await redis.get(f"auth:code:{email}")
    return secrets.compare_digest(code, stored_code or "")
```

**JWT Token Management:**
```python
from jose import jwt, JWTError
from datetime import datetime, timedelta

SECRET_KEY = settings.JWT_SECRET_KEY  # From Azure Key Vault
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 24 * 60  # 24 hours

def create_access_token(user_id: UUID, email: str) -> str:
    """Create JWT with user claims"""
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    claims = {
        "sub": str(user_id),
        "email": email,
        "exp": expire,
        "iat": datetime.utcnow(),
        "type": "access"
    }
    return jwt.encode(claims, SECRET_KEY, algorithm=ALGORITHM)

async def get_current_user(token: str = Depends(oauth2_scheme)) -> User:
    """Validate JWT and return user"""
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id = UUID(payload.get("sub"))
        if user_id is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception

    user = await db.get(User, user_id)
    if user is None or not user.is_active:
        raise credentials_exception
    return user
```

### Data Protection

**Encryption at Rest:**
- **Database:** Azure Database for PostgreSQL with Transparent Data Encryption (TDE)
- **Redis:** Azure Cache for Redis with encryption enabled
- **Secrets:** Azure Key Vault with Hardware Security Modules (HSM)
- **File Storage:** Azure Blob Storage with AES-256 encryption

**Encryption in Transit:**
- **All endpoints:** HTTPS/TLS 1.3 only (enforced via Azure Front Door)
- **XRPL connections:** HTTPS for JSON-RPC calls
- **Internal services:** mTLS between container apps (Azure-managed certificates)

**Sensitive Data Handling:**
```python
# core/security.py
from cryptography.fernet import Fernet

class SecretManager:
    """Encrypt/decrypt sensitive data using Azure Key Vault"""

    def __init__(self):
        self.key = self._get_encryption_key_from_keyvault()
        self.cipher = Fernet(self.key)

    async def encrypt(self, plaintext: str) -> str:
        """Encrypt OAuth tokens, API keys"""
        return self.cipher.encrypt(plaintext.encode()).decode()

    async def decrypt(self, ciphertext: str) -> str:
        """Decrypt when needed"""
        return self.cipher.decrypt(ciphertext.encode()).decode()

# Usage in channel storage
async def store_channel_token(channel_id: UUID, token: str):
    encrypted_token = await secret_manager.encrypt(token)
    await db.execute(
        UPDATE channels SET auth_token = :token WHERE id = :id,
        {"token": encrypted_token, "id": channel_id}
    )
```

### GDPR Compliance

**Data Subject Rights:**
```python
# api/routes/developers.py
@router.delete("/developers/me")
async def delete_account(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """
    Right to Erasure (GDPR Article 17)
    - Delete all personal data
    - Anonymize conversation history
    - Revoke all OAuth tokens
    """
    user_id = current_user.id

    # 1. Delete profile data
    await db.execute(DELETE FROM developer_profiles WHERE user_id = :id, {"id": user_id})

    # 2. Anonymize messages (keep for analytics, remove PII)
    await db.execute(
        UPDATE messages
        SET content = '[DELETED]',
            metadata = jsonb_set(metadata, '{anonymized}', 'true')
        WHERE conversation_id IN (
            SELECT id FROM conversations WHERE user_id = :id
        ),
        {"id": user_id}
    )

    # 3. Revoke OAuth tokens
    channels = await db.execute(SELECT * FROM channels WHERE user_id = :id)
    for channel in channels:
        await revoke_platform_token(channel.platform, channel.auth_token)
    await db.execute(DELETE FROM channels WHERE user_id = :id, {"id": user_id})

    # 4. Delete user record (cascades to conversations, matches)
    await db.execute(DELETE FROM users WHERE id = :id, {"id": user_id})

    logger.info("account_deleted", user_id=user_id, timestamp=datetime.utcnow())
    return {"message": "Account deleted successfully"}

@router.get("/developers/me/data-export")
async def export_data(
    current_user: User = Depends(get_current_user),
    background_tasks: BackgroundTasks
):
    """Right to Data Portability (GDPR Article 20)"""
    export_task_id = str(uuid4())
    background_tasks.add_task(
        generate_data_export,
        user_id=current_user.id,
        task_id=export_task_id
    )
    return {
        "message": "Export started",
        "task_id": export_task_id,
        "download_url": f"/developers/me/exports/{export_task_id}"
    }
```

**Data Retention Policy:**
- **Messages:** 90 days (automatic partition drop via cron)
- **Opportunities:** Until deadline + 30 days
- **Matches:** 180 days after notification
- **Logs:** 30 days in Application Insights

### Security Headers

```python
# main.py
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.trustedhost import TrustedHostMiddleware

app = FastAPI()

# CORS (restrict to frontend domain in production)
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,  # ["https://app.xrpl-guru.com"]
    allow_credentials=True,
    allow_methods=["GET", "POST", "PATCH", "DELETE"],
    allow_headers=["Authorization", "Content-Type"],
    max_age=3600
)

# Trusted Host (prevent host header injection)
app.add_middleware(
    TrustedHostMiddleware,
    allowed_hosts=["api.xrpl-guru.com", "*.xrpl-guru.com"]
)

# Security headers middleware
@app.middleware("http")
async def add_security_headers(request: Request, call_next):
    response = await call_next(request)
    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["X-Frame-Options"] = "DENY"
    response.headers["X-XSS-Protection"] = "1; mode=block"
    response.headers["Strict-Transport-Security"] = "max-age=31536000; includeSubDomains"
    response.headers["Content-Security-Policy"] = "default-src 'self'"
    return response
```

### Webhook Security

**Signature Verification:**
```python
# api/routes/webhooks.py
import hmac
import hashlib

async def verify_slack_signature(request: Request) -> bool:
    """Verify Slack webhook signature"""
    timestamp = request.headers.get("X-Slack-Request-Timestamp")
    signature = request.headers.get("X-Slack-Signature")

    # Prevent replay attacks (reject > 5 min old)
    if abs(time.time() - int(timestamp)) > 300:
        return False

    body = await request.body()
    sig_basestring = f"v0:{timestamp}:{body.decode()}"
    expected_signature = "v0=" + hmac.new(
        settings.SLACK_SIGNING_SECRET.encode(),
        sig_basestring.encode(),
        hashlib.sha256
    ).hexdigest()

    return hmac.compare_digest(expected_signature, signature)

@router.post("/webhooks/slack/events")
async def slack_webhook(request: Request):
    if not await verify_slack_signature(request):
        raise HTTPException(status_code=401, detail="Invalid signature")
    # Process event...
```

## Performance Considerations

### Caching Strategy

**Multi-Layer Caching:**
```
┌─────────────────────────────────────────────────────┐
│                   Client (Browser)                  │
│              Cache-Control: max-age=300              │
└───────────────────────┬─────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────┐
│              Azure Front Door (CDN)                  │
│         Static assets cached at edge (1 day)         │
└───────────────────────┬─────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────┐
│                 Redis Cache Layer                    │
│  - RAG responses (24h TTL)                          │
│  - Match results (6h TTL)                           │
│  - Session context (1h TTL, refresh on access)      │
└───────────────────────┬─────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────┐
│              PostgreSQL Database                     │
│         Source of truth, always consistent           │
└─────────────────────────────────────────────────────┘
```

**Cache Invalidation:**
```python
# When developer updates skills → invalidate match cache
async def update_developer_skills(user_id: UUID, new_skills: List[str]):
    # Update database
    await db.execute(
        UPDATE developer_profiles
        SET profile_data = jsonb_set(profile_data, '{skills}', :skills)
        WHERE user_id = :user_id
    )

    # Invalidate relevant caches
    await redis.delete(f"dev_matches:{user_id}")
    await redis.delete(f"session:{user_id}")

    # Trigger re-matching (async)
    rematch_developer.delay(user_id)
```

### Database Query Optimization

**Index Strategy:**
```sql
-- Covering index for common query (avoid table lookup)
CREATE INDEX idx_opportunities_list ON opportunities (type, deadline)
INCLUDE (id, data) WHERE deadline > NOW();

-- Partial index for active developers only
CREATE INDEX idx_active_skill_vector ON developer_profiles (skill_vector)
WHERE (profile_data->>'active')::boolean = true;

-- Composite index for match leaderboard
CREATE INDEX idx_match_leaderboard ON matches (opportunity_id, score DESC)
INCLUDE (developer_id, metadata, notified_at);
```

**Query Patterns:**
```python
# ❌ BAD: N+1 query problem
for match in matches:
    developer = await db.get(Developer, match.developer_id)  # N queries!
    opportunity = await db.get(Opportunity, match.opportunity_id)

# ✅ GOOD: Join and load eagerly
matches_with_details = await db.execute(
    SELECT m.*, d.profile_data, o.data
    FROM matches m
    JOIN developer_profiles d ON m.developer_id = d.user_id
    JOIN opportunities o ON m.opportunity_id = o.id
    WHERE m.score >= 70
    ORDER BY m.score DESC
    LIMIT 100
)
```

### Connection Pooling

```python
# core/db.py
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession

engine = create_async_engine(
    settings.DATABASE_URL,
    pool_size=20,  # Max concurrent connections
    max_overflow=10,  # Extra connections if pool exhausted
    pool_pre_ping=True,  # Verify connections before use
    pool_recycle=3600,  # Recycle connections every hour
    echo=False  # Disable query logging in production
)

# Redis connection pool
redis_pool = ConnectionPool.from_url(
    settings.REDIS_URL,
    max_connections=50,
    decode_responses=True
)
redis_client = Redis(connection_pool=redis_pool)
```

### Async I/O for External Calls

```python
# Parallel external API calls
async def enrich_opportunity_data(opp_id: UUID) -> Opportunity:
    """Fetch opportunity details + check XRPL status in parallel"""
    async with httpx.AsyncClient() as client:
        # Fire 3 requests concurrently
        responses = await asyncio.gather(
            client.get(f"https://devpost.com/api/hackathons/{opp_id}"),
            client.get(f"https://ethglobal.com/api/events/{opp_id}"),
            xrpl_service.check_project_status(opp_id),
            return_exceptions=True  # Don't fail if one request errors
        )

    # Merge results...
    return merged_opportunity
```

### Pagination & Streaming

```python
# Cursor-based pagination for large datasets
@router.get("/conversations/{id}/messages")
async def get_messages(
    id: UUID,
    cursor: Optional[datetime] = None,
    limit: int = Query(default=50, le=100)
):
    """Fetch messages with cursor pagination"""
    query = select(Message).where(Message.conversation_id == id)

    if cursor:
        query = query.where(Message.created_at < cursor)

    query = query.order_by(Message.created_at.desc()).limit(limit)

    messages = await db.execute(query)

    next_cursor = messages[-1].created_at if len(messages) == limit else None

    return {
        "messages": messages,
        "next_cursor": next_cursor.isoformat() if next_cursor else None
    }
```

## Deployment Architecture

### Azure Container Apps Topology

```
┌───────────────────────────────────────────────────────────────┐
│                      Azure Front Door                         │
│                  (CDN + WAF + Load Balancer)                  │
└────────────────────────────┬──────────────────────────────────┘
                             │ HTTPS/TLS 1.3
                ┌────────────┴────────────┐
                │                         │
    ┌───────────▼─────────┐   ┌──────────▼────────────┐
    │   Frontend SPA      │   │   Backend API         │
    │   (Static Files)    │   │   (Container App)     │
    │   React + Vite      │   │   Replicas: 2-10      │
    └─────────────────────┘   │   Scale: HTTP queue   │
                              └──────────┬────────────┘
                                         │
                ┌────────────────────────┼────────────────────────┐
                │                        │                        │
    ┌───────────▼─────────┐  ┌──────────▼────────┐  ┌───────────▼─────────┐
    │  Notification       │  │  Matching         │  │  Monitoring         │
    │  Workers            │  │  Workers          │  │  Workers            │
    │  Replicas: 2-5      │  │  Replicas: 3-10   │  │  Replicas: 2        │
    │  Scale: Queue depth │  │  Scale: CPU 70%   │  │  Scale: Cron only   │
    └─────────────────────┘  └───────────────────┘  └─────────────────────┘
                │                        │                        │
                └────────────┬───────────┴───────────────────────┘
                             │
            ┌────────────────┼────────────────┐
            │                │                │
    ┌───────▼────────┐  ┌───▼──────────┐  ┌─▼────────────────┐
    │   PostgreSQL   │  │    Redis     │  │  Azure Services   │
    │  (Flexible)    │  │   (Cache)    │  │  - OpenAI         │
    │  HA: 2 replicas│  │  HA: Premium │  │  - Key Vault      │
    └────────────────┘  └──────────────┘  │  - Blob Storage   │
                                          │  - App Insights   │
                                          └───────────────────┘
```

### Infrastructure as Code (Bicep)

**Main Deployment:**
```bicep
// infra/bicep/main.bicep
targetScope = 'resourceGroup'

param location string = 'eastus'
param environment string = 'production'

// Container Apps Environment
module containerAppsEnv 'container-apps-env.bicep' = {
  name: 'xrpl-guru-env'
  params: {
    location: location
    logAnalyticsWorkspaceId: monitoring.outputs.workspaceId
  }
}

// Backend API
module backendApp 'container-app.bicep' = {
  name: 'xrpl-guru-backend'
  params: {
    containerAppsEnvironmentId: containerAppsEnv.outputs.id
    imageName: 'ghcr.io/xrpl-guru/backend:${imageTag}'
    minReplicas: 2
    maxReplicas: 10
    cpu: '1.0'
    memory: '2Gi'
    environmentVariables: [
      { name: 'DATABASE_URL', secretRef: 'database-url' }
      { name: 'REDIS_URL', secretRef: 'redis-url' }
      { name: 'AZURE_OPENAI_KEY', secretRef: 'openai-key' }
    ]
  }
}

// Celery Workers (separate container apps)
module matchingWorkers 'container-app.bicep' = {
  name: 'xrpl-guru-matching-workers'
  params: {
    containerAppsEnvironmentId: containerAppsEnv.outputs.id
    imageName: 'ghcr.io/xrpl-guru/backend:${imageTag}'
    command: ['celery', '-A', 'app.tasks', 'worker', '-Q', 'matching']
    minReplicas: 3
    maxReplicas: 10
    scaleRules: [
      {
        name: 'cpu-scaling'
        custom: {
          type: 'cpu'
          metadata: { type: 'Utilization', value: '70' }
        }
      }
    ]
  }
}

// PostgreSQL
module database 'database.bicep' = {
  name: 'xrpl-guru-db'
  params: {
    serverName: 'xrpl-guru-db-${environment}'
    administratorLogin: 'xrplguruadmin'
    sku: { name: 'Standard_D4s_v3', tier: 'GeneralPurpose' }
    highAvailability: environment == 'production'
  }
}

// Redis
module cache 'redis.bicep' = {
  name: 'xrpl-guru-cache'
  params: {
    redisCacheName: 'xrpl-guru-cache-${environment}'
    sku: { name: 'Premium', family: 'P', capacity: 1 }
  }
}
```

### CI/CD Pipeline (GitHub Actions)

```yaml
# .github/workflows/deploy.yml
name: Deploy to Azure

on:
  push:
    branches: [main]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Build Docker image
        run: |
          docker build -t ghcr.io/xrpl-guru/backend:${{ github.sha }} ./backend
          docker push ghcr.io/xrpl-guru/backend:${{ github.sha }}

      - name: Run tests
        run: |
          docker run ghcr.io/xrpl-guru/backend:${{ github.sha }} pytest

      - name: Deploy to Azure
        uses: azure/CLI@v1
        with:
          inlineScript: |
            az deployment group create \
              --resource-group xrpl-guru-prod \
              --template-file infra/bicep/main.bicep \
              --parameters imageTag=${{ github.sha }}

      - name: Run database migrations
        run: |
          az containerapp exec \
            --name xrpl-guru-backend \
            --command "alembic upgrade head"
```

## Development Environment

### Prerequisites

- **Docker Desktop 4.25+** - Container runtime
- **Python 3.12+** - Backend development
- **Node.js 20+** - Frontend development
- **Git** - Version control

### Setup Commands

```bash
# 1. Clone repository
git clone https://github.com/xrpl-guru/xrpl-guru.git
cd xrpl-guru

# 2. Generate project from starter template (first time only)
pip install copier
copier copy https://github.com/fastapi/full-stack-fastapi-template . --trust

# Configure project:
# - project_name: "XRPL Guru"
# - stack_name: "xrpl-guru"
# - Generate secure keys when prompted

# 3. Add custom services to docker-compose.yml
cat >> docker-compose.override.yml <<EOF
services:
  redis:
    image: redis:7.2-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  worker-matching:
    build: ./backend
    command: celery -A app.tasks worker -Q matching -c 4
    depends_on:
      - db
      - redis
    environment:
      - DATABASE_URL=\${DATABASE_URL}
      - REDIS_URL=redis://redis:6379

volumes:
  redis_data:
EOF

# 4. Start all services
docker compose up -d

# 5. Run database migrations
docker compose exec backend alembic upgrade head

# 6. Create first superuser
docker compose exec backend python scripts/create_superuser.py

# 7. Access services
# - Frontend: http://localhost:5173
# - Backend API: http://localhost:8000
# - API Docs: http://localhost:8000/docs
# - Flower (Celery): http://localhost:5555
```

### Development Workflow

```bash
# Backend development (hot reload enabled)
cd backend
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Frontend development
cd frontend
npm install
npm run dev  # Vite dev server with HMR

# Run tests
cd backend && pytest  # Backend tests
cd frontend && npm run test  # Frontend tests
npm run test:e2e  # Playwright E2E tests

# Database operations
docker compose exec backend alembic revision --autogenerate -m "Add new table"
docker compose exec backend alembic upgrade head

# Celery monitoring
celery -A app.tasks flower  # Web UI at http://localhost:5555
```

## Architecture Decision Records (ADRs)

### ADR-001: Starter Template Selection

**Status:** Accepted
**Date:** 2025-11-05
**Context:** Need production-ready foundation for FastAPI + React application

**Decision:** Use Full Stack FastAPI Template (official)

**Rationale:**
- Official FastAPI project (maintained by Sebastián Ramírez)
- Complete stack: backend + frontend + Docker + testing
- Battle-tested: 25K+ GitHub stars, used in production by many companies
- Includes essential features: auth, migrations, async ORM, E2E tests
- Active maintenance and documentation

**Alternatives Considered:**
- Azure FastAPI Template: Too Azure-specific, less flexibility
- Cookiecutter FastAPI: Outdated dependencies, less comprehensive

**Consequences:**
- Fast initial development (don't reinvent auth, Docker setup)
- Opinionated structure (must adapt to template conventions)
- Dependency on template updates (mitigated by copying, not linking)

---

### ADR-002: Multi-Channel Architecture (Adapter Pattern)

**Status:** Accepted
**Date:** 2025-11-05
**Context:** Support Slack, Discord, WhatsApp with potential for future platforms

**Decision:** Implement Adapter Pattern with Unified Bot Service

**Rationale:**
- Clean separation: Each platform adapter implements `BaseChatAdapter` interface
- Easy to add new channels: Create new adapter, plug into Unified Bot
- Testable: Mock adapters for unit tests
- Redis pub/sub for cross-channel event synchronization

**Alternatives Considered:**
- Shared Library: Tight coupling, hard to maintain per-platform quirks
- Event-Driven Queue: Over-engineered for current scale, adds latency

**Consequences:**
- Code duplication in adapters (acceptable tradeoff for isolation)
- Need Redis for context sync (already required for caching)
- Clear boundaries make AI agent implementation straightforward

---

### ADR-003: AI Integration (AI Gateway Service)

**Status:** Accepted
**Date:** 2025-11-05
**Context:** Need to orchestrate Azure OpenAI + Ripple RAG with caching and fallback

**Decision:** Centralized AI Gateway Service with chain-of-responsibility

**Rationale:**
- Single point for all AI logic (easier debugging, monitoring)
- Chain: RAG (confidence check) → Cache → OpenAI → Cache store
- RAG-first approach leverages XRPL-specific knowledge
- Redis cache reduces costs (OpenAI API calls expensive)
- Fallback logic transparent to chat adapters

**Alternatives Considered:**
- Direct Integration: Scattered logic, harder to maintain
- Chain-of-Responsibility per adapter: Code duplication

**Consequences:**
- All AI requests funnel through gateway (single point of failure - mitigated by retry logic)
- Easier to add new AI models (swap gateway internals)
- Simplified monitoring (one service to track AI metrics)

---

### ADR-004: Background Jobs (Specialized Celery Workers)

**Status:** Accepted
**Date:** 2025-11-05
**Context:** Need to process: notifications (critical, low latency), matching (CPU-heavy), monitoring (periodic)

**Decision:** Separate worker pools by workload type

**Rationale:**
- Isolation: Heavy matching calculations don't block critical notifications
- Scalability: Scale matching workers independently (3-10 replicas vs. 2 for monitoring)
- Queue prioritization: Celery routes by queue name
- Cost optimization: Scale-to-zero matching workers when idle (Azure Container Apps)

**Alternatives Considered:**
- Single Worker Pool: Simple but blocking issues
- Hybrid (priority queues in single pool): Less isolation

**Consequences:**
- More complex deployment (4 worker types vs. 1)
- Better SLA for notifications (<30s delivery guaranteed)
- Higher operational cost (more containers - mitigated by scale-to-zero)

---

### ADR-005: Proactive Matching (Hybrid PostgreSQL + Redis)

**Status:** Accepted
**Date:** 2025-11-05
**Context:** Match 100 new opportunities × 10K developers = 1M calculations daily

**Decision:** Incremental matching (delta-only) + Redis cache for results

**Rationale:**
- Efficiency: Only match NEW opportunities (avoid recalculating existing matches)
- pgvector pre-filtering: Cosine similarity narrows to top 1K candidates (vs. 10K)
- Redis cache: High-scoring matches (≥70) cached for 6 hours
- Performance: <50ms per match calculation (target <6 hours for daily batch)

**Alternatives Considered:**
- Full re-matching daily: 1M calculations too slow
- In-memory only: Data loss on restart

**Consequences:**
- Complexity in cache invalidation (when developer updates skills)
- Need pgvector extension (PostgreSQL 17+ required)
- Excellent performance (can scale to 100K developers)

---

### ADR-006: XRPL Integration (Circuit Breaker Pattern)

**Status:** Accepted
**Date:** 2025-11-05
**Context:** Public XRPL nodes can be unreliable (downtime, rate limits)

**Decision:** Service layer with automatic failover between multiple nodes

**Rationale:**
- Reliability: Failover to backup nodes on timeout (>5s) or HTTP 5xx
- Circuit breaker: `tenacity` library retry with exponential backoff
- Node list: Primary (Ripple), fallback (XRPL Labs, others)
- Target: 99.9% uptime despite reliance on public nodes

**Alternatives Considered:**
- Direct xrpl-py: No failover, single point of failure
- WebSocket Subscriptions: Over-engineered for read-only use case

**Consequences:**
- More complex than direct client (acceptable for production reliability)
- Need to maintain node list (monitor node health)
- Transparent failover (callers don't need error handling)

---

### ADR-007: Azure Deployment (Container Apps)

**Status:** Accepted
**Date:** 2025-11-05
**Context:** Need serverless containers with auto-scaling and cost optimization

**Decision:** Azure Container Apps (not App Service or AKS)

**Rationale:**
- Serverless containers: Pay only for actual usage
- Scale-to-zero: Workers idle when no jobs (vs. always-on App Service)
- KEDA auto-scaling: CPU, HTTP queue, custom metrics
- Simpler than AKS (no Kubernetes cluster management)
- Azure-native: Integrates with Key Vault, App Insights, Front Door

**Alternatives Considered:**
- App Service: No scale-to-zero, more expensive at low scale
- AKS: Over-engineered, need Kubernetes expertise

**Consequences:**
- Cold start latency (2-5s for first request after scale-to-zero) - acceptable for workers
- Vendor lock-in to Azure (mitigated by Docker containers - can port to other clouds)
- Cost-effective for MVP (<$500/month projected for 1K users)

---

### ADR-008: Database Schema (Hybrid SQL + JSONB + pgvector)

**Status:** Accepted
**Date:** 2025-11-05
**Context:** Need flexible developer profiles (varying fields) + relational integrity + ML vectors

**Decision:** PostgreSQL with JSONB for flexible data + pgvector for ML embeddings

**Rationale:**
- Flexibility: JSONB allows evolving profile schema without migrations
- Integrity: Foreign keys, transactions (vs. NoSQL)
- ML support: pgvector for cosine similarity (skill matching)
- Indexing: GIN indexes on JSONB, IVFFlat indexes on vectors
- Single database: Avoid polyglot complexity

**Alternatives Considered:**
- Normalized SQL only: Too rigid for progressive profiling
- Polyglot (Postgres + MongoDB): Operational complexity

**Consequences:**
- Query complexity (JSONB operators like `->>` and `||`)
- Need PostgreSQL 17+ (pgvector extension)
- Best of both worlds (structure + flexibility)

---

### ADR-009: Cross-Cutting Concerns

**Status:** Accepted
**Date:** 2025-11-05
**Context:** Need consistency across all services for errors, logging, dates, emails

**Decisions:**

**API Response Format:** Direct Response (FastAPI default, REST-compliant)
- **Rationale:** Simple, standard, no custom envelope
- **Alternative:** Envelope pattern ({"success": true, "data": {}}) - adds complexity

**Error Handling:** Exception Hierarchy + FastAPI handlers
- **Rationale:** Pythonic, automatic HTTP status codes
- **Alternative:** Error codes + manual mapping - not idiomatic

**Logging:** Structured JSON (structlog) → Azure App Insights
- **Rationale:** Queryable logs, distributed tracing support
- **Alternative:** Plain text logs - not cloud-native

**Datetime:** UTC everywhere (convert in frontend)
- **Rationale:** Avoid timezone bugs in server logic
- **Alternative:** Store local times - error-prone

**Email:** Transactional Service (SendGrid)
- **Rationale:** Deliverability (SPF/DKIM), analytics, templates
- **Alternative:** SMTP (AWS SES) - less features, harder setup

**Consequences:**
- Consistency across services (easier for AI agents to implement)
- Cloud-native patterns (Azure integration)
- Slight learning curve (structlog vs. logging module)

---

## Summary

This architecture provides XRPL Guru with:

✅ **Production-ready foundation** (Full Stack FastAPI Template)
✅ **Multi-channel support** (Adapter Pattern for Slack, Discord, WhatsApp)
✅ **Intelligent AI orchestration** (AI Gateway with RAG-first strategy)
✅ **Scalable proactive matching** (pgvector + Redis + incremental algorithm)
✅ **Reliable XRPL integration** (Circuit breaker with failover)
✅ **Cost-effective Azure deployment** (Container Apps with scale-to-zero)
✅ **Flexible data model** (Hybrid SQL + JSONB + vectors)
✅ **Enterprise security** (Passwordless auth, GDPR compliance, encryption)
✅ **Performance optimization** (Multi-layer caching, async I/O, connection pooling)
✅ **Developer experience** (Docker Compose, hot reload, comprehensive testing)

**Next Steps:**
1. Run `/bmad:bmm:workflows:solutioning-gate-check` to validate architecture completeness
2. Proceed to Phase 4: `/bmad:bmm:workflows:sprint-planning` to break into implementation stories
3. Execute first story: Initialize project with Full Stack FastAPI Template

---

_Generated by BMAD Decision Architecture Workflow v1.0_
_Date: 2025-11-05_
_For: Etienne_
