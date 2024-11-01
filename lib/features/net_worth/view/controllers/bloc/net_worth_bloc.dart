import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/net_worth/net_worth_barrel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'net_worth_event.dart';
part 'net_worth_state.dart';

class NetWorthBloc extends Bloc<NetWorthEvent, NetWorthState> {
  NetWorthBloc({
    required InsertAssetUsecase insertAsset,
    required InsertLiabilityUsecase insertLiabilities,
    required GetAssetListUsecase getAssetList,
    required GetLiabilityListUsecase getLiabilityList,
  })  : _insertAsset = insertAsset,
        _insertLiabilities = insertLiabilities,
        _getAssetList = getAssetList,
        _getLiabilityList = getLiabilityList,
        super(
          const NetWorthState(
            assets: [],
            liabilities: [],
          ),
        ) {
    on<AddAssetEvent>(_insertAssetEvent);
    on<AddLiabilityEvent>(_insertLiabilityEvent);
    on<GetAssetList>(_getAssetListEvent);
    on<GetLiabilityList>(_getLiabilityListEvent);
    on<SetToInitial>(_setToInitialState);
  }

  final InsertAssetUsecase _insertAsset;
  final InsertLiabilityUsecase _insertLiabilities;
  final GetAssetListUsecase _getAssetList;
  final GetLiabilityListUsecase _getLiabilityList;

  void _setToInitialState(
    SetToInitial event,
    Emitter<NetWorthState> emit,
  ) {
    emit(
      state.copyWith(
        error: '',
        insertSuccess: false,
        loading: false,
      ),
    );
  }

  Future<void> _insertAssetEvent(
    AddAssetEvent event,
    Emitter<NetWorthState> emit,
  ) async {
    final result = await _insertAsset(event.assetEntity);

    result.fold(
      (failure) => emit(
        state.copyWith(
          error: failure.message,
          insertSuccess: false,
        ),
      ),
      (_) => emit(
        state.copyWith(
          insertSuccess: true,
        ),
      ),
    );
  }

  Future<void> _insertLiabilityEvent(
    AddLiabilityEvent event,
    Emitter<NetWorthState> emit,
  ) async {
    final result = await _insertLiabilities(event.liabilityEntity);

    result.fold(
      (failure) => emit(
        state.copyWith(
          error: failure.message,
          insertSuccess: false,
        ),
      ),
      (_) => emit(
        state.copyWith(
          insertSuccess: true,
        ),
      ),
    );
  }

  Future<void> _getAssetListEvent(
    GetAssetList event,
    Emitter<NetWorthState> emit,
  ) async {
    final result = await _getAssetList(NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(error: failure.message),
      ),
      (assets) => emit(state.copyWith(assets: assets)),
    );
  }

  Future<void> _getLiabilityListEvent(
    GetLiabilityList event,
    Emitter<NetWorthState> emit,
  ) async {
    final result = await _getLiabilityList(NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(error: failure.message),
      ),
      (liabilities) => emit(state.copyWith(liabilities: liabilities)),
    );
  }
}
