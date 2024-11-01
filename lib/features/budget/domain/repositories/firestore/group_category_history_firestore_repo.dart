import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class GroupCategoryHistoryFirestoreRepo {
  Future<Either<Failure, Unit>> insertGroupCategoryHistoryFirestore(
    GroupCategoryHistory groupCategoryHistory,
  );
  Future<Either<Failure, List<GroupCategoryHistory>>>
      getGroupCategoryHistoriesFirestore();
}
