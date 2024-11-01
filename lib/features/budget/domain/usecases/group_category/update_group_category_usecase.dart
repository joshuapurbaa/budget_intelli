import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/domain/repositories/group_category_repository.dart';
import 'package:budget_intelli/features/budget/models/group_category.dart';
import 'package:fpdart/fpdart.dart';

class UpdateGroupCategoryUsecase implements UseCase<Unit, GroupCategory> {
  UpdateGroupCategoryUsecase(this.repository);
  final GroupCategoryRepository repository;

  @override
  Future<Either<Failure, Unit>> call(GroupCategory params) {
    return repository.updateGroupCategory(params);
  }
}
