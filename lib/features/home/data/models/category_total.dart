class CategoryTotal {
  CategoryTotal({
    required this.name,
    required this.total,
    required this.iconPath,
  });

  // fromJson
  factory CategoryTotal.fromJson(Map<String, dynamic> json) {
    return CategoryTotal(
      name: json['name'] as String,
      total: json['total'] as int,
      iconPath: json['icon-path'] as String?,
    );
  }
  final String name;
  final int total;
  final String? iconPath;
}
