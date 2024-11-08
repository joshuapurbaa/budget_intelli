import 'dart:typed_data';

class Member {
  Member({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.iconPath,
    this.icon,
  });

  factory Member.fromMap(Map<String, dynamic> json) => Member(
        id: json['id'] as String,
        name: json['name'] as String,
        createdAt: json['created_at'] as String,
        updatedAt: json['updated_at'] as String,
        iconPath: json['icon_path'] as String?,
        icon: json['icon'] as Uint8List?,
      );

  final String id;
  final String name;
  final String createdAt;
  final String updatedAt;
  final String? iconPath;
  final Uint8List? icon;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'icon_path': iconPath,
        'icon': icon,
      };
}
