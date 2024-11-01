import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/domain/repositories/item_category_repository.dart';
import 'package:budget_intelli/features/budget/models/item_category.dart';
import 'package:fpdart/fpdart.dart';

class UpdateItemCategoryUsecase implements UseCase<Unit, ItemCategory> {
  UpdateItemCategoryUsecase(this.repository);
  final ItemCategoryRepository repository;

  @override
  Future<Either<Failure, Unit>> call(ItemCategory params) {
    return repository.updateItemCategory(params);
  }
}
