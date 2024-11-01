import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class InsertItemCategoryHistoryToFirestore
    implements UseCase<Unit, ItemCategoryHistory> {
  InsertItemCategoryHistoryToFirestore(this.repository);

  final ItemCategoryHistoryFirestoreRepo repository;

  @override
  Future<Either<Failure, Unit>> call(ItemCategoryHistory params) async {
    return repository.insertItemCategoryHistoryFirestore(params);
  }
}
