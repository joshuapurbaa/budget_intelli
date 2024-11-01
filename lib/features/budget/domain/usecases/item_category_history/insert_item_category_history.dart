import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class InsertItemCategoryHistoriesUsecase
    implements UseCase<Unit, ItemCategoryHistory> {
  InsertItemCategoryHistoriesUsecase({required this.repository});

  final ItemCategoryHistoryRepository repository;

  @override
  Future<Either<Failure, Unit>> call(ItemCategoryHistory params) async {
    return repository.insertItemCategoryHistories(params);
  }
}
