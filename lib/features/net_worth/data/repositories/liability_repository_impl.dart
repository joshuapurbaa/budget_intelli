import 'package:budget_intelli/core/error/failures.dart';
import 'package:budget_intelli/features/net_worth/net_worth_barrel.dart';

import 'package:fpdart/fpdart.dart';

class LiabilityRepositoryImpl implements LiabilityRepository {
  LiabilityRepositoryImpl({required this.netWorthLocalApi});

  final NetWorthLocalApi netWorthLocalApi;

  @override
  Future<Either<Failure, Unit>> deleteLiability(String id) async {
    try {
      await netWorthLocalApi.deleteLiability(id);
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LiabilityEntity>>> getLiabilityList() async {
    try {
      final liabilityList = <LiabilityEntity>[];
      final liabilities = await netWorthLocalApi.liabilities();
      for (final liability in liabilities) {
        liabilityList.add(
          LiabilityEntity(
            id: liability.id,
            name: liability.name,
            amount: liability.amount,
            createdAt: liability.createdAt,
            updatedAt: liability.updatedAt,
            description: liability.description,
          ),
        );
      }
      return right(liabilityList);
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> insertLiability(
      LiabilityEntity liabilities,) async {
    try {
      await netWorthLocalApi.insertLiability(
        LiabilityModel(
          id: liabilities.id,
          name: liabilities.name,
          amount: liabilities.amount,
          createdAt: liabilities.createdAt,
          updatedAt: liabilities.updatedAt,
          description: liabilities.description,
        ),
      );
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateLiability(
      LiabilityEntity liabilities,) async {
    try {
      await netWorthLocalApi.updateLiability(
        LiabilityModel(
          id: liabilities.id,
          name: liabilities.name,
          amount: liabilities.amount,
          createdAt: liabilities.createdAt,
          updatedAt: liabilities.updatedAt,
          description: liabilities.description,
        ),
      );
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }
}
