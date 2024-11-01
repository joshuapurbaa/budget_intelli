import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SchedulePaymentDb {
  SchedulePaymentDb({
    required this.status,
    required this.id,
    required this.name,
    required this.amount,
    required this.dueDate,
    required this.createdAt,
    required this.repitition,
    required this.repititions,
    this.description,
  });

  // create fromMap method
  factory SchedulePaymentDb.fromMap(Map<String, dynamic> map) {
    return SchedulePaymentDb(
      id: map['id'] as String,
      name: map['name'] as String,
      status: map['status'] as String,
      amount: map['amount'] as int,
      dueDate: map['due_date'] as Timestamp,
      description: map['description'] as String,
      createdAt: map['created_at'] as Timestamp,
      repitition: map['repitition'] as int,
      repititions: (map['repititions'] as List)
          .map((e) => Repetition.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // from firestore
  factory SchedulePaymentDb.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return SchedulePaymentDb.fromMap(data);
  }

  final String id;
  final String name;
  final String status;
  final int amount;
  final Timestamp dueDate;
  final String? description;
  final Timestamp createdAt;
  final int repitition;
  final List<Repetition> repititions;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'amount': amount,
      'due_date': dueDate,
      'description': description,
      'created_at': createdAt,
      'repitition': repitition,
      'repititions': repititions.map((e) => e.toMap()).toList(),
    };
  }

  // create copyWith method
  SchedulePaymentDb copyWith({
    String? id,
    String? name,
    String? status,
    int? amount,
    Timestamp? dueDate,
    String? description,
    Timestamp? createdAt,
    int? repitition,
    List<Repetition>? repititions,
  }) {
    return SchedulePaymentDb(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      repitition: repitition ?? this.repitition,
      repititions: repititions ?? this.repititions,
    );
  }
}
