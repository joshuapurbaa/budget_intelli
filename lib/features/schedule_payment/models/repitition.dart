class Repetition {
  Repetition({
    required this.id,
    required this.dueDate,
    required this.status,
    required this.schedulePaymentId,
  });

  // create fromMap method
  factory Repetition.fromMap(Map<String, dynamic> map) {
    return Repetition(
      id: map['id'] as String,
      dueDate: map['due_date'] as String,
      status: map['status'] as String,
      schedulePaymentId: map['schedule_payment_id'] as String,
    );
  }

  final String id;
  final String dueDate;
  final String status;
  final String schedulePaymentId;

  // create copyWith method
  Repetition copyWith({
    String? dueDate,
    String? status,
    String? id,
    String? schedulePaymentId,
  }) {
    return Repetition(
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      id: id ?? this.id,
      schedulePaymentId: schedulePaymentId ?? this.schedulePaymentId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'due_date': dueDate,
      'status': status,
      'schedule_payment_id': schedulePaymentId,
    };
  }
}
