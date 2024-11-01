import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SchedulePayment {
  SchedulePayment({
    required this.status,
    required this.id,
    required this.name,
    required this.amount,
    required this.dueDate,
    required this.createdAt,
    required this.repitition,
    this.description,
  });

  // create fromMap method
  factory SchedulePayment.fromMap(Map<String, dynamic> map) {
    return SchedulePayment(
      id: map['id'] as String,
      name: map['name'] as String,
      status: map['status'] as String,
      amount: map['amount'] as int,
      dueDate: map['due_date'] as String,
      description: map['description'] as String?,
      createdAt: map['created_at'] as String,
      repitition: map['repitition'] as int,
    );
  }

  // from firestore
  factory SchedulePayment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return SchedulePayment.fromMap(data);
  }

  final String id;
  final String name;
  final String status;
  final int amount;
  final String dueDate;
  final String? description;
  final String createdAt;
  final int repitition;

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
    };
  }

  // create copyWith method
  SchedulePayment copyWith({
    String? id,
    String? name,
    String? status,
    int? amount,
    String? dueDate,
    String? description,
    String? createdAt,
    int? repitition,
    List<Repetition>? repititions,
  }) {
    return SchedulePayment(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      repitition: repitition ?? this.repitition,
    );
  }
}
