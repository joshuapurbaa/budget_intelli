import 'package:budget_intelli/core/error/failures.dart';
import 'package:budget_intelli/features/net_worth/net_worth_barrel.dart';

import 'package:fpdart/fpdart.dart';

class AssetRepositoryImpl implements AssetRepository {
  AssetRepositoryImpl({required this.netWorthLocalApi});

  final NetWorthLocalApi netWorthLocalApi;

  @override
  Future<Either<Failure, List<AssetEntity>>> assets() async {
    try {
      final assetList = <AssetEntity>[];
      final assets = await netWorthLocalApi.assets();
      for (final asset in assets) {
        assetList.add(
          AssetEntity(
            id: asset.id,
            name: asset.name,
            amount: asset.amount,
            createdAt: asset.createdAt,
            updatedAt: asset.updatedAt,
            description: asset.description,
          ),
        );
      }
      return right(assetList);
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAsset(String id) async {
    try {
      await netWorthLocalApi.deleteAsset(id);
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> insertAsset(AssetEntity asset) async {
    try {
      await netWorthLocalApi.insertAsset(
        AssetModel(
          id: asset.id,
          name: asset.name,
          amount: asset.amount,
          createdAt: asset.createdAt,
          updatedAt: asset.updatedAt,
          description: asset.description,
        ),
      );
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateAsset(AssetEntity asset) async {
    try {
      await netWorthLocalApi.updateAsset(
        AssetModel(
          id: asset.id,
          name: asset.name,
          amount: asset.amount,
          createdAt: asset.createdAt,
          updatedAt: asset.updatedAt,
          description: asset.description,
        ),
      );
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }
}
