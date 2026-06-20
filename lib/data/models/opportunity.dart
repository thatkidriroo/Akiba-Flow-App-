class Opportunity {
  final String type;
  final String category;
  final String description;
  final String? rateInfo;
  final double? amount;
  final String provider;
  final String link;
  final int minScore;
  final int baseMatch;

  const Opportunity({
    required this.type,
    required this.category,
    required this.description,
    this.rateInfo,
    this.amount,
    required this.provider,
    required this.link,
    required this.minScore,
    required this.baseMatch,
  });
}
