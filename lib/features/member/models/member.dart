class Member {
  Member({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String createdAt;
  final String updatedAt;

  factory Member.fromMap(Map<String, dynamic> json) => Member(
        id: json['id'] as String,
        name: json['name'] as String,
        createdAt: json['created_at'] as String,
        updatedAt: json['updated_at'] as String,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
