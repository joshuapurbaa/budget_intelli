import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetGoalsHistoryFromDb
    implements UseCase<List<GoalHistoryModel>, NoParams> {
  GetGoalsHistoryFromDb(this.repository);
  final GoalHistoryRepository repository;

  @override
  Future<Either<Failure, List<GoalHistoryModel>>> call(NoParams params) {
    return repository.getGoalsHistory();
  }
}
