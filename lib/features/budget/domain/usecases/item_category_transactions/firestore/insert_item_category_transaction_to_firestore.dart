import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class InsertItemCategoryTransactionToFirestore
    implements UseCase<Unit, ItemCategoryTransaction> {
  InsertItemCategoryTransactionToFirestore(this.repository);

  final ItemCategoryTransactionFirestoreRepo repository;

  @override
  Future<Either<Failure, Unit>> call(ItemCategoryTransaction params) {
    return repository.insertItemCategoryTransactionFirestore(params);
  }
}
