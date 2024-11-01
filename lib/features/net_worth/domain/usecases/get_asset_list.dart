import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/net_worth/domain/entities/asset_entity.dart';
import 'package:budget_intelli/features/net_worth/domain/repositories/asset_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAssetListUsecase implements UseCase<List<AssetEntity>, NoParams> {

  GetAssetListUsecase(this.repository);
  final AssetRepository repository;

  @override
  Future<Either<Failure, List<AssetEntity>>> call(NoParams params) {
    return repository.assets();
  }
}
