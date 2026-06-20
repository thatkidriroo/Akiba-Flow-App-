import 'models/currency.dart';
import 'models/transaction.dart';
import 'models/opportunity.dart';
import 'models/profile.dart';

const kCurrencies = [
  Currency(code: 'TZS', symbol: 'TZS', name: 'Tanzanian Shilling',  flag: '🇹🇿', toTZS: 1),
  Currency(code: 'USD', symbol: '\$',  name: 'US Dollar',            flag: '🇺🇸', toTZS: 2500),
  Currency(code: 'EUR', symbol: '€',   name: 'Euro',                 flag: '🇪🇺', toTZS: 2700),
  Currency(code: 'GBP', symbol: '£',   name: 'British Pound',        flag: '🇬🇧', toTZS: 3150),
  Currency(code: 'KES', symbol: 'KSh', name: 'Kenyan Shilling',      flag: '🇰🇪', toTZS: 19),
  Currency(code: 'NGN', symbol: '₦',   name: 'Nigerian Naira',       flag: '🇳🇬', toTZS: 1.8),
  Currency(code: 'GHS', symbol: 'GH₵', name: 'Ghanaian Cedi',        flag: '🇬🇭', toTZS: 195),
  Currency(code: 'ZAR', symbol: 'R',   name: 'South African Rand',   flag: '🇿🇦', toTZS: 135),
  Currency(code: 'INR', symbol: '₹',   name: 'Indian Rupee',         flag: '🇮🇳', toTZS: 30),
  Currency(code: 'JPY', symbol: '¥',   name: 'Japanese Yen',         flag: '🇯🇵', toTZS: 17),
  Currency(code: 'CNY', symbol: '¥',   name: 'Chinese Yuan',         flag: '🇨🇳', toTZS: 345),
  Currency(code: 'BRL', symbol: 'R\$', name: 'Brazilian Real',       flag: '🇧🇷', toTZS: 450),
  Currency(code: 'MXN', symbol: 'MX\$',name: 'Mexican Peso',         flag: '🇲🇽', toTZS: 125),
  Currency(code: 'AUD', symbol: 'A\$', name: 'Australian Dollar',    flag: '🇦🇺', toTZS: 1650),
  Currency(code: 'CAD', symbol: 'C\$', name: 'Canadian Dollar',      flag: '🇨🇦', toTZS: 1820),
  Currency(code: 'CHF', symbol: 'Fr',  name: 'Swiss Franc',          flag: '🇨🇭', toTZS: 2800),
  Currency(code: 'SEK', symbol: 'kr',  name: 'Swedish Krona',        flag: '🇸🇪', toTZS: 230),
  Currency(code: 'UGX', symbol: 'USh', name: 'Ugandan Shilling',     flag: '🇺🇬', toTZS: 0.68),
  Currency(code: 'ETB', symbol: 'Br',  name: 'Ethiopian Birr',       flag: '🇪🇹', toTZS: 45),
  Currency(code: 'ZMW', symbol: 'ZK',  name: 'Zambian Kwacha',       flag: '🇿🇲', toTZS: 95),
  Currency(code: 'MWK', symbol: 'MK',  name: 'Malawian Kwacha',      flag: '🇲🇼', toTZS: 1.4),
  Currency(code: 'RWF', symbol: 'FRw', name: 'Rwandan Franc',        flag: '🇷🇼', toTZS: 1.9),
  Currency(code: 'XOF', symbol: 'CFA', name: 'West African CFA',     flag: '🌍',  toTZS: 4.1),
];

const kTierConfig = {
  'Bronze':   {'color': 0xFFCD7F32, 'next': 'Silver',   'nextScore': 600},
  'Silver':   {'color': 0xFF9E9E9E, 'next': 'Gold',     'nextScore': 750},
  'Gold':     {'color': 0xFFFFC107, 'next': 'Platinum', 'nextScore': 850},
  'Platinum': {'color': 0xFF7F77DD, 'next': null,       'nextScore': null},
};

const kInitialTransactions = [
  // Week 1: Start of month
  Transaction(id: 1, type: 'income',  label: 'Sokoni market sales (mornings)', amount: 142000, date: '2026-06-01', category: 'trade'),
  Transaction(id: 2, type: 'expense', label: 'Stock: vegetables & fruits',     amount: 68000,  date: '2026-06-01', category: 'business'),
  Transaction(id: 3, type: 'expense', label: 'Dala dala fare (weekly)',        amount: 15000,  date: '2026-06-01', category: 'transport'),
  Transaction(id: 4, type: 'income',  label: 'M-Pesa received from client',    amount: 35000,  date: '2026-06-02', category: 'transfer'),
  Transaction(id: 5, type: 'expense', label: 'Kiosk rent (Sokoni)',            amount: 80000,  date: '2026-06-02', category: 'housing'),
  Transaction(id: 6, type: 'income',  label: 'Weekend market sales',           amount: 189000, date: '2026-06-03', category: 'trade'),

  // Week 2
  Transaction(id: 7, type: 'expense', label: 'Stock: grains & cooking oil',   amount: 95000,  date: '2026-06-05', category: 'business'),
  Transaction(id: 8, type: 'income',  label: 'Chama savings payout',          amount: 120000, date: '2026-06-06', category: 'savings'),
  Transaction(id: 9, type: 'expense', label: 'School fees (Term 3)',          amount: 45000,  date: '2026-06-07', category: 'education'),
  Transaction(id: 10, type: 'income', label: 'Mid-week market sales',         amount: 96000,  date: '2026-06-08', category: 'trade'),
  Transaction(id: 11, type: 'expense', label: 'Electricity token',            amount: 18000,  date: '2026-06-08', category: 'utilities'),
  Transaction(id: 12, type: 'expense', label: 'Phone airtime & data',         amount: 12000,  date: '2026-06-09', category: 'utilities'),

  // Week 3
  Transaction(id: 13, type: 'income', label: 'Catering order (event)',        amount: 210000, date: '2026-06-12', category: 'gig'),
  Transaction(id: 14, type: 'expense', label: 'Catering supplies',            amount: 85000,  date: '2026-06-11', category: 'business'),
  Transaction(id: 15, type: 'income', label: 'M-Pesa merchant payments',      amount: 52000,  date: '2026-06-13', category: 'transfer'),
  Transaction(id: 16, type: 'expense', label: 'Chama contribution',           amount: 20000,  date: '2026-06-14', category: 'savings'),
  Transaction(id: 17, type: 'income', label: 'Saturday market sales',         amount: 175000, date: '2026-06-15', category: 'trade'),

  // Week 4
  Transaction(id: 18, type: 'expense', label: 'Stock: tomatoes, onions, spices', amount: 72000, date: '2026-06-17', category: 'business'),
  Transaction(id: 19, type: 'expense', label: 'Water bill',                   amount: 8500,   date: '2026-06-18', category: 'utilities'),
  Transaction(id: 20, type: 'income', label: 'Wholesale delivery payment',   amount: 310000, date: '2026-06-19', category: 'trade'),
  Transaction(id: 21, type: 'expense', label: 'Transport: stock pickup',      amount: 25000,  date: '2026-06-19', category: 'transport'),
  Transaction(id: 22, type: 'income', label: 'Chama loan repayment',          amount: 50000,  date: '2026-06-20', category: 'savings'),
  Transaction(id: 23, type: 'expense', label: 'Medical clinic visit',         amount: 22000,  date: '2026-06-21', category: 'health'),
  Transaction(id: 24, type: 'income', label: 'Last week of month sales',      amount: 248000, date: '2026-06-22', category: 'trade'),

  // Previous month — individual entries (May)
  Transaction(id: 25, type: 'income',  label: 'Sokoni market sales',          amount: 165000, date: '2026-05-02', category: 'trade'),
  Transaction(id: 26, type: 'expense', label: 'Stock: fresh produce',         amount: 72000,  date: '2026-05-02', category: 'business'),
  Transaction(id: 27, type: 'income',  label: 'Weekend market sales',         amount: 198000, date: '2026-05-04', category: 'trade'),
  Transaction(id: 28, type: 'expense', label: 'Kiosk rent (Sokoni)',          amount: 80000,  date: '2026-05-04', category: 'housing'),
  Transaction(id: 29, type: 'income',  label: 'M-Pesa received from client',  amount: 42000,  date: '2026-05-09', category: 'transfer'),
  Transaction(id: 30, type: 'expense', label: 'Stock: dry goods',             amount: 125000, date: '2026-05-10', category: 'business'),
  Transaction(id: 31, type: 'income',  label: 'Chama savings payout',         amount: 120000, date: '2026-05-11', category: 'savings'),
  Transaction(id: 32, type: 'expense', label: 'Dala dala fares',              amount: 35000,  date: '2026-05-12', category: 'transport'),
  Transaction(id: 33, type: 'expense', label: 'School fees (Term 3)',         amount: 45000,  date: '2026-05-16', category: 'education'),
  Transaction(id: 34, type: 'income',  label: 'Wholesale delivery payment',   amount: 280000, date: '2026-05-17', category: 'trade'),
  Transaction(id: 35, type: 'expense', label: 'Stock: cooking oil & spices',  amount: 78000,  date: '2026-05-18', category: 'business'),
  Transaction(id: 36, type: 'income',  label: 'Catering order (event)',       amount: 185000, date: '2026-05-19', category: 'gig'),
  Transaction(id: 37, type: 'expense', label: 'Chama contribution',           amount: 20000,  date: '2026-05-20', category: 'savings'),
  Transaction(id: 38, type: 'expense', label: 'Electricity & water',          amount: 28000,  date: '2026-05-23', category: 'utilities'),
  Transaction(id: 39, type: 'income',  label: 'Saturday market sales',        amount: 155000, date: '2026-05-24', category: 'trade'),
  Transaction(id: 40, type: 'expense', label: 'Medical clinic visit',         amount: 22000,  date: '2026-05-26', category: 'health'),
  Transaction(id: 41, type: 'income',  label: 'M-Pesa merchant payments',     amount: 68000,  date: '2026-05-27', category: 'transfer'),
  Transaction(id: 42, type: 'expense', label: 'Transport: stock pickup',      amount: 22000,  date: '2026-05-28', category: 'transport'),
  Transaction(id: 43, type: 'income',  label: 'Last week market sales',       amount: 212000, date: '2026-05-29', category: 'trade'),
  Transaction(id: 44, type: 'expense', label: 'Airtime & data',               amount: 12000,  date: '2026-05-30', category: 'utilities'),
];

const kTanzaniaRegions = [
  'Arusha', 'Dar es Salaam', 'Dodoma', 'Geita', 'Iringa', 'Kagera', 'Katavi',
  'Kigoma', 'Kilimanjaro', 'Lindi', 'Manyara', 'Mara', 'Mbeya', 'Morogoro',
  'Mtwara', 'Mwanza', 'Njombe', 'Pwani', 'Rukwa', 'Ruvuma', 'Simiyu',
  'Shinyanga', 'Singida', 'Songwe', 'Tabora', 'Tanga', 'Zanzibar',
];

const kInitialProfile = Profile(
  anonymousId: null,
  name: 'Amara Osei',
  phone: '+255 712 345 678',
  country: 'Tanzania',
  city: 'Arusha',
  occupation: 'Market Vendor',
  joinDate: 'Jan 2024',
  score: 672,
  tier: 'Silver',
  behaviors: BehaviorScores(
    consistencyScore: 84,
    savingsRatio: 32,
    repaymentHistory: 96,
    incomeStability: 71,
    communityTrust: 89,
    digitalFootprint: 65,
  ),
  chamaGroups: [
    ChamaGroup(name: "Biashara Women's Group", members: 12, contribution: 10000, cycle: 'Monthly', standing: 'Good'),
    ChamaGroup(name: 'Sokoni Traders Union',   members: 28, contribution: 5000,  cycle: 'Weekly',  standing: 'Excellent'),
  ],
  monthlyData: [85, 92, 78, 110, 95, 128, 105, 118, 88, 140, 122, 135],
  monthlyIncome: 240000,
);

const kOppCategories = ['All', 'Loan', 'Grant', 'Savings', 'Insurance', 'Investment', 'Gig'];

const kGlobalOpportunities = [
  Opportunity(type: 'Community Microloan',           category: 'Loan',       description: '0% interest loans crowd-funded by a global community. Available in 90+ countries including Kenya, Philippines, Colombia, Cambodia, and the US. No collateral required.',                                        rateInfo: 'From \$25 · 0% interest', provider: 'Kiva',                       link: 'https://www.kiva.org/borrow',                   minScore: 500, baseMatch: 96),
  Opportunity(type: 'Instant Mobile Loan',           category: 'Loan',       description: 'Smartphone-based loans with flexible repayment. No collateral or bank account required. Serving Kenya, Tanzania, Nigeria, Philippines, Mexico, and India.',                                                   rateInfo: 'Up to \$500 instantly',    provider: 'Tala',                       link: 'https://tala.co/get-started',                   minScore: 480, baseMatch: 89),
  Opportunity(type: 'Digital Growth Loan',           category: 'Loan',       description: 'Fast credit decisions for entrepreneurs. Download the app and apply in minutes. Active in Africa, Asia, and Latin America.',                                                                                  rateInfo: 'Up to \$1,000',            provider: 'Branch',                     link: 'https://branch.co',                             minScore: 500, baseMatch: 85),
  Opportunity(type: 'MSME Microfinance Loan',        category: 'Loan',       description: 'In-person and digital microfinance for small business owners. 20+ countries across Africa, Eastern Europe, Asia, and Latin America.',                                                                        rateInfo: 'Flexible amounts',        provider: 'FINCA International',        link: 'https://finca.org',                             minScore: 560, baseMatch: 80),
  Opportunity(type: 'Global Microfinance Loan',      category: 'Loan',       description: 'Microloans and savings for small business owners in 30+ developing nations. Strong presence across Africa, Asia, Latin America, and Eastern Europe.',                                                        rateInfo: 'Flexible amounts',        provider: 'Opportunity International',  link: 'https://opportunity.org',                       minScore: 520, baseMatch: 82),
  Opportunity(type: 'Small Business Microloan',      category: 'Loan',       description: 'Responsible small business loans for underserved entrepreneurs. Serving the US and 30+ countries through a global network of microfinance partners.',                                                        rateInfo: 'From \$500',               provider: 'Accion Opportunity Fund',    link: 'https://accion.org',                            minScore: 540, baseMatch: 78),
  Opportunity(type: "Women's Entrepreneur Grant",   category: 'Grant',      description: 'Annual global grant for women-led businesses. Up to \$100,000 in funding plus world-class mentorship and visibility. Open to all nationalities.',                                                             amount: 100000,                      provider: "Cartier Women's Initiative", link: 'https://www.cartierwomensinitiative.com',        minScore: 630, baseMatch: 74),
  Opportunity(type: 'Social Entrepreneur Fellowship', category: 'Grant',    description: 'Seed funding for early-stage social entrepreneurs creating systemic change. Open globally — applications reviewed annually.',                                                                                 amount: 90000,                       provider: 'Echoing Green',              link: 'https://echoinggreen.org/fellowship',            minScore: 650, baseMatch: 70),
  Opportunity(type: 'Multi-Currency Account',        category: 'Savings',   description: 'Hold, send, and save in 50+ currencies with real exchange rates and no hidden fees. Available in 200+ countries worldwide.',                                                                                  rateInfo: 'Up to 4.5% p.a.',         provider: 'Wise',                       link: 'https://wise.com/open-account',                 minScore: 380, baseMatch: 95),
  Opportunity(type: 'Digital Banking & Savings',     category: 'Savings',   description: 'High-yield savings vaults, global spending card, and investment features. Serving 35+ countries across Europe, Americas, and Asia-Pacific.',                                                                  rateInfo: 'Up to 5% p.a.',           provider: 'Revolut',                    link: 'https://revolut.com',                           minScore: 380, baseMatch: 81),
  Opportunity(type: 'Mobile Money & Savings',        category: 'Savings',   description: "East Africa's largest mobile money platform. Send money, pay bills, save, and access loans — all from your phone. Active in Kenya, Tanzania, Ghana, Mozambique, and beyond.",                               rateInfo: 'Free to join',            provider: 'M-Pesa (Safaricom)',         link: 'https://www.safaricom.co.ke/personal/m-pesa',   minScore: 300, baseMatch: 93),
  Opportunity(type: 'Mobile Microinsurance',         category: 'Insurance', description: 'Affordable health and life cover via mobile. No paperwork, instant payouts. 30+ markets across Africa, Asia, and Latin America.',                                                                            rateInfo: 'From \$1 / month',         provider: 'BIMA',                       link: 'https://bima.co',                               minScore: 420, baseMatch: 84),
  Opportunity(type: 'Cross-Border Money & Investing', category: 'Investment', description: 'Send money across 30+ African countries instantly, and invest in US stocks, ETFs, and crypto from your mobile. Zero transfer fees on many corridors.',                                                    rateInfo: 'From \$1',                 provider: 'Chipper Cash',               link: 'https://chippercash.com',                       minScore: 380, baseMatch: 86),
  Opportunity(type: 'Savings & Investment App',      category: 'Investment', description: 'Access mutual funds, treasury bills, and dollar investments from as little as \$1. Built for Africa, expanding globally. Automated savings plans available.',                                                rateInfo: 'From \$1 / month',         provider: 'Cowrywise',                  link: 'https://cowrywise.com',                         minScore: 400, baseMatch: 83),
  Opportunity(type: 'Stock & ETF Investing',         category: 'Investment', description: 'Invest in US-listed stocks, ETFs, and Nigerian equities directly from Africa. Fractional shares available from \$10. Available in Nigeria and expanding continent-wide.',                                    rateInfo: 'From \$10',                provider: 'Bamboo',                     link: 'https://investbamboo.com',                      minScore: 550, baseMatch: 75),
  Opportunity(type: 'Micro-Investing Platform',      category: 'Investment', description: 'Automatically invest your spare change from everyday purchases into diversified portfolios. Available in the US, Australia, and Southeast Asia. No minimum balance.',                                       rateInfo: 'From \$0 to start',        provider: 'Acorns',                     link: 'https://acorns.com',                            minScore: 450, baseMatch: 79),
  Opportunity(type: 'Global Freelance Platform',     category: 'Gig',       description: 'Find remote work in 180+ countries across tech, design, writing, marketing, and data. Build a client base and earn in your local currency or USD.',                                                          rateInfo: 'Free to join',            provider: 'Upwork',                     link: 'https://upwork.com',                            minScore: 350, baseMatch: 92),
  Opportunity(type: 'Creative Services Marketplace', category: 'Gig',       description: 'Sell your skills worldwide across 700+ service categories: design, translation, programming, video editing, and more. 4 million+ active buyers globally.',                                                   rateInfo: 'Free to join',            provider: 'Fiverr',                     link: 'https://fiverr.com',                            minScore: 350, baseMatch: 89),
  Opportunity(type: 'Global Freelance Jobs',         category: 'Gig',       description: 'Win projects from clients in 247 countries. Thousands of jobs posted daily in technology, engineering, business, writing, creative, and skilled trades.',                                                    rateInfo: 'Free to join',            provider: 'Freelancer',                 link: 'https://www.freelancer.com',                    minScore: 350, baseMatch: 87),
];
