import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetGroupCategoryHistoryFromFirestore
    implements UseCase<List<GroupCategoryHistory>, NoParams> {
  GetGroupCategoryHistoryFromFirestore(this.repository);

  final GroupCategoryHistoryFirestoreRepo repository;

  @override
  Future<Either<Failure, List<GroupCategoryHistory>>> call(
    NoParams noParams,
  ) async {
    return repository.getGroupCategoryHistoriesFirestore();
  }
}
