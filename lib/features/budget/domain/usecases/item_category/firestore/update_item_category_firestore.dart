import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class UpdateItemCategoryFirestore implements UseCase<Unit, ItemCategory> {
  UpdateItemCategoryFirestore(this.repository);

  final ItemCategoryFirestoreRepo repository;

  @override
  Future<Either<Failure, Unit>> call(ItemCategory itemCategory) {
    return repository.updateItemCategoryFirestore(itemCategory);
  }
}
