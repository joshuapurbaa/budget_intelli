class Account {
  Account({
    required this.id,
    required this.name,
    required this.accountType,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
    this.iconPath,
    this.hexColor,
  });

  // create fromMap method
  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'] as String,
      name: map['name'] as String,
      accountType: map['account_type'] as String,
      amount: map['amount'] as int,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
      iconPath: map['icon_path'] as String?,
      hexColor: map['hex_color'] as String?,
    );
  }

  final String id;
  final String name;
  final String accountType;
  final int amount;
  final String createdAt;
  final String updatedAt;
  final String? iconPath;
  final String? hexColor;

  // create toMap method
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'account_type': accountType,
      'amount': amount,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'icon_path': iconPath,
      'hex_color': hexColor,
    };
  }

  // create copywith
  Account copyWith({
    String? id,
    String? name,
    String? accountType,
    int? amount,
    String? createdAt,
    String? updatedAt,
    String? iconPath,
    String? hexColor,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      accountType: accountType ?? this.accountType,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      iconPath: iconPath ?? this.iconPath,
      hexColor: hexColor ?? this.hexColor,
    );
  }
}
