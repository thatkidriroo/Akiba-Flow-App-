import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../theme/app_theme.dart';
import '../../data/seed_data.dart';
import '../../data/models/opportunity.dart';
import '../widgets/score_gauge.dart';
import '../widgets/tx_form.dart';
import '../widgets/month_calendar.dart';
import '../widgets/weekly_spending_chart.dart';
import 'settings_screen.dart';
import 'score_detail_sheet.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, prov, _) {
        final t = prov.themeTokens;
        final sc = scoreColor(prov.profile.score);
        final tier = kTierConfig[prov.profile.tier]!;

        return Scaffold(
          backgroundColor: t.bg,
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _buildTabContent(prov, t, sc, tier, key: ValueKey(prov.activeTab)),
          ),
          bottomNavigationBar: _buildBottomNav(prov, t),
        );
      },
    );
  }

  Widget _buildBottomNav(DashboardProvider prov, ThemeTokens t) {
    final items = [
      _NavItem(Icons.home_rounded, 'Home', 0),
      _NavItem(Icons.receipt_long_rounded, 'Transactions', 1),
      _NavItem(Icons.explore_rounded, 'Opportunities', 2),
      _NavItem(Icons.settings_rounded, 'Settings', 3),
    ];

    return Container(
      decoration: BoxDecoration(
        color: t.card,
        border: Border(top: BorderSide(color: t.border, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            children: items.map((item) => Expanded(
              child: GestureDetector(
                onTap: () {
                  if (item.index == 3) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider.value(
                          value: prov,
                          child: const SettingsScreen(),
                        ),
                      ),
                    );
                  } else {
                    prov.setActiveTab(item.index);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size: 26,
                        color: prov.activeTab == item.index
                            ? AppColors.primary
                            : t.muted,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: prov.activeTab == item.index
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: prov.activeTab == item.index
                              ? AppColors.primary
                              : t.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(DashboardProvider prov, ThemeTokens t, Map<String, dynamic> sc, Map tier, {required Key key}) {
    switch (prov.activeTab) {
      case 0: return _buildHome(prov, t, sc, tier, key: key);
      case 1: return _buildTransactions(prov, t, key: key);
      case 2: return _buildOpportunities(prov, t, key: key);
      default: return _buildHome(prov, t, sc, tier, key: key);
    }
  }

  Widget _buildHome(DashboardProvider prov, ThemeTokens t, Map<String, dynamic> sc, Map tier, {required Key key}) {
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          _buildHeader(prov, t),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const ScoreDetailSheet(),
                  ),
                  child: _scoreCard(prov, t, sc, tier),
                ),
                const SizedBox(height: 12),
                _miniCard(t,
                  child: const WeeklySpendingChart(),
                  title: 'Weekly Spending',
                ),
                const SizedBox(height: 12),
                _miniCard(t,
                  child: Column(
                    children: [
                      _behaviorItem(t, 'Consistency', prov.profile.behaviors.consistencyScore, AppColors.primary),
                      _behaviorItem(t, 'Savings Ratio', prov.profile.behaviors.savingsRatio, AppColors.blue),
                      _behaviorItem(t, 'Repayment', prov.profile.behaviors.repaymentHistory, AppColors.green),
                      _behaviorItem(t, 'Income Stability', prov.profile.behaviors.incomeStability, AppColors.accent),
                      _behaviorItem(t, 'Community Trust', prov.profile.behaviors.communityTrust, AppColors.purple),
                      _behaviorItem(t, 'Digital Footprint', prov.profile.behaviors.digitalFootprint, AppColors.coral),
                    ],
                  ),
                  title: 'Behavior Scores',
                ),
                const SizedBox(height: 12),
                _miniCard(t,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Chama Groups',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: t.heading)),
                      const SizedBox(height: 12),
                      ...prov.profile.chamaGroups.map((g) => Container(
                        padding: const EdgeInsets.all(14),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(g.name,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.primaryDark)),
                                  const SizedBox(height: 2),
                                  Text('${g.members} members · ${g.cycle} · ${prov.fmt(g.contribution)}/cycle',
                                      style: TextStyle(fontSize: 12, color: t.secondary)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: g.standing == 'Excellent' ? AppColors.greenLight : AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text('● ${g.standing}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: g.standing == 'Excellent' ? AppColors.green : AppColors.primary,
                                  )),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(DashboardProvider prov, ThemeTokens t) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF065F46), Color(0xFF059669)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back,'.toUpperCase(),
                          style: TextStyle(fontSize: 11, letterSpacing: 0.5, color: Colors.white.withValues(alpha: 0.7))),
                      const SizedBox(height: 2),
                      Text(prov.profile.name,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                      Text('${prov.profile.city}, ${prov.profile.country}',
                          style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Net Balance',
                            style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.7))),
                        const SizedBox(height: 4),
                        Text(prov.fmt(prov.net),
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.arrow_upward, size: 12, color: Color(0xFF34D399)),
                            const SizedBox(width: 4),
                            Text(prov.fmt(prov.totalIncome),
                                style: const TextStyle(fontSize: 12, color: Color(0xFF34D399))),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.arrow_downward, size: 12, color: Color(0xFFFB7185)),
                            const SizedBox(width: 4),
                            Text(prov.fmt(prov.totalExpense),
                                style: const TextStyle(fontSize: 12, color: Color(0xFFFB7185))),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scoreCard(DashboardProvider prov, ThemeTokens t, Map<String, dynamic> sc, Map tier) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Financial Score',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: t.heading)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(tier['color'] as int).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(prov.profile.tier == 'Platinum' ? '💎' :
                         prov.profile.tier == 'Gold' ? '🥇' :
                         prov.profile.tier == 'Silver' ? '🥈' : '🥉',
                         style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text(prov.profile.tier,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                          color: Color(tier['color'] as int))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ScoreGauge(
            score: prov.profile.score,
            gaugeBg: t.gaugeBg,
            textSecondary: t.secondary,
            textMuted: t.muted,
          ),
          const SizedBox(height: 8),
          if (tier['next'] != null)
            Text('${tier['nextScore'] - prov.profile.score} pts to ${tier['next']}',
                style: TextStyle(fontSize: 12, color: t.secondary)),
        ],
      ),
    );
  }

  Widget _miniCard(ThemeTokens t, {required Widget child, String? title}) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: t.heading)),
            ),
          child,
        ],
      ),
    );
  }

  Widget _behaviorItem(ThemeTokens t, String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontSize: 13, color: t.secondary)),
              Text('$value%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: color)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: t.gaugeBg,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactions(DashboardProvider prov, ThemeTokens t, {required Key key}) {
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
      child: Column(
        children: [
          _miniCard(t,
            child: const MonthCalendar(),
            title: 'Daily Profit / Loss',
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Transactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: t.text)),
              GestureDetector(
                onTap: prov.startNewTx,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 16, color: Colors.white),
                      SizedBox(width: 4),
                      Text('Add', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (prov.newTx != null || prov.editingTx != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TxForm(
                tx: prov.newTx ?? prov.editingTx!,
                onSave: prov.saveTx,
                onCancel: prov.cancelTxForm,
                theme: t,
              ),
            ),
          ...prov.transactions.map((tx) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: t.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: t.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: tx.type == 'income' ? AppColors.greenLight : AppColors.coralLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      tx.type == 'income' ? Icons.arrow_downward : Icons.arrow_upward,
                      size: 18,
                      color: tx.type == 'income' ? AppColors.green : AppColors.coral,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tx.label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: t.text)),
                      const SizedBox(height: 2),
                      Text('${tx.date} · ${tx.category}',
                          style: TextStyle(fontSize: 12, color: t.muted)),
                    ],
                  ),
                ),
                Text(
                  '${tx.type == 'income' ? '+' : '-'}${prov.fmt(tx.amount)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: tx.type == 'income' ? AppColors.green : AppColors.coral,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(Icons.edit_rounded, size: 16, color: t.muted),
                  onPressed: () => prov.startEditTx(tx),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                IconButton(
                  icon: Icon(Icons.delete_rounded, size: 16, color: AppColors.coral),
                  onPressed: () => prov.deleteTx(tx.id),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildOpportunities(DashboardProvider prov, ThemeTokens t, {required Key key}) {
    final categories = kOppCategories;
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Opportunities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: t.text)),
          const SizedBox(height: 4),
          Text('${prov.eligibleOpps.length} of ${kGlobalOpportunities.length} unlocked · Score ${prov.profile.score}',
              style: TextStyle(fontSize: 13, color: t.secondary)),
          const SizedBox(height: 12),
          SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categories.map((cat) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => prov.setOppFilter(cat),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: prov.oppFilter == cat ? AppColors.primary : Colors.transparent,
                      border: Border.all(
                        color: prov.oppFilter == cat ? AppColors.primary : t.border,
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(cat, style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: prov.oppFilter == cat ? Colors.white : t.secondary,
                    )),
                  ),
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 16),
          ...prov.filteredOpps.map((opp) => _oppCard(opp, prov, t)),
        ],
      ),
    );
  }

  Widget _oppCard(Opportunity opp, DashboardProvider prov, ThemeTokens t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: t.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(opp.type, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: t.text)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text('${opp.baseMatch}% match',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('${opp.provider} · ${opp.category}',
              style: TextStyle(fontSize: 12, color: t.secondary)),
          const SizedBox(height: 6),
          Text(opp.description,
              style: TextStyle(fontSize: 12, color: t.body, height: 1.4)),
          const SizedBox(height: 8),
          if (opp.rateInfo != null || opp.amount != null)
            Text(
              opp.rateInfo != null
                  ? opp.rateInfo!.replaceAllMapped(
                      RegExp(r'\$[\d,]+(\.\d+)?'),
                      (m) => prov.convertUsd(double.parse(m[0]!.replaceAll(RegExp(r'[$,]'), ''))),
                    )
                  : 'Up to ${prov.convertUsd(opp.amount!)}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
            ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('Apply / Learn More →',
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final int index;
  const _NavItem(this.icon, this.label, this.index);
}
