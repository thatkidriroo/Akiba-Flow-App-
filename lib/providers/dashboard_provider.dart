import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../data/models/currency.dart';
import '../data/models/transaction.dart';
import '../data/models/opportunity.dart';
import '../data/models/profile.dart';
import '../data/seed_data.dart';
import '../theme/app_theme.dart';

const _blankProfile = Profile(
  anonymousId: null,
  name: '',
  phone: '',
  country: 'Tanzania',
  city: 'Arusha',
  occupation: '',
  joinDate: '',
  score: 300,
  tier: 'Bronze',
  isOnboarded: false,
  isDark: false,
  currencyCode: 'TZS',
  behaviors: BehaviorScores(
    consistencyScore: 0,
    savingsRatio: 0,
    repaymentHistory: 0,
    incomeStability: 0,
    communityTrust: 0,
    digitalFootprint: 0,
  ),
  chamaGroups: [],
  monthlyData: [],
  monthlyIncome: 0,
);

class DashboardProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  Profile _profile = _blankProfile;
  List<Transaction> _transactions = [];
  Currency _currency = kCurrencies[0];
  int _activeTab = 0;
  bool _isDark = false;
  bool _editingProfile = false;
  Profile _profileDraft = _blankProfile;
  Transaction? _newTx;
  Transaction? _editingTx;
  String _oppFilter = 'All';
  bool _loadingProfile = true;
  bool _loading = false;
  String? _loadedUserId;

  bool get isOnboarded => _profile.isOnboarded;
  bool get hasOnboardedBefore => _profile.isOnboarded;
  bool get loadingProfile => _loadingProfile;

  Profile get profile => _profile;
  List<Transaction> get transactions => _transactions;
  Currency get currency => _currency;
  int get activeTab => _activeTab;
  bool get isDark => _isDark;
  bool get editingProfile => _editingProfile;
  Profile get profileDraft => _profileDraft;
  Transaction? get newTx => _newTx;
  Transaction? get editingTx => _editingTx;
  String get oppFilter => _oppFilter;

  ThemeTokens get themeTokens => ThemeTokens(isDark: _isDark);

  String get anonymousId {
    if (_profile.anonymousId == null) {
      _generateAnonymousId();
    }
    return _profile.anonymousId!;
  }

  double get totalIncome => _transactions
      .where((t) => t.type == 'income')
      .fold(0, (s, t) => s + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == 'expense')
      .fold(0, (s, t) => s + t.amount);

  double get net => totalIncome - totalExpense;

  String fmt(double amount) {
    final result = amount / _currency.toTZS;
    final parts = result.toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '${_currency.symbol}$intPart.${parts[1]}';
  }

  String fmtCompact(double amount) {
    final tzs = amount / _currency.toTZS;
    if (tzs >= 1000000) return '${_currency.symbol}${(tzs / 1000000).toStringAsFixed(1)}M';
    if (tzs >= 1000) return '${_currency.symbol}${(tzs / 1000).toStringAsFixed(1)}k';
    return '${_currency.symbol}${tzs.toStringAsFixed(0)}';
  }

  String convertUsd(double usdAmount) {
    return fmt(usdAmount * 2500);
  }

  List<Opportunity> get eligibleOpps =>
      kGlobalOpportunities.where((o) => _profile.score >= o.minScore).toList();

  List<Opportunity> get filteredOpps {
    final eligible = eligibleOpps;
    if (_oppFilter == 'All') {
      eligible.sort((a, b) => b.baseMatch.compareTo(a.baseMatch));
      return eligible;
    }
    final filtered = eligible.where((o) => o.category == _oppFilter).toList();
    filtered.sort((a, b) => b.baseMatch.compareTo(a.baseMatch));
    return filtered;
  }

  void setActiveTab(int index) {
    _activeTab = index;
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDark = !_isDark;
    notifyListeners();
    _saveProfileField('is_dark', _isDark);
  }

  void setCurrency(Currency c) {
    _currency = c;
    notifyListeners();
    _saveProfileField('currency_code', c.code);
  }

  void startEditingProfile() {
    _profileDraft = _profile;
    _editingProfile = true;
    notifyListeners();
  }

  void updateProfileDraft({
    String? name,
    String? phone,
    String? occupation,
    String? country,
    String? city,
  }) {
    _profileDraft = _profileDraft.copyWith(
      name: name,
      phone: phone,
      occupation: occupation,
      country: country,
      city: city,
    );
    notifyListeners();
  }

  void saveProfile() {
    _profile = _profileDraft;
    _editingProfile = false;
    _syncProfileToSupabase();
    notifyListeners();
  }

  void cancelEditingProfile() {
    _editingProfile = false;
    notifyListeners();
  }

  void startNewTx() {
    final now = DateTime.now();
    final date =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    _newTx = Transaction(
      id: 0,
      type: 'income',
      label: '',
      amount: 0,
      date: date,
      category: 'trade',
    );
    notifyListeners();
  }

  void startEditTx(Transaction tx) {
    _editingTx = tx;
    notifyListeners();
  }

  int get behaviorBaseScore {
    final b = _profile.behaviors;
    final avg = (b.consistencyScore + b.savingsRatio + b.repaymentHistory +
        b.incomeStability + b.communityTrust + b.digitalFootprint) / 6.0;
    return (avg * 7).round();
  }

  int get transactionBonusScore {
    final incomes = _transactions.where((t) => t.type == 'income').toList();
    final expenses = _transactions.where((t) => t.type == 'expense').toList();
    final totalInc = incomes.fold(0.0, (s, t) => s + t.amount);
    final totalExp = expenses.fold(0.0, (s, t) => s + t.amount);
    double s = 0;
    if (_transactions.length >= 3 && totalInc > 0) {
      s += ((totalInc - totalExp) / totalInc).clamp(0, 1.0) * 60;
    }
    final netSavings = totalInc - totalExp;
    if (netSavings > 0) {
      s += (math.log(netSavings / 100000 + 1) / math.log(1001) * 60).clamp(0, 60);
    }
    s += (incomes.length / (incomes.length + expenses.length + 1)) * 30;
    s += (_transactions.length.clamp(0, 20) / 20.0) * 30;
    final now = DateTime.now();
    final recentTxs = _transactions.where((t) {
      try { return now.difference(DateTime.parse(t.date)).inDays <= 60; } catch (_) { return false; }
    }).length;
    s += (recentTxs / (_transactions.length + 1)) * 30;
    if (totalInc > totalExp) s += 20;
    return s.round().clamp(0, 230);
  }

  double get savingsRate {
    final inc = _transactions.where((t) => t.type == 'income').fold(0.0, (s, t) => s + t.amount);
    final exp = _transactions.where((t) => t.type == 'expense').fold(0.0, (s, t) => s + t.amount);
    if (inc <= 0) return 0;
    return ((inc - exp) / inc * 100).clamp(0, 100);
  }

  List<double> getTrendData(String period) {
    final now = DateTime.now();
    switch (period) {
      case 'weekly':
        return List<double>.generate(6, (i) {
          final ref = now.subtract(Duration(days: (5 - i) * 7));
          final weekStart = ref.subtract(Duration(days: ref.weekday - 1));
          final weekEnd = weekStart.add(const Duration(days: 6));
          return _transactions.where((t) {
            try {
              final d = DateTime.parse(t.date);
              return t.type == 'income' && !d.isBefore(weekStart) && !d.isAfter(weekEnd);
            } catch (_) {
              return false;
            }
          }).fold(0.0, (s, t) => s + t.amount);
        });
      case 'yearly':
        return List<double>.generate(5, (i) {
          final y = now.year - 4 + i;
          return _transactions.where((t) {
            try { return t.type == 'income' && DateTime.parse(t.date).year == y; } catch (_) { return false; }
          }).fold(0.0, (s, t) => s + t.amount);
        });
      default:
        return List<double>.generate(12, (i) {
          final m = now.month - 12 + i + 1;
          final y = now.year + (m > 12 ? 1 : 0);
          final adjM = ((m - 1) % 12) + 1;
          return _transactions.where((t) {
            try {
              final d = DateTime.parse(t.date);
              return t.type == 'income' && d.month == adjM && d.year == y;
            } catch (_) {
              return false;
            }
          }).fold(0.0, (s, t) => s + t.amount);
        });
    }
  }

  Map<int, double> getDailyProfitLoss(int year, int month) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final result = <int, double>{};
    for (int d = 1; d <= daysInMonth; d++) {
      final dateStr = '$year-${month.toString().padLeft(2, '0')}-${d.toString().padLeft(2, '0')}';
      final dayTxs = _transactions.where((t) => t.date == dateStr).toList();
      if (dayTxs.isNotEmpty) {
        final inc = dayTxs.where((t) => t.type == 'income').fold(0.0, (s, t) => s + t.amount);
        final exp = dayTxs.where((t) => t.type == 'expense').fold(0.0, (s, t) => s + t.amount);
        result[d] = inc - exp;
      }
    }
    return result;
  }

  List<double> getWeeklySpending() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return List<double>.generate(7, (i) {
      final day = monday.add(Duration(days: i));
      final dateStr = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      return _transactions.where((t) {
        try {
          return t.type == 'expense' && t.date == dateStr;
        } catch (_) {
          return false;
        }
      }).fold(0.0, (s, t) => s + t.amount);
    });
  }

  void _recalculateScore() {
    final rawScore = behaviorBaseScore + transactionBonusScore;
    final finalScore = rawScore.clamp(300, 850);

    String tier;
    if (finalScore >= 800) {
      tier = 'Platinum';
    } else if (finalScore >= 700) {
      tier = 'Gold';
    } else if (finalScore >= 550) {
      tier = 'Silver';
    } else {
      tier = 'Bronze';
    }

    final incomes = _transactions.where((t) => t.type == 'income').toList();
    final expenses = _transactions.where((t) => t.type == 'expense').toList();
    final totalInc = incomes.fold(0.0, (s, t) => s + t.amount);
    final totalExp = expenses.fold(0.0, (s, t) => s + t.amount);
    final b = _profile.behaviors;
    final txCount = _transactions.length;

    final updatedBehaviors = BehaviorScores(
      consistencyScore: _clampBehavior((totalInc - totalExp) / (totalInc + 1) * 100, b.consistencyScore),
      savingsRatio: _clampBehavior(totalInc > 0 ? ((totalInc - totalExp) / totalInc * 100) : b.savingsRatio.toDouble(), b.savingsRatio),
      repaymentHistory: b.repaymentHistory,
      incomeStability: _clampBehavior((incomes.length > expenses.length ? 1 : 0.5) * 100, b.incomeStability),
      communityTrust: b.communityTrust,
      digitalFootprint: _clampBehavior(txCount * 5, b.digitalFootprint),
    );

    final now = DateTime.now();
    _profile = _profile.copyWith(
      score: finalScore,
      tier: tier,
      behaviors: updatedBehaviors,
      monthlyData: getTrendData('monthly'),
      monthlyIncome: totalInc / (now.month),
    );
  }

  int _clampBehavior(double raw, int current) {
    final smoothed = (current * 0.7 + raw * 0.3).round();
    return smoothed.clamp(0, 100);
  }

  Future<void> saveTx(Transaction tx) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    if (tx.id != 0) {
      await _supabase
          .from('transactions')
          .update({
            'type': tx.type,
            'label': tx.label,
            'amount': tx.amount,
            'date': tx.date,
            'category': tx.category,
          })
          .eq('id', tx.id)
          .eq('user_id', user.id);
      _transactions = _transactions.map((t) => t.id == tx.id ? tx : t).toList();
    } else {
      final response = await _supabase
          .from('transactions')
          .insert({
            'user_id': user.id,
            'type': tx.type,
            'label': tx.label,
            'amount': tx.amount,
            'date': tx.date,
            'category': tx.category,
          })
          .select('id')
          .single();
      final newId = response['id'] as int;
      _transactions = [..._transactions, tx.copyWith(id: newId)];
    }
    _newTx = null;
    _editingTx = null;
    _recalculateScore();
    _updateScoreInSupabase();
    notifyListeners();
  }

  Future<void> deleteTx(int id) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase
        .from('transactions')
        .delete()
        .eq('id', id)
        .eq('user_id', user.id);
    _transactions = _transactions.where((t) => t.id != id).toList();
    _recalculateScore();
    _updateScoreInSupabase();
    notifyListeners();
  }

  void cancelTxForm() {
    _newTx = null;
    _editingTx = null;
    notifyListeners();
  }

  void setOppFilter(String filter) {
    _oppFilter = filter;
    notifyListeners();
  }

  bool get hasLoaded => _loadedUserId != null;

  Future<void> init() async {
    if (_loading) return;
    final user = _supabase.auth.currentUser;
    if (_loadedUserId == user?.id) return;
    _loading = true;
    _loadedUserId = user?.id;

    if (user != null) {
      _loadingProfile = true;
      notifyListeners();
      try {
        await _loadProfile(user.id);
        await _loadTransactions(user.id);
        _recalculateScore();
      } catch (e) {
        debugPrint('[AkibaFlow] init load failed: $e');
      }
      _loadingProfile = false;
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> reloadAfterSignIn() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    _loadingProfile = true;
    notifyListeners();

    _transactions = [];
    _profile = _blankProfile.copyWith(anonymousId: null);
    _loadedUserId = null;

    await _loadProfile(user.id);
    await _loadTransactions(user.id);
    _recalculateScore();

    if (_profile.anonymousId == null) {
      _generateAnonymousId();
    }

    _loadingProfile = false;
    _loadedUserId = user.id;
    notifyListeners();
  }

  Future<void> signOut() async {
    _profile = _blankProfile;
    _transactions = [];
    _isDark = false;
    _currency = kCurrencies[0];
    _loadedUserId = null;
    _loading = false;
    notifyListeners();
  }

  Future<void> _loadProfile(String userId) async {
    _profile = _blankProfile;
    try {
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      debugPrint('[AkibaFlow] Profile loaded: is_onboarded=${data['is_onboarded']}, name=${data['name']}, city=${data['city']}');

      _profile = _profile.copyWith(
        name: data['name'] as String? ?? '',
        phone: data['phone'] as String? ?? '',
        country: data['country'] as String? ?? 'Tanzania',
        city: data['city'] as String? ?? 'Arusha',
        occupation: data['occupation'] as String? ?? '',
        anonymousId: data['anonymous_id'] as String?,
        score: data['score'] as int? ?? 300,
        tier: data['tier'] as String? ?? 'Bronze',
        isOnboarded: data['is_onboarded'] as bool? ?? false,
        isDark: data['is_dark'] as bool? ?? false,
        currencyCode: data['currency_code'] as String? ?? 'TZS',
      );

      _isDark = _profile.isDark;

      final match = kCurrencies.where((c) => c.code == _profile.currencyCode);
      if (match.isNotEmpty) _currency = match.first;
    } catch (e) {
      debugPrint('[AkibaFlow] _loadProfile query failed: $e');
    }
  }

  Future<void> _loadTransactions(String userId) async {
    try {
      final data = await _supabase
          .from('transactions')
          .select()
          .eq('user_id', userId)
          .order('date', ascending: false);

      _transactions = (data as List).map((row) {
        return Transaction(
          id: row['id'] as int,
          type: row['type'] as String,
          label: row['label'] as String,
          amount: (row['amount'] as num).toDouble(),
          date: row['date'] as String,
          category: row['category'] as String,
        );
      }).toList();
    } catch (_) {
      _transactions = [];
    }
  }

  Future<void> saveUserProfile({
    required String name,
    required String phone,
    required String occupation,
    String city = 'Arusha',
    String country = 'Tanzania',
  }) async {
    _profile = _profile.copyWith(
      name: name,
      phone: phone,
      occupation: occupation,
      city: city,
      country: country,
      isOnboarded: true,
    );

    await _syncProfileToSupabase();
    notifyListeners();
  }

  Future<void> _syncProfileToSupabase() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _supabase.from('profiles').upsert({
        'id': user.id,
        'name': _profile.name,
        'phone': _profile.phone,
        'country': _profile.country,
        'city': _profile.city,
        'occupation': _profile.occupation,
        'anonymous_id': _profile.anonymousId,
        'is_onboarded': _profile.isOnboarded,
        'is_dark': _isDark,
        'currency_code': _currency.code,
        'score': _profile.score,
        'tier': _profile.tier,
      });
    } catch (e) {
      debugPrint('[AkibaFlow] _syncProfileToSupabase failed: $e');
    }
  }

  Future<void> _saveProfileField(String field, dynamic value) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _supabase
          .from('profiles')
          .update({field: value})
          .eq('id', user.id);
    } catch (_) {}
  }

  Future<void> _updateScoreInSupabase() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _supabase
          .from('profiles')
          .update({'score': _profile.score, 'tier': _profile.tier})
          .eq('id', user.id);
    } catch (_) {}
  }

  void _generateAnonymousId() {
    final uuid = const Uuid().v4();
    final id = 'User_${uuid.substring(0, 8).toUpperCase()}';
    _profile = _profile.copyWith(anonymousId: id);
    _saveProfileField('anonymous_id', id);
    notifyListeners();
  }

  void generateNewAnonymousId() {
    _generateAnonymousId();
  }
}
