import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/net_worth/domain/entities/asset_entity.dart';
import 'package:budget_intelli/features/net_worth/domain/repositories/asset_repository.dart';
import 'package:fpdart/fpdart.dart';

class InsertAssetUsecase implements UseCase<Unit, AssetEntity> {

  InsertAssetUsecase({
    required this.assetRepository,
  });
  final AssetRepository assetRepository;

  @override
  Future<Either<Failure, Unit>> call(AssetEntity asset) {
    return assetRepository.insertAsset(asset);
  }
}
