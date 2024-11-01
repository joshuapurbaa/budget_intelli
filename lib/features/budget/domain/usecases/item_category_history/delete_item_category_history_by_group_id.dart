import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class DeleteItemCategoryHistoryByGroupId implements UseCase<Unit, String> {
  DeleteItemCategoryHistoryByGroupId(this.repository);

  final ItemCategoryHistoryRepository repository;

  @override
  Future<Either<Failure, Unit>> call(String groupId) {
    return repository.deleteItemCategoryHistoryByGroupId(groupId: groupId);
  }
}
