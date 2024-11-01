import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class UpdateItemCategoryHistoryFirestore implements UseCase<Unit, ItemCategoryHistory> {
  UpdateItemCategoryHistoryFirestore(this.repository);

  final ItemCategoryHistoryFirestoreRepo repository;

  @override
  Future<Either<Failure, Unit>> call(ItemCategoryHistory itemCategoryHistory) {
    return repository.updateItemCategoryHistoryFirestore(itemCategoryHistory);
  }
}
