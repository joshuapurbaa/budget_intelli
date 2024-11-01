import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/net_worth/domain/entities/asset_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AssetRepository {
  Future<Either<Failure, Unit>> insertAsset(AssetEntity asset);
  Future<Either<Failure, Unit>> updateAsset(AssetEntity asset);
  Future<Either<Failure, Unit>> deleteAsset(String id);
  Future<Either<Failure, List<AssetEntity>>> assets();
}
