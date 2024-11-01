import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetItemCategoryHistoriesByGroupId
    implements UseCase<List<ItemCategoryHistory>, String> {
  GetItemCategoryHistoriesByGroupId(this.repository);

  final ItemCategoryHistoryRepository repository;

  @override
  Future<Either<Failure, List<ItemCategoryHistory>>> call(String groupId) {
    return repository.getItemCategoryHistoriesByGroupId(groupId: groupId);
  }
}
