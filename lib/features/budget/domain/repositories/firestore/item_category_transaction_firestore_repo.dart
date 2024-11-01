import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ItemCategoryTransactionFirestoreRepo {
  Future<Either<Failure, Unit>> insertItemCategoryTransactionFirestore(
    ItemCategoryTransaction itemCategoryTransaction,
  );
  Future<Either<Failure, List<ItemCategoryTransaction>>>
      getItemCategoryTransactionsFirestore();
}
