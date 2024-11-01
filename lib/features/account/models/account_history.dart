class AccountHistory {
  AccountHistory({
    required this.id,
    required this.accountId,
    required this.name,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
    required this.iconPath,
    required this.hexColor,
  });

  factory AccountHistory.fromMap(Map<String, dynamic> map) {
    return AccountHistory(
      id: map['id'] as String,
      accountId: map['account_id'] as String,
      name: map['name'] as String,
      amount: map['amount'] as int,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
      iconPath: map['icon_path'] as String?,
      hexColor: map['hex_color'] as int?,
    );
  }

  final String id;
  final String accountId;
  final String name;
  final int amount;
  final String createdAt;
  final String updatedAt;
  final String? iconPath;
  final int? hexColor;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'account_id': accountId,
      'name': name,
      'amount': amount,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'icon_path': iconPath,
      'hex_color': hexColor,
    };
  }

  AccountHistory copyWith({
    String? id,
    String? accountId,
    String? name,
    int? amount,
    String? createdAt,
    String? updatedAt,
    String? iconPath,
    int? hexColor,
  }) {
    return AccountHistory(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      iconPath: iconPath ?? this.iconPath,
      hexColor: hexColor ?? this.hexColor,
    );
  }
}
