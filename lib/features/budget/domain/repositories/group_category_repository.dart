import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/models/group_category.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class GroupCategoryRepository {
  Future<Either<Failure, Unit>> insertGroupCategory(
    GroupCategory groupCategory,
  );
  Future<Either<Failure, List<GroupCategory>>> getGroupCategories();
  Future<Either<Failure, Unit>> updateGroupCategory(
    GroupCategory groupCategory,
  );
}
