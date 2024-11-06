part of 'member_db_bloc.dart';

sealed class MemberDbEvent extends Equatable {
  const MemberDbEvent();

  @override
  List<Object?> get props => [];
}

final class InsertMemberDbEvent extends MemberDbEvent {
  const InsertMemberDbEvent(this.entity);

  final MemberDbEvent entity;

  @override
  List<Object> get props => [entity];
}

final class UpdateMemberDbEvent extends MemberDbEvent {
  const UpdateMemberDbEvent(this.entity);

  final MemberDbEvent entity;

  @override
  List<Object> get props => [entity];
}

final class DeleteMemberDbEvent extends MemberDbEvent {
  const DeleteMemberDbEvent(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

final class GetMemberDbEvent extends MemberDbEvent {
  const GetMemberDbEvent(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

final class GetAllMemberDbEvent extends MemberDbEvent {
  const GetAllMemberDbEvent();

  @override
  List<Object> get props => [];
}

final class ResetMemberDbEventStateEvent extends MemberDbEvent {
  const ResetMemberDbEventStateEvent();

  @override
  List<Object> get props => [];
}