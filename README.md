# Akiba Flow

**A financial advisory app that assesses your financial health and connects you to personalized financial opportunities.**

Akiba Flow serves underserved entrepreneurs and individuals across **all 27 regions of Tanzania** and beyond. Instead of a traditional credit check, the app uses a proprietary financial scoring algorithm to evaluate your financial behaviors and match you with financial products you actually qualify for.

## How It Works

### 1. Your Financial Score
The app calculates a financial score (300-850) based on six behavioral dimensions:
- **Consistency** — How regularly you save and transact
- **Savings Ratio** — Portion of income saved over time
- **Repayment History** — Track record of meeting financial commitments
- **Income Stability** — Predictability and diversity of income sources
- **Community Trust** — Standing within savings groups (Chamas) and community networks
- **Digital Footprint** — Engagement with mobile money and digital financial services

As your score improves, you progress through tiers — **Bronze → Silver → Gold → Platinum** — unlocking more financial opportunities at each level.

### 2. Personalized Opportunity Matching
The app surfaces 19+ global financial opportunities from providers including **Kiva, Tala, Branch, Wise, M-Pesa, Upwork, Fiverr, Chipper Cash, and more** across categories:

| Category | Examples |
|---|---|
| **Loans** | Community microloans, instant mobile loans, digital growth loans |
| **Grants** | Women's entrepreneur grants, social entrepreneur fellowships |
| **Savings** | Multi-currency accounts, high-yield digital savings, mobile money |
| **Insurance** | Affordable mobile microinsurance |
| **Investment** | Cross-border investing, stock/ETF platforms, micro-investing |
| **Gig Economy** | Global freelance and creative services marketplaces |

Each opportunity shows your match percentage based on your financial score, so you only see products you're likely to qualify for.

### 3. Income & Expense Tracking
Log transactions in any of **23 supported currencies** with automatic conversion to Tanzanian Shillings (TZS). Track your net balance, view 12-month income trends, and categorize your spending.

### 4. Chama (Savings Group) Tracking
Monitor your informal savings groups — a cornerstone of community finance across Tanzania. Track member counts, contribution cycles, and group standing.

### 5. Available Everywhere in Tanzania
The app supports all **27 regions of Tanzania** for user location, from Arusha to Zanzibar, ensuring relevance whether you're in Dar es Salaam or a rural village.

## Global Reach
While built for Tanzania, the app supports **23 currencies** from around the world (USD, EUR, GBP, KES, NGN, ZAR, and more), making it usable for the Tanzanian diaspora and international users.

## Tech Stack
- **Framework**: Flutter (Android)
- **Charts**: fl_chart (income trends), CustomPainter (score gauge)
- **State Management**: Provider (ChangeNotifier)

## Building from Source

```bash
flutter pub get
flutter build apk --release
```

The release APK will be at `build/app/outputs/flutter-apk/app-release.apk`.
