import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetItemCategoryHistoriesUsecase
    implements UseCase<List<ItemCategoryHistory>, NoParams> {
  GetItemCategoryHistoriesUsecase(this.repository);
  final ItemCategoryHistoryRepository repository;

  @override
  Future<Either<Failure, List<ItemCategoryHistory>>> call(
    NoParams params,
  ) async {
    return repository.getItemCategoryHistories();
  }
}
