class FinancialTransaction {
  FinancialTransaction({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.comment,
    required this.amount,
    required this.date,
    required this.type,
    required this.categoryName,
    required this.accountName,
    required this.accountId,
    required this.categoryId,
  });

  // fromMap method to convert map to model
  factory FinancialTransaction.fromMap(Map<String, dynamic> map) {
    return FinancialTransaction(
      id: map['id'] as String,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
      comment: map['comment'] as String,
      amount: map['amount'] as int,
      date: map['date'] as String,
      type: map['type'] as String,
      categoryName: map['category'] as String,
      accountName: map['account_name'] as String,
      accountId: map['account_id'] as String,
      categoryId: map['category_id'] as String,
    );
  }

  // toMap method to convert model to map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'comment': comment,
      'amount': amount,
      'date': date,
      'type': type,
      'category': categoryName,
      'account_name': accountName,
      'account_id': accountId,
      'category_id': categoryId,
    };
  }

  final String id;
  final String createdAt;
  final String updatedAt;
  final String comment;
  final int amount;
  final String date;
  final String type;
  final String categoryName;
  final String accountName;
  final String accountId;
  final String categoryId;
}
