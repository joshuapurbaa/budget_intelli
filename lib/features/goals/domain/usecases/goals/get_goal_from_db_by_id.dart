import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetGoalFromDbById implements UseCase<GoalModel?, String> {
  GetGoalFromDbById(this.repository);

  final GoalRepository repository;

  @override
  Future<Either<Failure, GoalModel?>> call(String params) {
    return repository.getGoalById(params);
  }
}
