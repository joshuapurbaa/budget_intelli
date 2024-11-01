import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetItemCategoryTransactionFromFirestore
    implements UseCase<List<ItemCategoryTransaction>, NoParams> {
  GetItemCategoryTransactionFromFirestore(this.repository);
  final ItemCategoryTransactionFirestoreRepo repository;

  @override
  Future<Either<Failure, List<ItemCategoryTransaction>>> call(NoParams params) {
    return repository.getItemCategoryTransactionsFirestore();
  }
}
