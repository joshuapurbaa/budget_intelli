import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/net_worth/domain/entities/asset_entity.dart';
import 'package:budget_intelli/features/net_worth/domain/repositories/asset_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateAsset implements UseCase<Unit, AssetEntity> {

  UpdateAsset({
    required this.assetRepository,
  });
  final AssetRepository assetRepository;

  @override
  Future<Either<Failure, Unit>> call(AssetEntity asset) {
    return assetRepository.updateAsset(asset);
  }
}
