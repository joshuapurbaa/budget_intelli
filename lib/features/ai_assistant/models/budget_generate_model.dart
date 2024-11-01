import 'dart:convert';

import 'package:budget_intelli/core/core.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class BudgetGenerateModel {
  BudgetGenerateModel({
    required this.budgetName,
    required this.incomeAmount,
    required this.expense,
    required this.notes,
  });

  factory BudgetGenerateModel.fromGeneratedContent(
    GenerateContentResponse content,
  ) {
    assert(content.text != null, 'Content is null');

    final validJson = cleanJson(content.text!);

    final json = jsonDecode(validJson);

    if (json
        case {
          'budget_name': final String budgetName,
          'income_amount': final int incomeAmount,
          'expense': final List<dynamic> expense,
          'notes': final String notes,
        }) {
      return BudgetGenerateModel(
        budgetName: budgetName,
        incomeAmount: incomeAmount,
        expense: expense
            .map(
              (e) => ExpenseGroupGenerate.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        notes: notes,
      );
    }
    throw JsonUnsupportedObjectError(json);
  }

  final String budgetName;
  final int incomeAmount;
  final List<ExpenseGroupGenerate> expense;
  final String notes;

  Map<String, dynamic> toJson() {
    return {
      'budget_name': budgetName,
      'income_amount': incomeAmount,
      'expense': expense.map((e) => e.toJson()).toList(),
      'notes': notes,
    };
  }
}

class ExpenseGroupGenerate {
  ExpenseGroupGenerate({
    required this.groupName,
    required this.groupExplanation,
    required this.color,
    required this.itemCategories,
  });

  factory ExpenseGroupGenerate.fromJson(Map<String, dynamic> json) {
    return ExpenseGroupGenerate(
      groupName: json['group_name'] as String,
      groupExplanation: json['group_explanation'] as String,
      color: json['color'] as String,
      itemCategories: (json['item_categories'] as List).map((e) => ItemCategoryGenerate.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  String groupName;
  String groupExplanation;
  String color;
  List<ItemCategoryGenerate> itemCategories;

  Map<String, dynamic> toJson() {
    return {
      'group_name': groupName,
      'group_explanation': groupExplanation,
      'color': color,
      'item_categories': itemCategories.map((e) => e.toJson()).toList(),
    };
  }

  static int hexStringToInt(String hexString) {
    return int.parse(hexString.replaceFirst('0x', ''), radix: 16);
  }

  static String intToHexString(int value) {
    return '0x${value.toRadixString(16).toUpperCase().padLeft(6, '0')}';
  }
}

class ItemCategoryGenerate {
  ItemCategoryGenerate({
    required this.itemCategoryName,
    required this.amount,
  });

  factory ItemCategoryGenerate.fromJson(Map<String, dynamic> json) {
    return ItemCategoryGenerate(
      itemCategoryName: json['item_category_name'] as String,
      amount: json['amount'] as int,
    );
  }

  String itemCategoryName;
  int amount;

  Map<String, dynamic> toJson() {
    return {
      'item_category_name': itemCategoryName,
      'amount': amount,
    };
  }
}
