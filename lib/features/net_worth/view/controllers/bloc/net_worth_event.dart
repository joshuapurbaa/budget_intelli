part of 'net_worth_bloc.dart';

@immutable
sealed class NetWorthEvent {}

final class SetToInitial extends NetWorthEvent {}

final class GetAssetList extends NetWorthEvent {}

final class GetLiabilityList extends NetWorthEvent {}

final class AddAssetEvent extends NetWorthEvent {

  AddAssetEvent(this.assetEntity);
  final AssetEntity assetEntity;
}

final class AddLiabilityEvent extends NetWorthEvent {

  AddLiabilityEvent(this.liabilityEntity);
  final LiabilityEntity liabilityEntity;
}

final class UpdateAssetEvent extends NetWorthEvent {

  UpdateAssetEvent(this.assetEntity);
  final AssetEntity assetEntity;
}

final class UpdateLiabilityEvent extends NetWorthEvent {

  UpdateLiabilityEvent(this.liabilityEntity);
  final LiabilityEntity liabilityEntity;
}

final class DeleteAssetEvent extends NetWorthEvent {

  DeleteAssetEvent(this.id);
  final String id;
}

final class DeleteLiabilityEvent extends NetWorthEvent {

  DeleteLiabilityEvent(this.id);
  final String id;
}
