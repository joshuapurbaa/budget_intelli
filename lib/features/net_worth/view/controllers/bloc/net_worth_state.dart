part of 'net_worth_bloc.dart';

@immutable
final class NetWorthState {
  const NetWorthState({
    required this.assets,
    required this.liabilities,
    this.loading = false,
    this.error = '',
    this.insertSuccess = false,
  });

  final List<AssetEntity> assets;
  final List<LiabilityEntity> liabilities;
  final bool loading;
  final String error;
  final bool insertSuccess;

  NetWorthState copyWith({
    List<AssetEntity>? assets,
    List<LiabilityEntity>? liabilities,
    bool? loading,
    String? error,
    bool? insertSuccess,
  }) {
    return NetWorthState(
      assets: assets ?? this.assets,
      liabilities: liabilities ?? this.liabilities,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      insertSuccess: insertSuccess ?? this.insertSuccess,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NetWorthState &&
        listEquals(other.assets, assets) &&
        listEquals(other.liabilities, liabilities) &&
        other.loading == loading &&
        other.error == error &&
        other.insertSuccess == insertSuccess;
  }

  @override
  int get hashCode =>
      assets.hashCode ^
      liabilities.hashCode ^
      loading.hashCode ^
      error.hashCode ^
      insertSuccess.hashCode;
}
