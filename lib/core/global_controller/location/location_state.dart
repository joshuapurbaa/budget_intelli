part of 'location_cubit.dart';

final class LocationState extends Equatable {
  const LocationState({
    this.loading = false,
    this.error,
    this.transactionLocation,
  });

  final bool loading;
  final String? error;
  final TransactionLocation? transactionLocation;

  LocationState copyWith({
    bool? loading,
    String? error,
    TransactionLocation? transactionLocation,
  }) {
    return LocationState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      transactionLocation: transactionLocation ?? this.transactionLocation,
    );
  }

  @override
  List<Object?> get props => [
        loading,
        error,
        transactionLocation,
      ];
}
