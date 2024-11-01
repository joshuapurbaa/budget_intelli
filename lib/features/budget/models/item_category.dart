import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class ItemCategory {
  ItemCategory({
    required this.id,
    required this.categoryName,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.iconPath,
    required this.hexColor,
  });

  factory ItemCategory.fromJson(Map<String, dynamic> map) {
    return ItemCategory(
      id: map['id'] as String,
      categoryName: map['name'] as String,
      type: map['type'] as String,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String?,
      iconPath: map['icon_path'] as String?,
      hexColor: map['hex_color'] as int?,
    );
  }

  factory ItemCategory.fromFirestore(
    DocumentSnapshotMap snapshot,
  ) {
    final data = snapshot.data();
    return ItemCategory(
      id: data?['id'] as String,
      categoryName: data?['name'] as String,
      type: data?['type'] as String,
      createdAt: data?['created_at'] as String,
      updatedAt: data?['updated_at'] as String?,
      iconPath: data?['icon_path'] as String?,
      hexColor: data?['hex_color'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': categoryName,
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
      'name': categoryName,
      'type': type,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'icon_path': iconPath,
      'hex_color': hexColor,
    };
  }

  Color? get color {
    if (hexColor != null) {
      return Color(hexColor!);
    }
    return null;
  }

  // copyWith method
  ItemCategory copyWith({
    String? id,
    String? categoryName,
    String? type,
    String? createdAt,
    String? updatedAt,
    String? iconPath,
    int? hexColor,
  }) {
    return ItemCategory(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      iconPath: iconPath ?? this.iconPath,
      hexColor: hexColor ?? this.hexColor,
    );
  }

  final String id;
  final String categoryName;
  final String type;
  final String createdAt;
  final String? updatedAt;
  final String? iconPath;
  final int? hexColor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItemCategory &&
        other.id == id &&
        other.categoryName == categoryName &&
        other.type == type &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.iconPath == iconPath &&
        other.hexColor == hexColor;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        categoryName.hashCode ^
        type.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        iconPath.hashCode ^
        hexColor.hashCode;
  }
}
