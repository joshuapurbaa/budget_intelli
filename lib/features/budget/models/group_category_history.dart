import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:flutter/foundation.dart';

class GroupCategoryHistory {
  GroupCategoryHistory({
    required this.id,
    required this.groupName,
    required this.type,
    required this.groupId,
    required this.createdAt,
    required this.hexColor,
    this.itemCategoryHistories = const [],
    this.budgetId,
    this.method,
    this.updatedAt,
  });

  factory GroupCategoryHistory.fromJson(Map<String, dynamic> map) {
    return GroupCategoryHistory(
      id: map['id'] as String,
      groupName: map['group_name'] as String,
      method: map['method'] as String?,
      type: map['type'] as String,
      budgetId: map['budget_id'] as String?,
      itemCategoryHistories: List<ItemCategoryHistory>.from(
        List<dynamic>.from(
          map['item_category_history'] as List<dynamic>,
        ).map(
          (dynamic item) => ItemCategoryHistory.fromJson(item as Map<String, dynamic>),
        ),
      ),
      groupId: map['group_id'] as String,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String?,
      hexColor: map['hex_color'] as int,
    );
  }

  // fromFirestore
  factory GroupCategoryHistory.fromFirestore(
    DocumentSnapshotMap snapshot,
  ) {
    final data = snapshot.data();
    return GroupCategoryHistory(
      id: data?['id'] as String,
      groupName: data?['group_name'] as String,
      method: data?['method'] as String?,
      type: data?['type'] as String,
      budgetId: data?['budget_id'] as String?,
      groupId: data?['group_id'] as String,
      itemCategoryHistories: List<ItemCategoryHistory>.from(
        List<dynamic>.from(
          data?['item_category_history'] as List<dynamic>,
        ).map(
          (dynamic item) => ItemCategoryHistory.fromJson(item as Map<String, dynamic>),
        ),
      ),
      createdAt: data?['created_at'] as String,
      updatedAt: data?['updated_at'] as String?,
      hexColor: data?['hex_color'] as int,
    );
  }

  // from json without item categories
  factory GroupCategoryHistory.fromJsonWithoutItemCategories(
    Map<String, dynamic> map,
  ) {
    return GroupCategoryHistory(
      id: map['id'] as String,
      groupName: map['group_name'] as String,
      method: map['method'] as String?,
      type: map['type'] as String,
      budgetId: map['budget_id'] as String?,
      groupId: map['group_id'] as String,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String?,
      hexColor: map['hex_color'] as int,
    );
  }

  final String id;
  final String groupName;
  final String? method;
  final String type;
  final String? budgetId;
  final String groupId;
  final List<ItemCategoryHistory> itemCategoryHistories;
  final String createdAt;
  final String? updatedAt;
  final int hexColor;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_name': groupName,
      'method': method,
      'type': type,
      'budget_id': budgetId,
      'group_id': groupId,
      'item_category_history': itemCategoryHistories.map((x) => x.toJson()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'hex_color': hexColor,
    };
  }

  Map<String, dynamic> toJsonWithoutItemCategories() {
    return {
      'id': id,
      'group_name': groupName,
      'method': method,
      'type': type,
      'budget_id': budgetId,
      'group_id': groupId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'hex_color': hexColor,
    };
  }

  Map<String, dynamic> toFirestoreWithoutItemCategories() {
    return {
      'id': id,
      'group_name': groupName,
      'method': method,
      'type': type,
      'budget_id': budgetId,
      'group_id': groupId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'hex_color': hexColor,
    };
  }

  GroupCategoryHistory copyWith({
    String? id,
    String? groupName,
    String? method,
    String? type,
    String? budgetId,
    String? groupId,
    List<ItemCategoryHistory>? itemCategories,
    String? createdAt,
    String? updatedAt,
    int? hexColor,
  }) {
    return GroupCategoryHistory(
      id: id ?? this.id,
      groupName: groupName ?? this.groupName,
      method: method ?? this.method,
      type: type ?? this.type,
      budgetId: budgetId ?? this.budgetId,
      groupId: groupId ?? this.groupId,
      itemCategoryHistories: itemCategories ?? itemCategoryHistories,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      hexColor: hexColor ?? this.hexColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroupCategoryHistory &&
        other.id == id &&
        other.groupName == groupName &&
        other.method == method &&
        other.type == type &&
        other.budgetId == budgetId &&
        other.groupId == groupId &&
        listEquals(other.itemCategoryHistories, itemCategoryHistories) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.hexColor == hexColor;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        groupName.hashCode ^
        method.hashCode ^
        type.hashCode ^
        budgetId.hashCode ^
        groupId.hashCode ^
        itemCategoryHistories.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        hexColor.hashCode;
  }
}
