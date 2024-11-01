import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetGroupCategoriesFromFirestore
    implements UseCase<List<GroupCategory>, NoParams> {
  GetGroupCategoriesFromFirestore(this.repository);
  final GroupCategoryFirestoreRepo repository;

  @override
  Future<Either<Failure, List<GroupCategory>>> call(NoParams params) {
    return repository.getGroupCategoriesFirestore();
  }
}
