import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class InsertGroupCategoryToFirestore implements UseCase<Unit, GroupCategory> {
  InsertGroupCategoryToFirestore(this.repository);
  final GroupCategoryFirestoreRepo repository;

  @override
  Future<Either<Failure, Unit>> call(GroupCategory params) {
    return repository.insertGroupCategoryFirestore(params);
  }
}
