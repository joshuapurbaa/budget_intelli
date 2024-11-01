class LiabilityEntity {
  LiabilityEntity({
    required this.id,
    required this.name,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
    required this.description,
  });

  final String id;
  final String name;
  final double amount;
  final String createdAt;
  final String updatedAt;
  final String? description;

  LiabilityEntity copyWith({
    String? id,
    String? name,
    double? amount,
    String? createdAt,
    String? updatedAt,
    String? description,
  }) {
    return LiabilityEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LiabilityEntity &&
        other.id == id &&
        other.name == name &&
        other.amount == amount &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        amount.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        description.hashCode;
  }
}
