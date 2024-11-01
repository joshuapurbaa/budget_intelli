class GoalHistoryModel {
  GoalHistoryModel({
    required this.id,
    required this.goalId,
    required this.savedAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  // Method fromMap untuk mengonversi map menjadi instance dari GoalHistoryModel
  factory GoalHistoryModel.fromMap(Map<String, dynamic> map) {
    return GoalHistoryModel(
      id: map['id'] as String,
      goalId: map['goal_id'] as String,
      savedAmount: map['saved_amount'] as String,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }

  final String id;
  final String goalId;
  final String savedAmount;
  final String createdAt;
  final String updatedAt;

  // Method toMap untuk mengonversi instance GoalHistoryModel menjadi map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'goal_id': goalId,
      'saved_amount': savedAmount,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Method copyWith untuk menyalin instance dengan beberapa perubahan
  GoalHistoryModel copyWith({
    String? id,
    String? goalId,
    String? savedAmount,
    String? createdAt,
    String? updatedAt,
  }) {
    return GoalHistoryModel(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      savedAmount: savedAmount ?? this.savedAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
