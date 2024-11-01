import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required UserSignUpUsecase userSignUp,
    required UserFirestoreCubit getUserCubit,
    required UserSignIn userSignIn,
    required UserSignOut userSignOut,
    required GetCurrentUserSessionUsecase getCurrentUser,
  })  : _userSignUp = userSignUp,
        _userFirestoreCubit = getUserCubit,
        _userSignIn = userSignIn,
        _userSignOut = userSignOut,
        _getCurrentUserSession = getCurrentUser,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<SignInEvent>(_onSignInEvent);
    on<SignUpEvent>(_onSignUpEvent);
    on<SignOutEvent>(_onSignOutEvent);
    on<GetCurrentUserSessionEvent>(_getCurrentUserSessionEvent);

    on<AuthInitialEvent>((_, emit) => emit(AuthInitial()));
  }

  final UserFirestoreCubit _userFirestoreCubit;
  final UserSignUpUsecase _userSignUp;
  final UserSignIn _userSignIn;
  final UserSignOut _userSignOut;
  final GetCurrentUserSessionUsecase _getCurrentUserSession;

  Future<void> _getCurrentUserSessionEvent(
    GetCurrentUserSessionEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _getCurrentUserSession.call(NoParams());

    result.fold(
      (failure) {
        emit(
          AuthFailure(failure.message),
        );
      },
      (user) {
        emit(
          CurrentUserSuccess(user),
        );
      },
    );
  }

  Future<void> _onSignUpEvent(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    await result.fold(
      (failure) {
        final result = _handleErrorMessage(failure.message);

        emit(
          AuthFailure(result),
        );
      },
      (user) async {
        final userIntelli = UserIntelli(
          uid: user.uid,
          email: event.email,
          name: event.name,
          createdAt: Timestamp.now(),
          premium: false,
        );

        final result = await _userFirestoreCubit.insertUser(userIntelli);

        if (result != null) {
          emit(
            AuthSuccess(result),
          );
        } else {
          emit(
            AuthFailure('Error inserting user data'),
          );
        }
      },
    );
  }

  Future<void> _onSignInEvent(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _userSignIn(
      UserSignInParams(
        email: event.email,
        password: event.password,
      ),
    );

    await result.fold(
      (failure) {
        final message = _handleErrorMessage(failure.message);

        emit(
          AuthFailure(message),
        );
      },
      (user) => _onAuthSuccess(user, emit),
    );
  }

  Future<void> _onSignOutEvent(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _userSignOut(NoParams());
    result.fold(
      (failure) => emit(
        AuthFailure(failure.message),
      ),
      (_) {
        emit(
          SignOutSuccess(),
        );
      },
    );
  }

  Future<void> _onAuthSuccess(
    UserIntelli user,
    Emitter<AuthState> emit,
  ) async {
    final result = await _userFirestoreCubit.getUserFirestore();
    if (result != null) {
      emit(
        AuthSuccess(result),
      );
    } else {
      emit(
        AuthFailure('Error getting user data'),
      );
    }
  }

  String _handleErrorMessage(String message) {
    switch (message) {
      case ErrorMessages.firebaseInvalidCredentials:
        return 'Username or password is incorrect';
      case ErrorMessages.firebaseInvalidEmail:
        return 'Email address is not valid: incorrect format';
      default:
        return message;
    }
  }
}
