class BehaviorScores {
  final int consistencyScore;
  final int savingsRatio;
  final int repaymentHistory;
  final int incomeStability;
  final int communityTrust;
  final int digitalFootprint;

  const BehaviorScores({
    required this.consistencyScore,
    required this.savingsRatio,
    required this.repaymentHistory,
    required this.incomeStability,
    required this.communityTrust,
    required this.digitalFootprint,
  });
}

class ChamaGroup {
  final String name;
  final int members;
  final double contribution;
  final String cycle;
  final String standing;

  const ChamaGroup({
    required this.name,
    required this.members,
    required this.contribution,
    required this.cycle,
    required this.standing,
  });
}

class Profile {
  final String? anonymousId;
  final String name;
  final String phone;
  final String country;
  final String city;
  final String occupation;
  final String joinDate;
  final int score;
  final String tier;
  final bool isOnboarded;
  final bool isDark;
  final String currencyCode;
  final BehaviorScores behaviors;
  final List<ChamaGroup> chamaGroups;
  final List<double> monthlyData;
  final double monthlyIncome;

  const Profile({
    this.anonymousId,
    required this.name,
    required this.phone,
    required this.country,
    required this.city,
    required this.occupation,
    required this.joinDate,
    required this.score,
    required this.tier,
    this.isOnboarded = false,
    this.isDark = false,
    this.currencyCode = 'TZS',
    required this.behaviors,
    required this.chamaGroups,
    required this.monthlyData,
    required this.monthlyIncome,
  });

  Profile copyWith({
    String? anonymousId,
    String? name,
    String? phone,
    String? country,
    String? city,
    String? occupation,
    String? joinDate,
    int? score,
    String? tier,
    bool? isOnboarded,
    bool? isDark,
    String? currencyCode,
    BehaviorScores? behaviors,
    List<ChamaGroup>? chamaGroups,
    List<double>? monthlyData,
    double? monthlyIncome,
  }) {
    return Profile(
      anonymousId: anonymousId ?? this.anonymousId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      city: city ?? this.city,
      occupation: occupation ?? this.occupation,
      joinDate: joinDate ?? this.joinDate,
      score: score ?? this.score,
      tier: tier ?? this.tier,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      isDark: isDark ?? this.isDark,
      currencyCode: currencyCode ?? this.currencyCode,
      behaviors: behaviors ?? this.behaviors,
      chamaGroups: chamaGroups ?? this.chamaGroups,
      monthlyData: monthlyData ?? this.monthlyData,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
    );
  }
}
