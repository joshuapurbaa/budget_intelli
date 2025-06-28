part of 'app_update_cubit.dart';

abstract class AppUpdateState extends Equatable {
  const AppUpdateState();

  @override
  List<Object?> get props => [];
}

class AppUpdateInitial extends AppUpdateState {}

class AppUpdateChecking extends AppUpdateState {}

class AppUpdateAvailable extends AppUpdateState {

  const AppUpdateAvailable(this.updateInfo);
  final AppUpdateInfo updateInfo;

  @override
  List<Object?> get props => [updateInfo];
}

class AppUpdateNotAvailable extends AppUpdateState {

  const AppUpdateNotAvailable(this.updateInfo);
  final AppUpdateInfo updateInfo;

  @override
  List<Object?> get props => [updateInfo];
}

class AppUpdateDownloading extends AppUpdateState {}

class AppUpdateDownloaded extends AppUpdateState {}

class AppUpdateInstalling extends AppUpdateState {}

class AppUpdateCompleted extends AppUpdateState {}

class AppUpdateError extends AppUpdateState {

  const AppUpdateError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class AppUpdateDismissed extends AppUpdateState {}
