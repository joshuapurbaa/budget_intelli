class FinancialCategory {
  FinancialCategory({
    required this.id,
    required this.categoryName,
    required this.type,
    required this.createdAt,
    required this.hexColor,
    this.updatedAt,
    this.iconPath,
  });

  factory FinancialCategory.fromMap(Map<String, dynamic> map) {
    return FinancialCategory(
      id: map['id'] as String,
      categoryName: map['category_name'] as String,
      type: map['type'] as String,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] != null ? map['updated_at'] as String : null,
      iconPath: map['icon_path'] != null ? map['icon_path'] as String : null,
      hexColor: map['hex_color'] as int,
    );
  }

  final String id;
  final String categoryName;
  final String type;
  final String createdAt;
  final String? updatedAt;
  final String? iconPath;
  final int hexColor;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_name': categoryName,
      'type': type,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'icon_path': iconPath,
      'hex_color': hexColor,
    };
  }
}
