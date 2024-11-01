import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/net_worth/domain/entities/liability_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class LiabilityRepository {
  Future<Either<Failure, Unit>> insertLiability(
    LiabilityEntity liabilities,
  );
  Future<Either<Failure, Unit>> updateLiability(
    LiabilityEntity liabilities,
  );
  Future<Either<Failure, Unit>> deleteLiability(String id);
  Future<Either<Failure, List<LiabilityEntity>>> getLiabilityList();
}
