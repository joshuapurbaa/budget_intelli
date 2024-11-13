import 'dart:typed_data';

import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ControllerHelper {
  static String? getCategory(BuildContext context) {
    final state = context.read<BoxCategoryCubit>().state;
    String? category;
    if (state is HasDataSelected) {
      category = state.category;
    }
    return category;
  }

  static int? getAmount(BuildContext context) {
    try {
      final state = context.read<BoxCalculatorCubit>().state;

      if (state is BoxCalculatorSelected) {
      
        final stringAmount = state.value.replaceAll(',', '');
        return int.parse(stringAmount);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static int? parseStringToInt(String rawString) {
    try {
      final stringReps = rawString.replaceAll('.', '');
      return int.parse(stringReps);
    } catch (e) {
      return null;
    }
  }

  static Timestamp? getSingleDate(BuildContext context) {
    final boxCalendarState = context.read<BoxCalendarCubit>().state;
    Timestamp? date;
    if (boxCalendarState is DateSelected) {
      date = Timestamp.fromDate(boxCalendarState.dates[0]);
    }
    return date;
  }

  static String? getSingleDateString(BuildContext context) {
    final boxCalendarState = context.read<BoxCalendarCubit>().state;

    String? date;
    if (boxCalendarState is DateSelected) {
      final now = DateTime.now();
      final selectedDate = boxCalendarState.dates[0];
      final nowYear = now.year;
      final nowMonth = now.month;
      final nowDay = now.day;
      final selectedDateYear = selectedDate.year;
      final selectedDateMonth = selectedDate.month;
      final selectedDateDay = selectedDate.day;

      if (nowYear == selectedDateYear &&
          nowMonth == selectedDateMonth &&
          nowDay == selectedDateDay) {
        var month = '';
        if (nowMonth < 10) {
          month = '0$nowMonth';
        } else {
          month = nowMonth.toString();
        }

        date = '$nowYear-$month-$nowDay ${now.hour}:${now.minute}';
      } else {
        date = boxCalendarState.dates[0].toString();
      }
    }
    return date;
  }

  static List<Timestamp>? getPeriodDate(BuildContext context) {
    final boxCalendarState = context.read<BoxCalendarCubit>().state;
    List<DateTime>? period;
    if (boxCalendarState is DateRangeSelected) {
      period = boxCalendarState.dates;
    }
    if (period != null) {
      if (period.length == 1) {
        return [
          Timestamp.fromDate(period[0]),
          Timestamp.fromDate(period[0]),
        ];
      } else {
        return [
          Timestamp.fromDate(period[0]),
          Timestamp.fromDate(period[1]),
        ];
      }
    }
    return null;
  }

  static String? getImageUrl(BuildContext context) {
    final uploadImageState = context.read<UploadImageBloc>().state;
    String? imageUrl;
    if (uploadImageState is UploadImageSuccess) {
      imageUrl = uploadImageState.imageUrl;
    }
    return imageUrl;
  }

  static Uint8List? getImagesBytes(BuildContext context) {
    final uploadImageState = context.read<UploadImageBloc>().state;
    Uint8List? imageBytes;
    if (uploadImageState is UploadImageSuccess) {
      imageBytes = uploadImageState.imageBytes;
    }

    return imageBytes;
  }

  static void setToInitial(BuildContext context) {
    context.read<UploadImageBloc>().add(ResetImage());
  }

  static bool getPremium(BuildContext context) {
    final settingState = context.read<SettingBloc>().state;
    final premium = settingState.user?.premium ?? false;

    return premium;
  }

  static String getLanguage(BuildContext context) {
    final setting = context.read<SettingBloc>().state;
    final languageVal = setting.selectedLanguage.value.toString();
    return languageVal;
  }

  static Locale getLanguageLocale(BuildContext context) {
    final setting = context.read<SettingBloc>().state;
    final languageVal = setting.selectedLanguage.value;
    return languageVal;
  }
}
