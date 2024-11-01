import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/models/item_category.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ItemCategoryRepository {
  Future<Either<Failure, Unit>> insertItemCategory(
    ItemCategory itemCategory,
  );
  Future<Either<Failure, List<ItemCategory>>> getItemCategories();
  Future<Either<Failure, Unit>> updateItemCategory(
    ItemCategory itemCategory,
  );
}
