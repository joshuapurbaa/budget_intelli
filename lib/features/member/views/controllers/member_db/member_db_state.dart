part of 'member_db_bloc.dart';

final class MemberDbState extends Equatable {
  const MemberDbState({
    this.insertSuccess = false,
    this.updateSuccess = false,
    this.deleteSuccess = false,
    this.errorMessage,
    this.members = const <Member>[],
    this.member,
    this.selectedMember,
  });

  final bool insertSuccess;
  final bool updateSuccess;
  final bool deleteSuccess;
  final String? errorMessage;
  final List<Member> members;
  final Member? member;
  final Member? selectedMember;

  MemberDbState copyWith({
    bool? insertSuccess,
    bool? updateSuccess,
    bool? deleteSuccess,
    String? errorMessage,
    List<Member>? members,
    Member? member,
    Member? selectedMember,
  }) {
    return MemberDbState(
      insertSuccess: insertSuccess ?? this.insertSuccess,
      updateSuccess: updateSuccess ?? this.updateSuccess,
      deleteSuccess: deleteSuccess ?? this.deleteSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      members: members ?? this.members,
      member: member ?? this.member,
      selectedMember: selectedMember ?? this.selectedMember,
    );
  }

  @override
  List<Object?> get props => [
        insertSuccess,
        updateSuccess,
        deleteSuccess,
        errorMessage,
        members,
        member,
        selectedMember,
      ];
}
