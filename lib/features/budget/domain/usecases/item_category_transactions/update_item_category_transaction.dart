import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class UpdateItemCategoryTransaction
    implements UseCase<Unit, ItemCategoryTransaction> {
  UpdateItemCategoryTransaction(this.repository);

  final ItemCategoryTransactionRepository repository;

  @override
  Future<Either<Failure, Unit>> call(
    ItemCategoryTransaction itemCategoryTransaction,
  ) {
    return repository.updateItemCategoryTransaction(
      itemCategoryTransaction,
    );
  }
}
