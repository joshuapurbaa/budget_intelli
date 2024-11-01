import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GroupCategoryFirestoreRepoImpl implements GroupCategoryFirestoreRepo {
  GroupCategoryFirestoreRepoImpl({required this.budgetFirestoreApi});

  final BudgetFirestoreApi budgetFirestoreApi;
  @override
  Future<Either<Failure, List<GroupCategory>>>
      getGroupCategoriesFirestore() async {
    try {
      final groupCategories = <GroupCategory>[];
      final list = await budgetFirestoreApi.getGroupCategoriesFirestore();

      for (final item in list) {
        groupCategories.add(
          GroupCategory(
            id: item.id,
            groupName: item.groupName,
            createdAt: item.createdAt,
            updatedAt: item.updatedAt,
            type: item.type,
            iconPath: item.iconPath,
            hexColor: item.hexColor,
          ),
        );
      }

      return right(groupCategories);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Failed get group category list: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> insertGroupCategoryFirestore(
    GroupCategory groupCategory,
  ) async {
    try {
      await budgetFirestoreApi.insertGroupCategoryFirestore(groupCategory);

      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Failed insert group category: ${e.message}'),
      );
    }
  }
}
