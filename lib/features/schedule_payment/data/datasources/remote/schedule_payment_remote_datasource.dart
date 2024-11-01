import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class SchedulePaymentRemoteDataSource {
  Future<List<SchedulePayment>> getSchedulePayments(
    GetSchedulePaymentsParams params,
  );
  Future<SchedulePayment> getSchedulePayment(String id);

  Future<String> createSchedulePaymentFire(SchedulePayment params);

  Future<Unit> updateSchedulePayment(SchedulePayment params);
  Future<Unit> deleteSchedulePayment(String id);
}

class SchedulePaymentRemoteDataSourceImpl
    implements SchedulePaymentRemoteDataSource {
  SchedulePaymentRemoteDataSourceImpl(
    this.firestore,
    this.auth,
  );
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  @override
  Future<List<SchedulePayment>> getSchedulePayments(
    GetSchedulePaymentsParams params,
  ) async {
    try {
      await firestore.disableNetwork();

      var query = firestore
          .collection(FirebaseConstant.users)
          .doc(auth.currentUser!.uid)
          .collection(FirebaseConstant.schedulePayments)
          .where(
            'status',
            isEqualTo: params.filterBy,
          )
          .orderBy(
            'createdAt',
            descending: params.isDescending,
          )
          .limit(params.limit);

      if (params.lastDocument != null) {
        query = query.startAfterDocument(params.lastDocument!);
      }

      final response = await query.get(const GetOptions(source: Source.cache));

      await firestore.enableNetwork();

      if (!response.metadata.isFromCache && response.docs.isEmpty) {
        final cachedResponse = await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.schedulePayments)
            .where(
              'status',
              isEqualTo: params.filterBy,
            )
            .orderBy(
              'createdAt',
              descending: params.isDescending,
            )
            .limit(params.limit)
            .get(const GetOptions(source: Source.cache));

        return cachedResponse.docs.map(SchedulePayment.fromFirestore).toList();
      }

      return response.docs.map(SchedulePayment.fromFirestore).toList();
    } on FirebaseException catch (e, s) {
      appLogger(
        from: 'getSchedulePayments ',
        error: e,
        stackTrace: s,
      );
      throw CustomException(e.toString());
    } catch (e, s) {
      appLogger(
        from: 'getSchedulePayments',
        error: e,
        stackTrace: s,
      );
      throw CustomException(e.toString());
    }
  }

  @override
  Future<SchedulePayment> getSchedulePayment(String id) async {
    try {
      await firestore.disableNetwork();

      final response = await firestore
          .collection(FirebaseConstant.users)
          .doc(auth.currentUser!.uid)
          .collection(FirebaseConstant.schedulePayments)
          .doc(id)
          .get(const GetOptions(source: Source.cache));

      await firestore.enableNetwork();

      return SchedulePayment.fromFirestore(response);
    } on FirebaseException catch (e, s) {
      appLogger(
        from: 'getSchedulePayment FirebaseException',
        error: e,
        stackTrace: s,
      );
      throw CustomException(e.toString());
    } catch (e, s) {
      appLogger(
        from: 'getSchedulePayment',
        error: e,
        stackTrace: s,
      );
      throw CustomException(e.toString());
    }
  }

  @override
  Future<String> createSchedulePaymentFire(SchedulePayment params) async {
    try {
      final data = params.toMap();

      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('schedule_payments')
          .doc(params.id)
          .set(data);

      return params.id;
    } on FirebaseException catch (e, s) {
      appLogger(
        from: 'createSchedulePayment FirebaseException',
        error: e,
        stackTrace: s,
      );
      throw CustomException(e.toString());
    } catch (e, s) {
      appLogger(
        from: 'createSchedulePayment',
        error: e,
        stackTrace: s,
      );
      throw CustomException(e.toString());
    }
  }

  @override
  Future<Unit> updateSchedulePayment(SchedulePayment params) async {
    try {
      final data = params.toMap();

      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('schedule_payments')
          .doc(params.id)
          .update(data);

      return unit;
    } on FirebaseException catch (e, s) {
      appLogger(
        from: 'updateSchedulePayment FirebaseException',
        error: e,
        stackTrace: s,
      );
      throw CustomException(e.toString());
    } catch (e, s) {
      appLogger(
        from: 'updateSchedulePayment',
        error: e,
        stackTrace: s,
      );
      throw CustomException(e.toString());
    }
  }

  @override
  Future<Unit> deleteSchedulePayment(String id) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('schedule_payments')
          .doc(id)
          .delete();

      return unit;
    } on FirebaseException catch (e, s) {
      appLogger(
        from: 'deleteSchedulePayment FirebaseException',
        error: e,
        stackTrace: s,
      );
      throw CustomException(e.toString());
    } catch (e, s) {
      appLogger(
        from: 'deleteSchedulePayment',
        error: e,
        stackTrace: s,
      );
      throw CustomException(e.toString());
    }
  }
}
