import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/domain/repositories/item_category_repository.dart';
import 'package:budget_intelli/features/budget/models/item_category.dart';
import 'package:fpdart/fpdart.dart';

class GetItemCategoriesUsecase
    implements UseCase<List<ItemCategory>, NoParams> {
  GetItemCategoriesUsecase(this.repository);
  final ItemCategoryRepository repository;

  @override
  Future<Either<Failure, List<ItemCategory>>> call(NoParams params) {
    return repository.getItemCategories();
  }
}
