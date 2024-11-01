import 'dart:convert';

class LiabilityModel {

  LiabilityModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
    this.description,
  });

  factory LiabilityModel.fromMap(Map<String, dynamic> map) {
    return LiabilityModel(
      id: map['id'] as String,
      name: map['name'] as String,
      amount: map['amount'] as double,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
      description: map['description'] as String?,
    );
  }
  final String id;
  final String name;
  final double amount;
  final String createdAt;
  final String updatedAt;
  final String? description;

  LiabilityModel copyWith({
    String? id,
    String? name,
    double? amount,
    String? createdAt,
    String? updatedAt,
    String? description,
  }) {
    return LiabilityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'description': description,
    };
  }

  String toJson() => json.encode(toMap());
}
