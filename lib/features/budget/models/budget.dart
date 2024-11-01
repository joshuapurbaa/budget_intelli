import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/models/group_category_history.dart';

class Budget {
  Budget({
    required this.id,
    required this.budgetName,
    required this.createdAt,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.isMonthly,
    required this.isWeekly,
    required this.month,
    required this.year,
    required this.totalPlanIncome,
    required this.totalPlanExpense,
    this.totalActualIncome = 0,
    this.totalActualExpense = 0,
    this.groupCategories,
  });

  factory Budget.fromFirestore(
    DocumentSnapshotMap snapshot,
  ) {
    final data = snapshot.data();
    return Budget(
      id: data?['id'] as String? ?? '',
      budgetName: data?['budget_name'] as String? ?? '',
      createdAt: data?['created_at'] as String? ?? '',
      startDate: data?['start_date'] as String? ?? '',
      endDate: data?['end_date'] as String? ?? '',
      isActive: data?['is_active'] == 1,
      isMonthly: data?['is_monthly'] == 1,
      isWeekly: data?['is_weekly'] == 1,
      month: data?['month'] as int? ?? 0,
      year: data?['year'] as int? ?? 0,
      totalPlanIncome: data?['total_plan_income'] as int? ?? 0,
      totalPlanExpense: data?['total_plan_expense'] as int? ?? 0,
      totalActualIncome: data?['total_actual_income'] as int? ?? 0,
      totalActualExpense: data?['total_actual_expense'] as int? ?? 0,
    );
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    List<GroupCategoryHistory>? groupCategoriesList;
    if (json['group_category_history'] != null) {
      final groupCategoriesJson =
          json['group_category_history'] as List<dynamic>;
      groupCategoriesList = groupCategoriesJson
          .map(
            (categoryJson) => GroupCategoryHistory.fromJson(
              categoryJson as Map<String, dynamic>,
            ),
          )
          .toList();
    }
    return Budget(
      id: json['id'] as String,
      budgetName: json['budget_name'] as String,
      createdAt: json['created_at'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      isActive: json['is_active'] == 1,
      isMonthly: json['is_monthly'] == 1,
      isWeekly: json['is_weekly'] == 1,
      month: json['month'] as int,
      year: json['year'] as int,
      totalPlanIncome: json['total_plan_income'] as int,
      totalPlanExpense: json['total_plan_expense'] as int,
      totalActualIncome: json['total_actual_income'] as int,
      totalActualExpense: json['total_actual_expense'] as int,
      groupCategories: groupCategoriesList,
    );
  }

  final String id;
  final String budgetName;
  final String createdAt;
  final String startDate;
  final String endDate;
  final bool isActive;
  final bool isMonthly;
  final bool isWeekly;
  final int month;
  final int year;
  final int totalPlanIncome;
  final int totalPlanExpense;
  final int totalActualIncome;
  final int totalActualExpense;
  final List<GroupCategoryHistory>? groupCategories;

  Map<String, dynamic> toJson() => {
        'id': id,
        'budget_name': budgetName,
        'created_at': createdAt,
        'start_date': startDate,
        'end_date': endDate,
        'is_active': isActive ? 1 : 0,
        'is_monthly': isMonthly ? 1 : 0,
        'is_weekly': isWeekly ? 1 : 0,
        'month': month,
        'year': year,
        'total_plan_income': totalPlanIncome,
        'total_plan_expense': totalPlanExpense,
        'total_actual_income': totalActualIncome,
        'total_actual_expense': totalActualExpense,
        'group_category_history':
            groupCategories?.map((x) => x.toJson()).toList(),
      };

  Map<String, dynamic> toJsonDB() => {
        'id': id,
        'budget_name': budgetName,
        'created_at': createdAt,
        'start_date': startDate,
        'end_date': endDate,
        'is_active': isActive ? 1 : 0,
        'is_monthly': isMonthly ? 1 : 0,
        'is_weekly': isWeekly ? 1 : 0,
        'month': month,
        'year': year,
        'total_plan_income': totalPlanIncome,
        'total_plan_expense': totalPlanExpense,
        'total_actual_income': totalActualIncome,
        'total_actual_expense': totalActualExpense,
      };

  MapStringDynamic toFirestore() {
    return {
      'id': id,
      'budget_name': budgetName,
      'created_at': createdAt,
      'start_date': startDate,
      'end_date': endDate,
      'is_active': isActive ? 1 : 0,
      'is_monthly': isMonthly ? 1 : 0,
      'is_weekly': isWeekly ? 1 : 0,
      'month': month,
      'year': year,
      'total_plan_income': totalPlanIncome,
      'total_plan_expense': totalPlanExpense,
      'total_actual_income': totalActualIncome,
      'total_actual_expense': totalActualExpense,
    };
  }

  // copy with method
  Budget copyWith({
    String? id,
    String? budgetName,
    String? createdAt,
    String? startDate,
    String? endDate,
    bool? isActive,
    bool? isMonthly,
    bool? isWeekly,
    int? month,
    int? year,
    int? totalPlanIncome,
    int? totalPlanExpense,
    int? totalActualIncome,
    int? totalActualExpense,
    List<GroupCategoryHistory>? groupCategories,
  }) {
    return Budget(
      id: id ?? this.id,
      budgetName: budgetName ?? this.budgetName,
      createdAt: createdAt ?? this.createdAt,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      isMonthly: isMonthly ?? this.isMonthly,
      isWeekly: isWeekly ?? this.isWeekly,
      month: month ?? this.month,
      year: year ?? this.year,
      totalPlanIncome: totalPlanIncome ?? this.totalPlanIncome,
      totalPlanExpense: totalPlanExpense ?? this.totalPlanExpense,
      totalActualIncome: totalActualIncome ?? this.totalActualIncome,
      totalActualExpense: totalActualExpense ?? this.totalActualExpense,
      groupCategories: groupCategories ?? this.groupCategories,
    );
  }
}
