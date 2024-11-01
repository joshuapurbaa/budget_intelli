part of 'app_size_cubit.dart';

@immutable
final class AppSizeState {
 const AppSizeState({
    this.size,
  });

  final Size? size;

  AppSizeState copyWith({
    Size? size,
  }) {
    return AppSizeState(
      size: size ?? this.size,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppSizeState && other.size == size;
  }

  @override
  int get hashCode => size.hashCode;
}
