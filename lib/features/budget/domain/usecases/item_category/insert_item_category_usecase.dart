import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/domain/repositories/item_category_repository.dart';
import 'package:budget_intelli/features/budget/models/item_category.dart';
import 'package:fpdart/fpdart.dart';

class InsertItemCategoryUsecase implements UseCase<Unit, ItemCategory> {
  InsertItemCategoryUsecase(this.repository);
  final ItemCategoryRepository repository;

  @override
  Future<Either<Failure, Unit>> call(ItemCategory params) {
    return repository.insertItemCategory(params);
  }
}
