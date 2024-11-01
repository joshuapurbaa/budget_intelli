import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class InsertItemCategoryTransaction
    implements UseCase<Unit, ItemCategoryTransaction> {
  InsertItemCategoryTransaction(this.repository);

  final ItemCategoryTransactionRepository repository;

  @override
  Future<Either<Failure, Unit>> call(ItemCategoryTransaction params) {
    return repository.insertItemCategoryTransaction(params);
  }
}
