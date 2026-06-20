class Transaction {
  final int id;
  final String type;
  final String label;
  final double amount;
  final String date;
  final String category;

  const Transaction({
    required this.id,
    required this.type,
    required this.label,
    required this.amount,
    required this.date,
    required this.category,
  });

  Transaction copyWith({
    int? id,
    String? type,
    String? label,
    double? amount,
    String? date,
    String? category,
  }) {
    return Transaction(
      id: id ?? this.id,
      type: type ?? this.type,
      label: label ?? this.label,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
    );
  }
}
