import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/domain/repositories/group_category_repository.dart';
import 'package:budget_intelli/features/budget/models/group_category.dart';
import 'package:fpdart/fpdart.dart';

class GetGroupCategoriesUsecase
    implements UseCase<List<GroupCategory>, NoParams> {
  GetGroupCategoriesUsecase(this.repository);
  final GroupCategoryRepository repository;

  @override
  Future<Either<Failure, List<GroupCategory>>> call(NoParams params) {
    return repository.getGroupCategories();
  }
}
