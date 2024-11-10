import 'dart:async';

import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/member/member_barrel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'member_db_event.dart';
part 'member_db_state.dart';

class MemberDbBloc extends Bloc<MemberDbEvent, MemberDbState> {
  MemberDbBloc({
    required InsertMemberDb insertMemberDb,
    required UpdateMemberDb updateMemberDb,
    required DeleteMemberDb deleteMemberDb,
    required GetAllMemberDb getAllMemberDb,
    required GetMemberByIdDb getMemberByIdDb,
  })  : _insertMemberDb = insertMemberDb,
        _updateMemberDb = updateMemberDb,
        _deleteMemberDb = deleteMemberDb,
        _getAllMemberDb = getAllMemberDb,
        _getMemberByIdDb = getMemberByIdDb,
        super(const MemberDbState()) {
    on<InsertMemberDbEvent>(_onInsertMemberDbEvent);
    on<UpdateMemberDbEvent>(_onUpdateMemberDbEvent);
    on<DeleteMemberDbEvent>(_onDeleteMemberDbEvent);
    on<GetMemberDbEvent>(_onGetMemberDbEvent);
    on<GetAllMemberDbEvent>(_onGetAllMemberDbEvent);
    on<ResetMemberDbEventStateEvent>(_onResetMemberDbEventStateEvent);
    on<SelectMemberDbEvent>(_onSelectMemberDbEvent);
  }

  final InsertMemberDb _insertMemberDb;
  final UpdateMemberDb _updateMemberDb;
  final DeleteMemberDb _deleteMemberDb;
  final GetAllMemberDb _getAllMemberDb;
  final GetMemberByIdDb _getMemberByIdDb;

  Future<void> _onInsertMemberDbEvent(
    InsertMemberDbEvent event,
    Emitter<MemberDbState> emit,
  ) async {
    final result = await _insertMemberDb(event.entity);

    result.fold(
      (fail) => emit(
        state.copyWith(
          insertSuccess: false,
          errorMessage: fail.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          insertSuccess: true,
        ),
      ),
    );
  }

  Future<void> _onUpdateMemberDbEvent(
    UpdateMemberDbEvent event,
    Emitter<MemberDbState> emit,
  ) async {
    final result = await _updateMemberDb(event.entity);

    result.fold(
      (fail) => emit(
        state.copyWith(
          updateSuccess: false,
          errorMessage: fail.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          updateSuccess: true,
        ),
      ),
    );
  }

  Future<void> _onDeleteMemberDbEvent(
    DeleteMemberDbEvent event,
    Emitter<MemberDbState> emit,
  ) async {
    final result = await _deleteMemberDb(event.id);

    result.fold(
      (fail) => emit(
        state.copyWith(
          deleteSuccess: false,
          errorMessage: fail.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          deleteSuccess: true,
        ),
      ),
    );
  }

  Future<void> _onGetMemberDbEvent(
    GetMemberDbEvent event,
    Emitter<MemberDbState> emit,
  ) async {
    final result = await _getMemberByIdDb(event.id);

    result.fold(
      (fail) => emit(
        state.copyWith(
          errorMessage: fail.message,
        ),
      ),
      (member) => emit(
        state.copyWith(
          member: member,
        ),
      ),
    );
  }

  Future<void> _onGetAllMemberDbEvent(
    GetAllMemberDbEvent event,
    Emitter<MemberDbState> emit,
  ) async {
    final result = await _getAllMemberDb(NoParams());

    result.fold(
      (fail) => emit(
        state.copyWith(
          errorMessage: fail.message,
        ),
      ),
      (members) {
        final allMembers = memberStaticList..addAll(members);
        emit(
          state.copyWith(
            members: allMembers,
            selectedMember: allMembers[0],
          ),
        );
      },
    );
  }

  Future<void> _onResetMemberDbEventStateEvent(
    ResetMemberDbEventStateEvent event,
    Emitter<MemberDbState> emit,
  ) async {
    emit(
      const MemberDbState(),
    );
  }

  Future<void> _onSelectMemberDbEvent(
    SelectMemberDbEvent event,
    Emitter<MemberDbState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedMember: event.member,
      ),
    );
  }
}
