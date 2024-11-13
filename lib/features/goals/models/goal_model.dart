class GoalModel {
  GoalModel({
    required this.id,
    required this.goalName,
    required this.goalAmount,
    required this.perDayAmount,
    required this.perMonthAmount,
    required this.startGoalDate,
    required this.endGoalDate,
    required this.remainingAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    return GoalModel(
      id: map['id'] as String,
      goalName: map['goal_name'] as String,
      goalAmount: map['goal_amount'] as double,
      perDayAmount: map['per_day_amount'] as double,
      perMonthAmount: map['per_month_amount'] as double,
      startGoalDate: map['start_goal_date'] as String,
      endGoalDate: map['end_goal_date'] as String,
      remainingAmount: map['remaining_amount'] as double,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }

  final String id;
  final String goalName;
  final double goalAmount;
  final double perDayAmount;
  final double perMonthAmount;
  final String startGoalDate;
  final String endGoalDate;
  final double remainingAmount;
  final String createdAt;
  final String updatedAt;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'goal_name': goalName,
      'goal_amount': goalAmount,
      'per_day_amount': goalAmount,
      'per_month_amount': perMonthAmount,
      'start_goal_date': startGoalDate,
      'end_goal_date': endGoalDate,
      'remaining_amount': remainingAmount,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  String toString() {
    return 'Goal(id: $id, goalName: $goalName, goalAmount: $goalAmount, startGoalDate: $startGoalDate, endGoalDate: $endGoalDate, remainingAmount: $remainingAmount)';
  }
}
