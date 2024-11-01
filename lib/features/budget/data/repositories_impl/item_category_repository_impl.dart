import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class ItemCategoryRepositoryImpl implements ItemCategoryRepository {
  ItemCategoryRepositoryImpl({
    required this.localDataApi,
  });

  final BudgetLocalApi localDataApi;

  @override
  Future<Either<Failure, List<ItemCategory>>> getItemCategories() async {
    try {
      final itemCategories = <ItemCategory>[];
      final list = await localDataApi.getItemCategories();

      for (final item in list) {
        itemCategories.add(
          ItemCategory(
            id: item.id,
            categoryName: item.categoryName,
            createdAt: item.createdAt,
            updatedAt: item.updatedAt,
            type: item.type,
            iconPath: item.iconPath,
            hexColor: item.hexColor,
          ),
        );
      }

      return right(itemCategories);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> insertItemCategory(
    ItemCategory itemCategory,
  ) async {
    try {
      await localDataApi.insertItemCategory(itemCategory);

      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItemCategory(
    ItemCategory itemCategory,
  ) async {
    try {
      await localDataApi.updateItemCategory(itemCategory);

      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }
}
