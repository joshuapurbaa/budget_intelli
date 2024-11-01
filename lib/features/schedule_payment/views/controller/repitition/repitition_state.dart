part of 'repitition_cubit.dart';

@immutable
final class RepititionState {
  const RepititionState({
    required this.repititions,
    this.dueDate,
  });
  final List<Repetition> repititions;
  final Timestamp? dueDate;

  RepititionState copyWith({
    List<Repetition>? repititions,
    Timestamp? dueDate,
  }) {
    return RepititionState(
      repititions: repititions ?? this.repititions,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
