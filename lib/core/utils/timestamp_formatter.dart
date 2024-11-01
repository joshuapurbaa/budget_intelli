import 'package:budget_intelli/core/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TimestampFormatter {
  static String format(Timestamp timestamp, BuildContext context) {
    final localize = textLocalizer(context);
    final now = Timestamp.now();
    final diff = now.seconds - timestamp.seconds;

    if (diff >= 86400) {
      return '${(diff / 86400).floor()} ${localize.dAgo}';
    } else if (diff >= 3600) {
      return '${(diff / 3600).floor()} ${localize.hAgo}';
    } else if (diff >= 60) {
      return '${(diff / 60).floor()} ${localize.mAgo}';
    } else {
      return localize.justNow;
    }
  }

  // i want to get only hour and minute also Post Meridiem and Ante Meridiem, example 12:00 PM
  static String formatTime(Timestamp timestamp) {
    final hour = timestamp.toDate().hour;
    final minute = timestamp.toDate().minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final formattedHour = hour > 12 ? hour - 12 : hour;
    return '$formattedHour:$minute $period';
  }

  // create a new method to format the timestamp to day and month with format like this 12 Jan
  static String formatToDayMonth(Timestamp timestamp, BuildContext context) {
    final day = timestamp.toDate().day;
    final month = timestamp.toDate().month;
    final monthName = getMonthName(month, context);
    return '$day $monthName';
  }

  static String formatToDueDate(Timestamp timestamp, BuildContext context) {
    final localize = textLocalizer(context);
    final now = Timestamp.now();
    final diff = timestamp.seconds - now.seconds;

    if (diff < 0) {
      return localize.alreadyPassedDueDate;
    } else if (diff >= 86400) {
      return '${localize.dueDateIn} ${(diff / 86400).floor()} ${localize.days}';
    } else if (diff >= 3600) {
      return '${localize.dueDateIn} ${(diff / 3600).floor()} ${localize.hours}';
    } else if (diff >= 60) {
      return '${localize.dueDateIn} ${(diff / 60).floor()} ${localize.minutes}';
    } else {
      return '${localize.dueDateIn}${localize.aFewSeconds}';
    }
  }
}
