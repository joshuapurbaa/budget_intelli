// class GroupCategoryHistoryParams {
//   GroupCategoryHistoryParams({
//     required this.id,
//     required this.groupName,
//     required this.type,
//     required this.groupId,
//     required this.createdAt,
//     this.budgetId,
//     this.method,
//   });

//   final String id;
//   final String groupName;
//   final String? method;
//   final String type;
//   final String? budgetId;
//   final String groupId;
//   final String createdAt;

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'group_name': groupName,
//       'method': method,
//       'type': type,
//       'budget_id': budgetId,
//       'group_id': groupId,
//       'created_at': createdAt,
//     };
//   }

//   Map<String, dynamic> toFirestore() {
//     return {
//       'id': id,
//       'group_name': groupName,
//       'method': method,
//       'type': type,
//       'budget_id': budgetId,
//       'group_id': groupId,
//       'created_at': createdAt,
//     };
//   }
// }
