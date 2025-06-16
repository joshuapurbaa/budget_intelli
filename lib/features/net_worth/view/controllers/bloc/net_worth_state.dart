part of 'net_worth_bloc.dart';

final class NetWorthState extends Equatable {
  const NetWorthState({
    required this.assets,
    required this.liabilities,
    this.loading = false,
    this.error = '',
    this.insertSuccess = false,
    this.updateSuccess = false,
    this.deleteSuccess = false,
  });

  final List<AssetEntity> assets;
  final List<LiabilityEntity> liabilities;
  final bool loading;
  final String error;
  final bool insertSuccess;
  final bool updateSuccess;
  final bool deleteSuccess;
  NetWorthState copyWith({
    List<AssetEntity>? assets,
    List<LiabilityEntity>? liabilities,
    bool? loading,
    String? error,
    bool? insertSuccess,
    bool? updateSuccess,
    bool? deleteSuccess,
  }) {
    return NetWorthState(
      assets: assets ?? this.assets,
      liabilities: liabilities ?? this.liabilities,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      insertSuccess: insertSuccess ?? this.insertSuccess,
      updateSuccess: updateSuccess ?? this.updateSuccess,
      deleteSuccess: deleteSuccess ?? this.deleteSuccess,
    );
  }

  @override
  List<Object?> get props => [
        assets,
        liabilities,
        loading,
        error,
        insertSuccess,
        updateSuccess,
        deleteSuccess,
      ];
}
