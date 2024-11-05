class MemberHistory {
  MemberHistory({
    required this.id,
    required this.memberId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String memberId;
  final String createdAt;
  final String updatedAt;

  factory MemberHistory.fromMap(Map<String, dynamic> json) => MemberHistory(
        id: json['id'] as String,
        memberId: json['member_id'] as String,
        createdAt: json['created_at'] as String,
        updatedAt: json['updated_at'] as String,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'member_id': memberId,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
