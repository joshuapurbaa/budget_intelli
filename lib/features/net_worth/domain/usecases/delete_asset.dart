import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/net_worth/domain/repositories/asset_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteAssetUsecase implements UseCase<Unit, String> {
  DeleteAssetUsecase({
    required this.assetRepository,
  });
  final AssetRepository assetRepository;

  @override
  Future<Either<Failure, Unit>> call(String id) {
    return assetRepository.deleteAsset(id);
  }
}
