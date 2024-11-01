import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetGroupCategoryHistoriesUsecase
    implements UseCase<List<GroupCategoryHistory>, NoParams> {
  GetGroupCategoryHistoriesUsecase({required this.repository});

  final GroupCategoryHistoryRepository repository;

  @override
  Future<Either<Failure, List<GroupCategoryHistory>>> call(
    NoParams noParams,
  ) async {
    return repository.getGroupCategoryHistories();
  }
}
