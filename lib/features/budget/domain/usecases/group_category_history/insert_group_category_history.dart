import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class InsertGroupCategoryHistoryUsecase
    implements UseCase<Unit, GroupCategoryHistory> {
  InsertGroupCategoryHistoryUsecase({
    required this.repository,
  });

  final GroupCategoryHistoryRepository repository;

  @override
  Future<Either<Failure, Unit>> call(GroupCategoryHistory params) async {
    return repository.insertGroupCategoryHistory(params);
  }
}
