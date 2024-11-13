import 'dart:typed_data';

import 'package:budget_intelli/core/core.dart';

class ItemCategoryTransaction {
  ItemCategoryTransaction({
    required this.id,
    required this.itemHistoId,
    required this.categoryName,
    required this.amount,
    required this.createdAt,
    required this.type,
    required this.budgetId,
    required this.groupId,
    required this.spendOn,
    required this.accountId,
    this.updatedAt,
    this.picture,
  });

  factory ItemCategoryTransaction.fromJson(Map<String, dynamic> json) {
    Uint8List? picture;
    if (json['picture'] != null) {
      final pictureBytes = List<int>.from(json['picture'] as List<int>);
      picture = Uint8List.fromList(pictureBytes);
    }

    return ItemCategoryTransaction(
      id: json['id'] as String,
      itemHistoId: json['item_id'] as String,
      categoryName: json['category_name'] as String,
      amount: json['amount'] as double,
      createdAt: json['created_at'] as String,
      type: json['type'] as String,
      updatedAt: json['updated_at'] as String?,
      spendOn: json['spend_on'] as String,
      picture: picture,
      budgetId: json['budget_id'] as String,
      groupId: json['group_history_id'] as String,
      accountId: json['account_id'] as String,
    );
  }

  factory ItemCategoryTransaction.fromFirestore(
    DocumentSnapshotMap snapshot,
  ) {
    final data = snapshot.data();
    Uint8List? picture;
    if (data?['picture'] != null) {
      final pictureBytes = List<int>.from(data?['picture'] as List<int>);
      picture = Uint8List.fromList(pictureBytes);
    }

    return ItemCategoryTransaction(
      id: data?['id'] as String,
      itemHistoId: data?['item_id'] as String,
      categoryName: data?['category_name'] as String,
      amount: data?['amount'] as double,
      createdAt: data?['created_at'] as String,
      type: data?['type'] as String,
      updatedAt: data?['updated_at'] as String?,
      spendOn: data?['spend_on'] as String,
      picture: picture,
      budgetId: data?['budget_id'] as String,
      groupId: data?['group_history_id'] as String,
      accountId: data?['account_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_id': itemHistoId,
      'category_name': categoryName,
      'amount': amount,
      'created_at': createdAt,
      'type': type,
      'updated_at': updatedAt,
      'spend_on': spendOn,
      'picture': picture,
      'budget_id': budgetId,
      'group_history_id': groupId,
      'account_id': accountId,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'item_id': itemHistoId,
      'category_name': categoryName,
      'amount': amount,
      'created_at': createdAt,
      'type': type,
      'updated_at': updatedAt,
      'spend_on': spendOn,
      'picture': picture,
      'budget_id': budgetId,
      'group_history_id': groupId,
      'account_id': accountId,
    };
  }

  final String id;
  final String itemHistoId;
  final String categoryName;
  final String budgetId;
  final String groupId;
  final double amount;
  final String createdAt;
  final String type;
  final String? updatedAt;
  final String spendOn;
  final Uint8List? picture;
  final String accountId;

  ItemCategoryTransaction copyWith({
    String? id,
    String? itemId,
    String? categoryName,
    double? amount,
    String? createdAt,
    String? type,
    String? updatedAt,
    String? spendOn,
    Uint8List? picture,
    String? budgetId,
    String? groupId,
    String? accountId,
  }) {
    return ItemCategoryTransaction(
      id: id ?? this.id,
      itemHistoId: itemId ?? itemHistoId,
      categoryName: categoryName ?? this.categoryName,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      updatedAt: updatedAt ?? this.updatedAt,
      spendOn: spendOn ?? this.spendOn,
      picture: picture ?? this.picture,
      budgetId: budgetId ?? this.budgetId,
      groupId: groupId ?? this.groupId,
      accountId: accountId ?? this.accountId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItemCategoryTransaction &&
        other.id == id &&
        other.itemHistoId == itemHistoId &&
        other.categoryName == categoryName &&
        other.amount == amount &&
        other.createdAt == createdAt &&
        other.type == type &&
        other.updatedAt == updatedAt &&
        other.spendOn == spendOn &&
        other.picture == picture &&
        other.budgetId == budgetId &&
        other.groupId == groupId &&
        other.accountId == accountId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        itemHistoId.hashCode ^
        categoryName.hashCode ^
        amount.hashCode ^
        createdAt.hashCode ^
        type.hashCode ^
        updatedAt.hashCode ^
        spendOn.hashCode ^
        picture.hashCode ^
        budgetId.hashCode ^
        groupId.hashCode ^
        accountId.hashCode;
  }
}
