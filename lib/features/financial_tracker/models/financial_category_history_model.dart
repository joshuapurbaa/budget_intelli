class FinancialCategoryHistory {

  FinancialCategoryHistory({
    required this.id,
    required this.categoryName,
    required this.type,
    required this.categoryId,
    required this.createdAt,
    required this.hexColor, this.updatedAt,
  });

  factory FinancialCategoryHistory.fromMap(Map<String, dynamic> map) {
    return FinancialCategoryHistory(
      id: map['id'] as String,
      categoryName: map['category_name'] as String,
      type: map['type'] as String,
      categoryId: map['category_id'] as String,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] != null ? map['updated_at'] as String : null,
      hexColor: map['hex_color'] as int,
    );
  }
  final String id;
  final String categoryName;
  final String type;
  final String categoryId;
  final String createdAt;
  final String? updatedAt;
  final int hexColor;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_name': categoryName,
      'type': type,
      'category_id': categoryId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'hex_color': hexColor,
    };
  }
}
