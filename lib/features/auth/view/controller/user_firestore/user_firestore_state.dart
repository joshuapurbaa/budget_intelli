part of 'user_firestore_cubit.dart';

@immutable
class UserFirestoreState {
  const UserFirestoreState({
    required this.message,
    required this.isLoading,
    required this.userIntellie,
    this.updateSuccess = false,
  });
  factory UserFirestoreState.initial() {
    return const UserFirestoreState(
      userIntellie: null,
      message: '',
      isLoading: false,
    );
  }

  final UserIntelli? userIntellie;
  final String message;
  final bool isLoading;
  final bool updateSuccess;

  UserFirestoreState copyWith({
    UserIntelli? userIntellie,
    String? message,
    bool? isLoading,
    bool? updateSuccess,
  }) {
    return UserFirestoreState(
      userIntellie: userIntellie ?? this.userIntellie,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      updateSuccess: updateSuccess ?? this.updateSuccess,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserFirestoreState &&
        other.userIntellie == userIntellie &&
        other.message == message &&
        other.isLoading == isLoading &&
        other.updateSuccess == updateSuccess;
  }

  @override
  int get hashCode =>
      userIntellie.hashCode ^
      message.hashCode ^
      isLoading.hashCode ^
      updateSuccess.hashCode;
}
