import 'dart:typed_data';

import 'package:geocoding/geocoding.dart';

class FinancialTransaction {
  FinancialTransaction({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.comment,
    required this.amount,
    required this.date,
    required this.type,
    required this.categoryName,
    required this.accountName,
    required this.accountId,
    required this.categoryId,
    this.transactionLocation,
    this.picture,
  });

  // fromMap method to convert map to model
  factory FinancialTransaction.fromMap(Map<String, dynamic> map) {
    return FinancialTransaction(
      id: map['id'] as String,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
      comment: map['comment'] as String,
      amount: map['amount'] as int,
      date: map['date'] as String,
      type: map['type'] as String,
      categoryName: map['category'] as String,
      accountName: map['account_name'] as String,
      accountId: map['account_id'] as String,
      categoryId: map['category_id'] as String,
      transactionLocation: map['transaction_location'] != null
          ? TransactionLocation.fromMap(
              map['transaction_location'] as Map<String, dynamic>,
            )
          : null,
      picture: map['picture'] as Uint8List?,
    );
  }

  // toMap method to convert model to map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'comment': comment,
      'amount': amount,
      'date': date,
      'type': type,
      'category': categoryName,
      'account_name': accountName,
      'account_id': accountId,
      'category_id': categoryId,
      'transaction_location': transactionLocation?.toMap(),
      'picture': picture,
    };
  }

  final String id;
  final String createdAt;
  final String updatedAt;
  final String comment;
  final int amount;
  final String date;
  final String type;
  final String categoryName;
  final String accountName;
  final String accountId;
  final String categoryId;
  final TransactionLocation? transactionLocation;
  final Uint8List? picture;
}

class TransactionLocation {
  TransactionLocation({
    required this.subAdministritiveArea,
    required this.administritiveArea,
    required this.country,
    required this.locality,
    required this.subLocality,
  });

  final String subAdministritiveArea;
  final String administritiveArea;
  final String country;
  final String locality;
  final String subLocality;

  factory TransactionLocation.fromPlacemark(Placemark placemark) {
    return TransactionLocation(
      subAdministritiveArea: placemark.subAdministrativeArea ?? '',
      administritiveArea: placemark.administrativeArea ?? '',
      country: placemark.country ?? '',
      locality: placemark.locality ?? '',
      subLocality: placemark.subLocality ?? '',
    );
  }

  // fromMap method to convert map to model
  factory TransactionLocation.fromMap(Map<String, dynamic> map) {
    return TransactionLocation(
      subAdministritiveArea: map['sub_administrative_area'] as String,
      administritiveArea: map['administrative_area'] as String,
      country: map['country'] as String,
      locality: map['locality'] as String,
      subLocality: map['sub_locality'] as String,
    );
  }

  // toMap method to convert model to map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sub_administrative_area': subAdministritiveArea,
      'administrative_area': administritiveArea,
      'country': country,
      'locality': locality,
      'sub_locality': subLocality,
    };
  }
}
