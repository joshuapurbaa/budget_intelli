import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class InsertItemCategoryToFirestore implements UseCase<Unit, ItemCategory> {
  InsertItemCategoryToFirestore(this.repository);
  final ItemCategoryFirestoreRepo repository;

  @override
  Future<Either<Failure, Unit>> call(ItemCategory params) {
    return repository.insertItemCategoryFirestore(params);
  }
}
