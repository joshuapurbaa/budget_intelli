import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class DeleteItemCategoryHistoryFirestore implements UseCase<Unit, String> {
  DeleteItemCategoryHistoryFirestore(this.repository);

  final ItemCategoryHistoryFirestoreRepo repository;

  @override
  Future<Either<Failure, Unit>> call(String id) {
    return repository.deleteItemCategoryHistoryFirestore(id);
  }
}
