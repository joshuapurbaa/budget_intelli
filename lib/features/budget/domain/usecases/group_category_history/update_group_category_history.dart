import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class UpdateGroupCategoryHistoryUsecase implements UseCase<Unit, GroupCategoryHistory> {
  UpdateGroupCategoryHistoryUsecase(this.repository);

  final GroupCategoryHistoryRepository repository;

  @override
  Future<Either<Failure, Unit>> call(GroupCategoryHistory groupCategory) {
    return repository.updateGroupCategoryHistory(groupCategory);
  }
}
