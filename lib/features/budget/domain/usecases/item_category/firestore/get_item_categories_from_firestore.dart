import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetItemCategoriesFromFirestore
    implements UseCase<List<ItemCategory>, NoParams> {
  GetItemCategoriesFromFirestore(this.repository);
  final ItemCategoryFirestoreRepo repository;

  @override
  Future<Either<Failure, List<ItemCategory>>> call(NoParams params) {
    return repository.getItemCategoriesFirestore();
  }
}
