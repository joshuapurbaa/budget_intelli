import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/domain/repositories/group_category_repository.dart';
import 'package:budget_intelli/features/budget/models/group_category.dart';
import 'package:fpdart/fpdart.dart';

class InsertGroupCategoryUsecase implements UseCase<Unit, GroupCategory> {
  InsertGroupCategoryUsecase(this.repository);
  final GroupCategoryRepository repository;

  @override
  Future<Either<Failure, Unit>> call(GroupCategory params) {
    return repository.insertGroupCategory(params);
  }
}
