import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../theme/app_theme.dart';
import '../../data/seed_data.dart';

class ScoreDetailSheet extends StatelessWidget {
  const ScoreDetailSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, prov, _) {
        final t = prov.themeTokens;
        final sc = scoreColor(prov.profile.score);
        final tier = kTierConfig[prov.profile.tier]!;
        final behavior = prov.behaviorBaseScore;
        final txBonus = prov.transactionBonusScore;
        final total = behavior + txBonus;

        return Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          decoration: BoxDecoration(
            color: t.card,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 36, height: 4, decoration: BoxDecoration(
                color: t.muted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              )),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Financial Score', style: TextStyle(fontSize: 13, color: t.secondary)),
                        const SizedBox(height: 4),
                        Text(
                          '${prov.profile.score}',
                          style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w800,
                            color: sc['color'] as Color,
                          ),
                        ),
                        Row(
                          children: [
                            Text(prov.profile.tier, style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600,
                              color: Color(tier['color'] as int),
                            )),
                            const SizedBox(width: 8),
                            if (tier['next'] != null && tier['nextScore'] != null)
                              Text('${(tier['nextScore'] as int) - prov.profile.score} pts to ${tier['next']}',
                                  style: TextStyle(fontSize: 12, color: t.muted)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('SAVINGS RATE', style: TextStyle(fontSize: 10, color: t.muted, letterSpacing: 1)),
                      const SizedBox(height: 2),
                      Text('${prov.savingsRate.round()}%', style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w700,
                        color: prov.savingsRate >= 20 ? AppColors.primary : AppColors.accent,
                      )),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _scoreBar(t, 'Behavior Base', behavior, 700, AppColors.primary),
              const SizedBox(height: 10),
              _scoreBar(t, 'Transaction Bonus', txBonus, 230, AppColors.accent),
              const SizedBox(height: 10),
              _scoreBar(t, 'Total', total, 850, sc['color'] as Color),
              const SizedBox(height: 24),
              Text('BEHAVIOR BREAKDOWN', style: TextStyle(fontSize: 10, color: t.muted, letterSpacing: 1)),
              const SizedBox(height: 12),
              ..._behaviorRows(prov, t),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: (sc['bg'] as Color).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: (sc['bg'] as Color).withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, size: 18, color: sc['color'] as Color),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _insight(prov),
                        style: TextStyle(fontSize: 12, color: t.secondary, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Close', textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _scoreBar(ThemeTokens t, String label, int value, int max, Color color) {
    final pct = (value / max).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: t.secondary)),
            Text('$value / $max', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: t.text)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: pct,
            backgroundColor: t.gaugeBg,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  List<Widget> _behaviorRows(DashboardProvider prov, ThemeTokens t) {
    final items = [
      ('Consistency', prov.profile.behaviors.consistencyScore, AppColors.primary),
      ('Savings Ratio', prov.profile.behaviors.savingsRatio, AppColors.blue),
      ('Repayment', prov.profile.behaviors.repaymentHistory, AppColors.green),
      ('Income Stability', prov.profile.behaviors.incomeStability, AppColors.accent),
      ('Community Trust', prov.profile.behaviors.communityTrust, AppColors.purple),
      ('Digital Footprint', prov.profile.behaviors.digitalFootprint, AppColors.coral),
    ];
    return items.map((i) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: _scoreBar(t, i.$1, i.$2, 100, i.$3),
    )).toList();
  }

  String _insight(DashboardProvider prov) {
    final sr = prov.savingsRate;
    final b = prov.profile.behaviors;
    if (sr < 10) return 'Your savings rate is low. Try to save at least 20% of income to improve your score.';
    if (b.digitalFootprint < 40) return 'Increasing your digital transactions can strengthen your financial profile.';
    if (b.incomeStability < 50) return 'More consistent income entries could raise your stability score.';
    if (prov.transactionBonusScore < 100) return 'Adding more income transactions and maintaining a positive balance boosts your bonus.';
    return 'Great shape! Keep saving consistently and maintaining a diverse transaction history.';
  }
}
