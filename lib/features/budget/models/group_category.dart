import 'package:budget_intelli/core/core.dart';
import 'package:equatable/equatable.dart';

class GroupCategory extends Equatable {
  const GroupCategory({
    required this.id,
    required this.groupName,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.iconPath,
    required this.hexColor,
  });

  factory GroupCategory.fromJson(Map<String, dynamic> map) {
    return GroupCategory(
      id: map['id'] as String,
      groupName: map['group_name'] as String,
      type: map['type'] as String,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String?,
      iconPath: map['icon_path'] as String?,
      hexColor: map['hex_color'] as int,
    );
  }

  // fromFirestore
  factory GroupCategory.fromFirestore(
    DocumentSnapshotMap snapshot,
  ) {
    final data = snapshot.data();
    return GroupCategory(
      id: data?['id'] as String,
      groupName: data?['group_name'] as String,
      type: data?['type'] as String,
      createdAt: data?['created_at'] as String,
      updatedAt: data?['updated_at'] as String?,
      iconPath: data?['icon_path'] as String?,
      hexColor: data?['hex_color'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_name': groupName,
      'type': type,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'icon_path': iconPath,
      'hex_color': hexColor,
    };
  }

  // toFirestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'group_name': groupName,
      'type': type,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'icon_path': iconPath,
      'hex_color': hexColor,
    };
  }

  final String id;
  final String groupName;
  final String type;
  final String createdAt;
  final String? updatedAt;
  final String? iconPath;
  final int hexColor;

  // copyWith method
  GroupCategory copyWith({
    String? id,
    String? groupName,
    String? type,
    String? createdAt,
    String? updatedAt,
    String? iconPath,
    int? hexColor,
  }) {
    return GroupCategory(
      id: id ?? this.id,
      groupName: groupName ?? this.groupName,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      iconPath: iconPath ?? this.iconPath,
      hexColor: hexColor ?? this.hexColor,
    );
  }

  @override
  List<Object?> get props => [
        id,
        groupName,
        type,
        createdAt,
        updatedAt,
        iconPath,
        hexColor,
      ];
}
