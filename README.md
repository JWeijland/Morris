# WisdomMatch

> **Career wisdom, shared over coffee.**

WisdomMatch connects young professionals and students with experienced senior professionals (60+, retirees, executives) who want to share career knowledge, feel useful, and help the next generation — over a free first coffee at a partner café.

---

## The problem it solves

LinkedIn works for broadcasting, but not for intentional one-on-one career guidance. Sending a cold message to a stranger feels awkward and intrusive. WisdomMatch creates a dedicated context: **both sides know exactly why they are there**, making the interaction feel natural and valuable for everyone.

---

## Target users

| Role | Who | Why they're here |
|------|-----|-----------------|
| Young Professional | Students, early-career talent (18–35) | Career advice, introductions, industry insight |
| Senior Professional | 55+ executives, retirees, "boomers" | Purpose, contribution, reducing isolation, legacy |
| Company *(future)* | HR, L&D, employer branding teams | Sponsor coffees, talent pipeline, CSR reporting |

---

## Business model

- **Young professional**: ~€10/month (includes first coffee)
- **Senior professional**: ~€5/month (includes first coffee)
- Platform takes margin from the transaction; café partner subsidises the drink
- **Company tier** *(future)*: sponsored coffees, branded mentor profiles, impact dashboard

> Payment flows are **placeholders** in this MVP — no real transactions are processed.

---

## Features (MVP)

### Onboarding
- Role selection: Young Professional / Senior Professional / Company
- Step-by-step profile setup (role confirm → basic info → industry & goal → LinkedIn)
- LinkedIn import placeholder (OAuth integration stub)
- Progress bar + animated transitions

### Discovery
- Swipe-style card stack showing senior profiles
- Cards are **experience-first** — avatar is small, career highlights dominate
- Swipe right = "Interested", swipe left = "Pass"
- Drag gesture with visual overlays + bottom action buttons
- Match score (%) displayed per card

### Matching logic
Points-based matching algorithm (`MatchingService.swift`):

| Signal | Weight |
|--------|--------|
| Industry overlap | 35% |
| Topic / question overlap | 30% |
| Experience depth | 15% |
| Generational gap (age diff) | 10% |
| Senior track record | 10% |

### Match screen
- Full-screen "It's a career match!" celebration
- Warmly worded, not dating-app-like
- Direct CTAs: Start chat / Plan coffee

### Chat
- Simple async message list
- Voice note button (placeholder → AVFoundation)
- Video call button (placeholder → Whereby/Daily.co)
- Report user flow
- Link to schedule coffee meeting

### Schedule coffee meeting
- Date/time picker
- Select from partner café list (mock: 3 Amsterdam cafés)
- **"First coffee included"** banner
- Meeting request confirmation alert

### Profile
- Avatar, name, verification badge
- Points / people helped / rating stats
- Badges (Community Helper, Finance Mentor, Retired Executive, etc.)
- Career history timeline
- Industries and topics
- Motivation quote
- LinkedIn verification CTA
- Code of Conduct + report links

### Company page (placeholder)
- Explains corporate value proposition
- Request demo flow
- Partner logo placeholder

### Code of Conduct
- Full screen with 6 principles
- Agreement button (stored locally; persisted to backend in future)

---

## Tech stack

| Layer | Technology |
|-------|-----------|
| UI | SwiftUI (iOS 26+) |
| Architecture | MVVM |
| State | `ObservableObject` + `@Published` |
| Data | In-memory mock data (`MockDataService`) |
| Matching | Local scoring algorithm (`MatchingService`) |
| Backend *(future)* | Firebase / Supabase |
| Auth *(future)* | Sign in with Apple + LinkedIn OAuth |
| Payments *(future)* | Stripe / RevenueCat |
| Push *(future)* | APNs via FCM |
| Calendar *(future)* | EventKit / Google Calendar API |
| Voice/Video *(future)* | AVFoundation + Whereby SDK |

---

## Project structure

```
Morris/
└── Morris/
    ├── Theme/
    │   └── WMTheme.swift          # Colors, fonts, spacing, extensions
    ├── Models/
    │   ├── User.swift             # User + UserRole + Industry
    │   ├── Profiles.swift         # YoungProfessionalProfile, SeniorProfessionalProfile, CompanyProfile, PastRole
    │   ├── CareerQuestion.swift   # CareerQuestion
    │   ├── Match.swift            # Match + MatchStatus
    │   ├── ChatMessage.swift      # ChatMessage
    │   ├── CoffeeMeeting.swift    # CoffeeMeeting + MeetingStatus
    │   ├── Cafe.swift             # Cafe
    │   └── Badge.swift            # Badge + BadgeType
    ├── Services/
    │   ├── MockDataService.swift  # All mock data (5 seniors, 3 young, 3 cafés, badges, matches, messages)
    │   └── MatchingService.swift  # Scoring algorithm
    ├── ViewModels/
    │   ├── AppViewModel.swift     # App state machine + session
    │   ├── OnboardingViewModel.swift
    │   └── DiscoveryViewModel.swift
    ├── Components/
    │   ├── WMButton.swift         # WMPrimaryButton, WMSecondaryButton, WMCircleButton, WMTag, IndustryPill
    │   ├── BadgeView.swift        # BadgeView, BadgesRow, FlowLayout
    │   └── ProfileCardView.swift  # Full swipe card with overlays
    └── Views/
        ├── WelcomeView.swift
        ├── OnboardingView.swift   # Also contains WMTextField, WMTextArea
        ├── MainTabView.swift
        ├── SwipeDiscoveryView.swift
        ├── YoungQuestionView.swift
        ├── SeniorProfileSetupView.swift
        ├── MatchView.swift
        ├── MatchesView.swift
        ├── ChatView.swift         # Also contains MessageBubble
        ├── ScheduleCoffeeView.swift
        ├── ProfileView.swift
        ├── CompanyView.swift
        └── CodeOfConductView.swift
```

---

## How to run

1. Open `Morris/Morris.xcodeproj` in Xcode
2. Select a simulator (iPhone 15 or later recommended)
3. Press ⌘R to build and run
4. No backend, API keys, or environment variables required — all data is mocked

---

## Mock data included

**5 senior professionals:**
- Hans van der Berg, 64 — Retired CFO (ING Group, ABN AMRO, KPMG) · Finance
- Margaret Okafor, 61 — Retired Senior Partner (McKinsey, BCG, Goldman) · Consulting
- Peter Janssen, 67 — Retired CTO (Philips, ASML, Ericsson) · Technology
- Eleanor de Vries, 58 — Brand Advisor, ex-CMO (Unilever, Heineken, L'Oréal) · Marketing
- Robert van Amstel, 70 — Retired Founding Partner (Van Amstel & Partners, Allen & Overy) · Law

**3 young professionals:**
- Sofia Rodriguez, 23 — MSc Finance student, UvA
- Tim Bakker, 25 — Junior Data Analyst
- Priya Sharma, 22 — BSc Economics student, TU Delft

**3 partner cafés (Amsterdam):**
- Café de Jaren — Centrum
- Blackbird Coffee — Oud-Zuid
- Headfirst Coffee — Noord

**Pre-seeded matches + chat messages** between Sofia ↔ Hans and Sofia ↔ Margaret for immediate demo.

---

## Future roadmap

### Short term (v1.1)
- [ ] Firebase Auth (Sign in with Apple + LinkedIn OAuth)
- [ ] Firestore or Supabase backend for profiles, matches, messages
- [ ] Push notifications for new matches and messages
- [ ] Real-time chat via WebSocket / Firestore listeners

### Medium term (v1.2)
- [ ] Stripe / RevenueCat payment integration
- [ ] Voice notes (AVFoundation)
- [ ] Video calls (Whereby / Daily.co SDK)
- [ ] Calendar integration (EventKit)
- [ ] Admin moderation dashboard

### Long term (v2.0)
- [ ] Company tier: sponsored coffees, employer branding, impact dashboard
- [ ] Group career coffees (3–4 people)
- [ ] Mentor rating and review system
- [ ] Netherlands expansion → Belgium, Germany
- [ ] Android app (SwiftUI → React Native or Kotlin Multiplatform)

---

## Design principles

- **Not a dating app.** Experience and wisdom lead, photos follow.
- Senior users feel **respected, useful, and valued** — not like retired database entries.
- Young users feel **comfortable reaching out** — the app exists for this, so there's no social awkwardness.
- **Subtle gamification** — badges and helped counters, not streaks or leaderboards.
- **Premium, warm, trustworthy** — LinkedIn professionalism meets coffee meetup warmth.

---

*WisdomMatch MVP — built April 2026*
