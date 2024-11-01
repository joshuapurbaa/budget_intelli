import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ItemCategoryFirestoreRepo {
  Future<Either<Failure, Unit>> insertItemCategoryFirestore(
    ItemCategory itemCategory,
  );

  Future<Either<Failure, List<ItemCategory>>> getItemCategoriesFirestore();

  Future<Either<Failure, Unit>> updateItemCategoryFirestore(ItemCategory itemCategory);
}
