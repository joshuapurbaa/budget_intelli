import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GroupCategoryRepositoryImpl implements GroupCategoryRepository {
  GroupCategoryRepositoryImpl({required this.localDataApi});

  final BudgetLocalApi localDataApi;
  @override
  Future<Either<Failure, List<GroupCategory>>> getGroupCategories() async {
    try {
      final groupCategories = <GroupCategory>[];
      final list = await localDataApi.getGroupCategories();

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
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> insertGroupCategory(
    GroupCategory groupCategory,
  ) async {
    try {
      await localDataApi.insertGroupCategory(
        groupCategory,
      );

      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updateGroupCategory(
    GroupCategory groupCategory,
  ) async {
    try {
      await localDataApi.updateGroupCategory(groupCategory);

      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }
}
