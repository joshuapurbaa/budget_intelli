import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetAllItemCategoryTransactions
    implements UseCase<List<ItemCategoryTransaction>, NoParams> {
  GetAllItemCategoryTransactions(this.repository);
  final ItemCategoryTransactionRepository repository;

  @override
  Future<Either<Failure, List<ItemCategoryTransaction>>> call(NoParams params) {
    return repository.getAllItemCategoryTransactions();
  }
}
