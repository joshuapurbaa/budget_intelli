import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class DeleteItemCategoryTransactionByItemId implements UseCase<Unit, String> {
  DeleteItemCategoryTransactionByItemId(this.repository);

  final ItemCategoryTransactionRepository repository;

  @override
  Future<Either<Failure, Unit>> call(String itemId) {
    return repository.deleteItemCategoryTransactionByItemId(itemId);
  }
}
