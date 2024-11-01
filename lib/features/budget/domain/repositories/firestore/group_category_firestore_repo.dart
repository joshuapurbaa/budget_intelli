import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class GroupCategoryFirestoreRepo {
  Future<Either<Failure, Unit>> insertGroupCategoryFirestore(
    GroupCategory groupCategory,
  );
  Future<Either<Failure, List<GroupCategory>>> getGroupCategoriesFirestore();
}
