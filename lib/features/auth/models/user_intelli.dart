import 'package:budget_intelli/core/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserIntelli {
  UserIntelli({
    required this.uid,
    required this.email,
    this.budgetIds = const [],
    this.createdAt,
    this.name,
    this.imageUrl,
    this.premium,
  });

  factory UserIntelli.fromFirestore(DocumentSnapshotMap snapshot) {
    final data = snapshot.data();
    return UserIntelli(
      uid: data?['uid'] as String,
      email: data?['email'] as String,
      createdAt: data?['created_at'] as Timestamp?,
      name: data?['name'] as String?,
      imageUrl: data?['image_url'] as String?,
      premium: data?['premium'] as bool?,
      budgetIds: List<String>.from(data?['budget_ids'] as List<dynamic>),
    );
  }

  factory UserIntelli.fromMap(MapStringDynamic? map) {
    return UserIntelli(
      uid: map?['uid'] as String,
      email: map?['email'] as String,
      createdAt: map?['created_at'] as Timestamp?,
      name: map?['name'] as String?,
      imageUrl: map?['image_url'] as String?,
      premium: map?['premium'] as bool?,
      budgetIds: List<String>.from(map?['budget_ids'] as List<dynamic>),
    );
  }

  final String uid;
  final String email;
  final Timestamp? createdAt;
  final String? name;
  final String? imageUrl;
  final bool? premium;
  final List<String> budgetIds;

  UserIntelli copyWith({
    String? uid,
    String? email,
    Timestamp? createdAt,
    String? name,
    String? imageUrl,
    bool? premium,
    List<String>? budgetIds,
  }) {
    return UserIntelli(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      premium: premium ?? this.premium,
      budgetIds: budgetIds ?? this.budgetIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'created_at': createdAt,
      'name': name,
      'image_url': imageUrl,
      'premium': premium,
      'budget_ids': budgetIds,
    };
  }
}
