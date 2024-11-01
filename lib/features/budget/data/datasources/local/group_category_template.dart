import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:uuid/uuid.dart';

class BudgetTemplate {
  static List<GroupCategoryHistory> groupCategoryCustomEN() {
    final groupIdIncome = const Uuid().v1();
    final groupFixedExpense = const Uuid().v1();
    final groupFlexibleExpense = const Uuid().v1();

    return [
      GroupCategoryHistory(
        id: groupIdIncome,
        groupName: 'Income',
        type: AppStrings.incomeType,
        groupId: const Uuid().v1(),
        createdAt: DateTime.now().toString(),
        // hexColor green,
        hexColor: 0xFF4CAF50,
        itemCategoryHistories: [
          ItemCategoryHistory(
            id: const Uuid().v1(),
            name: 'Salary',
            groupHistoryId: groupIdIncome,
            itemId: const Uuid().v1(),
            type: AppStrings.incomeType,
            createdAt: DateTime.now().toString(),
            isExpense: false,
            groupName: 'Income',
          ),
        ],
      ),
      GroupCategoryHistory(
        id: groupFixedExpense,
        groupName: 'Fixed Expense',
        type: 'expense',
        groupId: const Uuid().v1(),
        createdAt: DateTime.now().toString(),
        hexColor: 0xFFF44336,
        itemCategoryHistories: [
          ItemCategoryHistory(
            id: const Uuid().v1(),
            name: 'Rent',
            groupHistoryId: groupFixedExpense,
            itemId: const Uuid().v1(),
            type: 'expense',
            createdAt: DateTime.now().toString(),
            isExpense: true,
            groupName: 'Fixed Expense',
          ),
          ItemCategoryHistory(
            id: const Uuid().v1(),
            name: 'Electricity',
            groupHistoryId: groupFixedExpense,
            itemId: const Uuid().v1(),
            type: 'expense',
            createdAt: DateTime.now().toString(),
            isExpense: true,
            groupName: 'Fixed Expense',
          ),
          ItemCategoryHistory(
            id: const Uuid().v1(),
            name: 'Internet',
            groupHistoryId: groupFixedExpense,
            itemId: const Uuid().v1(),
            type: 'expense',
            createdAt: DateTime.now().toString(),
            isExpense: true,
            groupName: 'Fixed Expense',
          ),
          ItemCategoryHistory(
            id: const Uuid().v1(),
            name: 'Subscription',
            groupHistoryId: groupFixedExpense,
            itemId: const Uuid().v1(),
            type: 'expense',
            createdAt: DateTime.now().toString(),
            isExpense: true,
            groupName: 'Fixed Expense',
          ),
        ],
      ),
      GroupCategoryHistory(
        id: groupFlexibleExpense,
        groupName: 'Flexible Expense',
        type: 'expense',
        groupId: const Uuid().v1(),
        createdAt: DateTime.now().toString(),
        hexColor: 0xFF2196F3,
        itemCategoryHistories: [
          ItemCategoryHistory(
            id: const Uuid().v1(),
            name: 'Groceries',
            groupHistoryId: groupFlexibleExpense,
            itemId: const Uuid().v1(),
            type: 'expense',
            createdAt: DateTime.now().toString(),
            isExpense: true,
            groupName: 'Flexible Expense',
          ),
          ItemCategoryHistory(
            id: const Uuid().v1(),
            name: 'Eating Out',
            groupHistoryId: groupFlexibleExpense,
            itemId: const Uuid().v1(),
            type: 'expense',
            createdAt: DateTime.now().toString(),
            isExpense: true,
            groupName: 'Flexible Expense',
          ),
          ItemCategoryHistory(
            id: const Uuid().v1(),
            name: 'Entertainment',
            groupHistoryId: groupFlexibleExpense,
            itemId: const Uuid().v1(),
            type: 'expense',
            createdAt: DateTime.now().toString(),
            isExpense: true,
            groupName: 'Flexible Expense',
          ),
          ItemCategoryHistory(
            id: const Uuid().v1(),
            name: 'Fashion',
            groupHistoryId: groupFlexibleExpense,
            itemId: const Uuid().v1(),
            type: 'expense',
            createdAt: DateTime.now().toString(),
            isExpense: true,
            groupName: 'Flexible Expense',
          ),
        ],
      ),
    ];
  }

  static List<GroupCategoryHistory> groupCategoryCustomID() {
    final groupIdIncome = const Uuid().v1();
    final groupFixedExpense = const Uuid().v1();
    final groupFlexibleExpense = const Uuid().v1();

    return [
      GroupCategoryHistory(
        id: groupIdIncome,
        groupName: 'Pendapatan',
        groupId: const Uuid().v1(),
        type: AppStrings.incomeType,
        createdAt: DateTime.now().toString(),
        hexColor: 0xFF4CAF50,
        itemCategoryHistories: [
          ItemCategoryHistory(
            id: const Uuid().v1(),
            name: 'Gaji',
            groupHistoryId: groupIdIncome,
            itemId: const Uuid().v1(),
            type: AppStrings.incomeType,
            createdAt: DateTime.now().toString(),
            isExpense: false,
            groupName: 'Pendapatan',
          ),
        ],
      ),
      GroupCategoryHistory(
        id: groupFixedExpense,
        groupId: const Uuid().v1(),
        groupName: 'Pengeluaran Tetap',
        type: 'expense',
        createdAt: DateTime.now().toString(),
        hexColor: 0xFFF44336,
        itemCategoryHistories: [
          ItemCategoryHistory(
            id: const Uuid().v1(),
            name: 'Sewa',
            groupHistoryId: groupFixedExpense,
            itemId: const Uuid().v1(),
            type: 'expense',
            createdAt: DateTime.now().toString(),
            isExpense: true,
            groupName: 'Pengeluaran Tetap',
          ),
          ItemCategoryHistory(
            id: const Uuid().v1(),
            name: 'Listrik',
            groupHistoryId: groupFixedExpense,
            itemId: const Uuid().v1(),
            type: 'expense',
            createdAt: DateTime.now().toString(),
            isExpense: true,
            groupName: 'Pengeluaran Tetap',
          ),
          ItemCategoryHistory(
            id: const Uuid().v1(),
            name: 'Internet',
            groupHistoryId: groupFixedExpense,
            itemId: const Uuid().v1(),
            type: 'expense',
            createdAt: DateTime.now().toString(),
            isExpense: true,
            groupName: 'Pengeluaran Tetap',
          ),
          ItemCategoryHistory(
            id: const Uuid().v1(),
            name: 'Langganan',
            groupHistoryId: groupFixedExpense,
            itemId: const Uuid().v1(),
            type: 'expense',
            createdAt: DateTime.now().toString(),
            isExpense: true,
            groupName: 'Pengeluaran Tetap',
          ),
        ],
      ),
      GroupCategoryHistory(
        id: groupFlexibleExpense,
        groupId: const Uuid().v1(),
        groupName: 'Pengeluaran Fleksibel',
        type: 'expense',
        createdAt: DateTime.now().toString(),
        hexColor: 0xFF2196F3,
        itemCategoryHistories: [
          ItemCategoryHistory(
            id: const Uuid().v1(),
            name: 'Belanja',
            groupHistoryId: groupFlexibleExpense,
            itemId: const Uuid().v1(),
            type: 'expense',
            createdAt: DateTime.now().toString(),
            isExpense: true,
            groupName: 'Pengeluaran Fleksibel',
          ),
          ItemCategoryHistory(
            id: const Uuid().v1(),
            name: 'Makan di Luar',
            groupHistoryId: groupFlexibleExpense,
            itemId: const Uuid().v1(),
            type: 'expense',
            createdAt: DateTime.now().toString(),
            isExpense: true,
            groupName: 'Pengeluaran Fleksibel',
          ),
          ItemCategoryHistory(
            id: const Uuid().v1(),
            name: 'Hiburan',
            groupHistoryId: groupFlexibleExpense,
            itemId: const Uuid().v1(),
            type: 'expense',
            createdAt: DateTime.now().toString(),
            isExpense: true,
            groupName: 'Pengeluaran Fleksibel',
          ),
          ItemCategoryHistory(
            id: const Uuid().v1(),
            name: 'Fashion',
            groupHistoryId: groupFlexibleExpense,
            itemId: const Uuid().v1(),
            type: 'expense',
            createdAt: DateTime.now().toString(),
            isExpense: true,
            groupName: 'Pengeluaran Fleksibel',
          ),
        ],
      ),
    ];
  }
}
