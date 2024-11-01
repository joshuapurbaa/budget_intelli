import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class UpdateGroupCategoryHistoryNoItemCategory implements UseCase<Unit, GroupCategoryHistory> {
  UpdateGroupCategoryHistoryNoItemCategory(this.repository);

  final GroupCategoryHistoryRepository repository;

  @override
  Future<Either<Failure, Unit>> call(GroupCategoryHistory groupCategory) {
    return repository.updateGroupCategoryHistoryNoItemCategory(groupCategory);
  }
}
