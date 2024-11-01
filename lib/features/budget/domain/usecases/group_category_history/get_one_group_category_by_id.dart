import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetGroupCategoryHistoryById
    implements UseCase<GroupCategoryHistory, String> {
  GetGroupCategoryHistoryById(this.repository);

  final GroupCategoryHistoryRepository repository;

  @override
  Future<Either<Failure, GroupCategoryHistory>> call(String id) {
    return repository.getGroupCategoryHistoryById(id);
  }
}
