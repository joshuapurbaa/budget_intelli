import 'package:cloud_firestore/cloud_firestore.dart';

class GetSchedulePaymentsParams {
  GetSchedulePaymentsParams({
    required this.limit,
    this.offset,
    this.search,
    this.orderBy,
    this.isDescending = true,
    this.lastDocument,
    this.filterBy,
  });

  final int limit;
  final int? offset;
  final String? search;
  final String? orderBy;
  final bool isDescending;
  final DocumentSnapshot? lastDocument;
  final String? filterBy;
}
