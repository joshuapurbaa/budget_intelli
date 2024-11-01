import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'schedule_payment_db_event.dart';
part 'schedule_payment_db_state.dart';

class SchedulePaymentDbBloc
    extends Bloc<SchedulePaymentDbEvent, SchedulePaymentDbState> {
  SchedulePaymentDbBloc({
    required InsertSchedulePaymentDb insertSchedulePaymentDb,
    required GetSchedulePaymentDbById getSchedulePaymentById,
    required GetSchedulePaymentsDb getSchedulePaymentDb,
    required GetRepetitionListBySchedulePaymentId
        getRepetitionListBySchedulePaymentId,
    required InsertRepetitionsToDb insertRepetitionsToDb,
    required UpdateRepetitionById updatedRepetitionById,
    required UpdateSchedulePaymentDb updateSchedulePaymentDb,
  })  : _insertSchedulePaymentDb = insertSchedulePaymentDb,
        _getSchedulePaymentDbById = getSchedulePaymentById,
        _getSchedulePaymentsDb = getSchedulePaymentDb,
        _getRepetitionListBySchedulePaymentId =
            getRepetitionListBySchedulePaymentId,
        _insertRepetitionsToDb = insertRepetitionsToDb,
        _updateRepetitionById = updatedRepetitionById,
        _updateSchedulePaymentDb = updateSchedulePaymentDb,
        super(
          const SchedulePaymentDbState(),
        ) {
    on<InsertSchedulePaymentToDb>(_onInsertSchedulePaymentToDb);
    on<GetSchedulePaymentByIdFromDb>(_onGetSchedulePaymentByIdFromDb);
    on<GetSchedulePaymentsFromDb>(_onGetSchedulePaymentsFromDb);
    on<ResetStatePaymentDbBloc>(_onResetStatePaymentDbBloc);
    on<GetRepetitionListBySchedulePaymentIdEvent>(
      _onGetRepetitionListBySchedulePaymentIdEvent,
    );

    on<InsertRepetitionsEvent>(_onInsertRepetitionsEvent);
    on<UpdateRepetitionByIdEvent>(_onUpdateRepetitionByIdEvent);
    on<UpdateSchedulePaymentDbEvent>(_onUpdateSchedulePaymentDbEvent);
  }

  final InsertSchedulePaymentDb _insertSchedulePaymentDb;
  final GetSchedulePaymentDbById _getSchedulePaymentDbById;
  final GetSchedulePaymentsDb _getSchedulePaymentsDb;
  final GetRepetitionListBySchedulePaymentId
      _getRepetitionListBySchedulePaymentId;

  final InsertRepetitionsToDb _insertRepetitionsToDb;
  final UpdateRepetitionById _updateRepetitionById;
  final UpdateSchedulePaymentDb _updateSchedulePaymentDb;

  void _onResetStatePaymentDbBloc(
    ResetStatePaymentDbBloc event,
    Emitter<SchedulePaymentDbState> emit,
  ) {
    emit(
      state.copyWith(
        insertSchedulePaymentSuccess: false,
        updateRepetitionSuccess: false,
        getSchedulePaymentSuccess: false,
      ),
    );
  }

  Future<void> _onInsertSchedulePaymentToDb(
    InsertSchedulePaymentToDb event,
    Emitter<SchedulePaymentDbState> emit,
  ) async {
    final result = await _insertSchedulePaymentDb(event.schedulePayment);

    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessageSchedulePayment: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          insertSchedulePaymentSuccess: true,
          schedulePaymentId: event.schedulePayment.id,
        ),
      ),
    );
  }

  Future<void> _onGetSchedulePaymentByIdFromDb(
    GetSchedulePaymentByIdFromDb event,
    Emitter<SchedulePaymentDbState> emit,
  ) async {
    final result = await _getSchedulePaymentDbById(event.id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessageSchedulePayment: failure.message,
        ),
      ),
      (schedulePayment) => emit(
        state.copyWith(
          getSchedulePaymentSuccess: true,
          schedulePayment: schedulePayment,
        ),
      ),
    );
  }

  Future<void> _onGetSchedulePaymentsFromDb(
    GetSchedulePaymentsFromDb event,
    Emitter<SchedulePaymentDbState> emit,
  ) async {
    final result = await _getSchedulePaymentsDb(NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessageSchedulePayment: failure.message,
        ),
      ),
      (schedulePayments) => emit(
        state.copyWith(
          getSchedulePaymentSuccess: true,
          schedulePayments: schedulePayments,
        ),
      ),
    );
  }

  Future<void> _onGetRepetitionListBySchedulePaymentIdEvent(
    GetRepetitionListBySchedulePaymentIdEvent event,
    Emitter<SchedulePaymentDbState> emit,
  ) async {
    final result = await _getRepetitionListBySchedulePaymentId(
      event.schedulePaymentId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessageRepetition: failure.message,
        ),
      ),
      (reps) => emit(
        state.copyWith(
          getRepetitionSuccess: true,
          repetitions: reps,
        ),
      ),
    );
  }

  Future<void> _onInsertRepetitionsEvent(
    InsertRepetitionsEvent event,
    Emitter<SchedulePaymentDbState> emit,
  ) async {
    final result = await _insertRepetitionsToDb(
      event.repetitions,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessageRepetition: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          insertRepetitionsSuccess: true,
        ),
      ),
    );
  }

  Future<void> _onUpdateRepetitionByIdEvent(
    UpdateRepetitionByIdEvent event,
    Emitter<SchedulePaymentDbState> emit,
  ) async {
    final result = await _updateRepetitionById(event.repetition);

    result.fold(
      (failure) => emit(
        state.copyWith(
          updateRepetitionSuccess: false,
          errorMessageRepetition: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          updateRepetitionSuccess: true,
        ),
      ),
    );
  }

  Future<void> _onUpdateSchedulePaymentDbEvent(
    UpdateSchedulePaymentDbEvent event,
    Emitter<SchedulePaymentDbState> emit,
  ) async {
    final result = await _updateSchedulePaymentDb(event.scheduluPayment);

    result.fold(
      (failure) => emit(
        state.copyWith(
          updateSchedulePaymentSuccess: false,
        ),
      ),
      (_) => emit(
        state.copyWith(
          updateSchedulePaymentSuccess: true,
        ),
      ),
    );
  }
}
