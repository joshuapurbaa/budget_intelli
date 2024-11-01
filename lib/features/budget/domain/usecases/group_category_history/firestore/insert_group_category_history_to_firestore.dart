import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class InsertGroupCategoryHistoryToFirestore
    implements UseCase<Unit, GroupCategoryHistory> {
  InsertGroupCategoryHistoryToFirestore(this.repository);

  final GroupCategoryHistoryFirestoreRepo repository;

  @override
  Future<Either<Failure, Unit>> call(GroupCategoryHistory params) async {
    return repository.insertGroupCategoryHistoryFirestore(params);
  }
}
