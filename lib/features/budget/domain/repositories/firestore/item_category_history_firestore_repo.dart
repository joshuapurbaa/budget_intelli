import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ItemCategoryHistoryFirestoreRepo {
  Future<Either<Failure, Unit>> insertItemCategoryHistoryFirestore(
    ItemCategoryHistory itemCategoryHistory,
  );

  Future<Either<Failure, List<ItemCategoryHistory>>> getItemCategoryHistoriesFirestore();

  Future<Either<Failure, Unit>> updateItemCategoryHistoryFirestore(ItemCategoryHistory itemCategoryHistory);

  Future<Either<Failure, Unit>> deleteItemCategoryHistoryFirestore(String id);
}
