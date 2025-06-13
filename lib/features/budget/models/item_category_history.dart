import 'package:budget_intelli/core/core.dart';
import 'package:equatable/equatable.dart';

class ItemCategoryHistory extends Equatable {
  const ItemCategoryHistory({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.isExpense,
    required this.groupHistoryId,
    required this.itemId,
    required this.groupName,
    this.budgetId,
    this.hexColor,
    this.updatedAt,
    this.startDate,
    this.endDate,
    this.isFavorite = false,
    this.carryOverAmount,
    this.amount = 0.0,
    this.iconPath,
    this.remaining,
    this.totalTransactions,
  });

  factory ItemCategoryHistory.fromJson(Map<String, dynamic> map) {
    return ItemCategoryHistory(
      id: map['id'] as String,
      name: map['name'] as String,
      groupHistoryId: map['group_history_id'] as String,
      budgetId: map['budget_id'] as String,
      type: map['type'] as String,
      createdAt: map['created_at'] as String,
      isExpense: map['is_expense'] == 1 || false,
      amount: map['amount'] as double,
      totalTransactions: map['total_transactions'] as int?,
      iconPath: map['icon_path'] as String?,
      hexColor: map['hex_color'] as int?,
      updatedAt: map['updated_at'] as String?,
      startDate: map['start_date'] as String?,
      endDate: map['end_date'] as String?,
      isFavorite: map['is_favorite'] == 1 || false,
      carryOverAmount: map['carry_over_amount'] as int?,
      remaining: map['remaining'] as double?,
      itemId: map['item_id'] as String,
      groupName: map['group_name'] as String,
    );
  }

  // fromFirestore
  factory ItemCategoryHistory.fromFirestore(
    DocumentSnapshotMap snapshot,
  ) {
    final data = snapshot.data();
    return ItemCategoryHistory(
      id: data?['id'] as String,
      name: data?['name'] as String,
      groupHistoryId: data?['group_history_id'] as String,
      budgetId: data?['budget_id'] as String,
      type: data?['type'] as String,
      createdAt: data?['created_at'] as String,
      isExpense: data?['is_expense'] == 1 || false,
      amount: data?['amount'] as double,
      totalTransactions: data?['total_transactions'] as int?,
      iconPath: data?['icon_path'] as String?,
      hexColor: data?['hex_color'] as int?,
      updatedAt: data?['updated_at'] as String?,
      startDate: data?['start_date'] as String?,
      endDate: data?['end_date'] as String?,
      isFavorite: data?['is_favorite'] == 1 || false,
      carryOverAmount: data?['carry_over_amount'] as int?,
      remaining: data?['remaining'] as double?,
      itemId: data?['item_id'] as String,
      groupName: data?['group_name'] as String,
    );
  }

  final String id;
  final String name;
  final double amount;
  final String groupHistoryId;
  final String? budgetId;
  final String type;
  final String? iconPath;
  final String createdAt;
  final int? hexColor;
  final String? updatedAt;
  final bool isExpense;
  final String? startDate;
  final String? endDate;
  final bool isFavorite;
  final int? carryOverAmount;
  final double? remaining;
  final int? totalTransactions;
  final String itemId;
  final String groupName;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'group_history_id': groupHistoryId,
      'budget_id': budgetId,
      'amount': amount,
      'type': type,
      'icon_path': iconPath,
      'created_at': createdAt,
      'hex_color': hexColor,
      'updated_at': updatedAt,
      'is_expense': isExpense != true ? 0 : 1,
      'start_date': startDate,
      'end_date': endDate,
      'is_favorite': isFavorite != true ? 0 : 1,
      'carry_over_amount': carryOverAmount,
      'remaining': remaining,
      'total_transactions': totalTransactions,
      'item_id': itemId,
      'group_name': groupName,
    };
  }

  // toFirestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'group_history_id': groupHistoryId,
      'budget_id': budgetId,
      'amount': amount,
      'type': type,
      'icon_path': iconPath,
      'created_at': createdAt,
      'hex_color': hexColor,
      'updated_at': updatedAt,
      'is_expense': isExpense != true ? 0 : 1,
      'start_date': startDate,
      'end_date': endDate,
      'is_favorite': isFavorite != true ? 0 : 1,
      'carry_over_amount': carryOverAmount,
      'remaining': remaining,
      'total_transactions': totalTransactions,
      'item_id': itemId,
      'group_name': groupName,
    };
  }

  ItemCategoryHistory copyWith({
    String? id,
    String? name,
    double? amount,
    String? groupHistoryId,
    String? budgetId,
    String? type,
    String? iconPath,
    String? createdAt,
    int? hexColor,
    String? updatedAt,
    bool? isExpense,
    String? startDate,
    String? endDate,
    bool? isFavorite,
    int? carryOverAmount,
    double? remaining,
    int? totalTransactions,
    String? itemId,
    String? groupName,
  }) {
    return ItemCategoryHistory(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      groupHistoryId: groupHistoryId ?? this.groupHistoryId,
      budgetId: budgetId ?? this.budgetId,
      type: type ?? this.type,
      iconPath: iconPath ?? this.iconPath,
      createdAt: createdAt ?? this.createdAt,
      hexColor: hexColor ?? this.hexColor,
      updatedAt: updatedAt ?? this.updatedAt,
      isExpense: isExpense ?? this.isExpense,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isFavorite: isFavorite ?? this.isFavorite,
      carryOverAmount: carryOverAmount ?? this.carryOverAmount,
      remaining: remaining ?? this.remaining,
      totalTransactions: totalTransactions ?? this.totalTransactions,
      itemId: itemId ?? this.itemId,
      groupName: groupName ?? this.groupName,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        amount,
        groupHistoryId,
        budgetId,
        type,
        iconPath,
        createdAt,
        hexColor,
        updatedAt,
        isExpense,
        startDate,
        endDate,
        isFavorite,
        carryOverAmount,
        remaining,
        totalTransactions,
        itemId,
        groupName,
      ];
}
