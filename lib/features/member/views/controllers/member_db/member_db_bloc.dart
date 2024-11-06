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
    on<MemberDbEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  final InsertMemberDb _insertMemberDb;
  final UpdateMemberDb _updateMemberDb;
  final DeleteMemberDb _deleteMemberDb;
  final GetAllMemberDb _getAllMemberDb;
  final GetMemberByIdDb _getMemberByIdDb;
}
