import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

/// Formats a date range based on the given list of dates.
///
/// The [dateList] parameter should contain exactly 2 elements representing the start and end dates.
/// Returns a formatted string representing the date range.
///
/// If the start and end dates have the same month and year, the format will be:
///   "startDay - endDay MonthName year"
/// Otherwise, the format will be:
///   "startDay MonthName - endDay MonthName year"
String formatDateRangeStr(List<String> dateList, BuildContext context) {
  assert(dateList.length == 2, 'dateList must have 2 elements');
  final startDate = DateTime.parse(dateList[0]);
  final endDate = DateTime.parse(dateList[1]);

  if (startDate.month == endDate.month && startDate.year == endDate.year) {
    return '${startDate.day} - ${endDate.day} ${getMonthName(startDate.month, context)} ${startDate.year}';
  } else {
    return '${startDate.day} ${getMonthName(startDate.month, context)} - ${endDate.day} ${getMonthName(
      endDate.month,
      context,
    )} ${endDate.year}';
  }
}

String formatDateRangeDateList(
  List<DateTime?> dateRange,
  BuildContext context,
) {
  final localize = textLocalizer(context);

  if (dateRange.isEmpty) {
    return localize.selectDateRange;
  }
  assert(dateRange.length == 2, 'dateRange must have 2 elements');
  final startDate = dateRange[0];
  final endDate = dateRange[1];

  if (startDate!.month == endDate!.month && startDate.year == endDate.year) {
    return '${startDate.day} - ${endDate.day} ${getMonthName(startDate.month, context)} ${startDate.year}';
  } else if (startDate.year != endDate.year) {
    return '${startDate.day} ${getMonthName(startDate.month, context)}  ${startDate.year} - ${endDate.day} ${getMonthName(endDate.month, context)} ${endDate.year}';
  } else {
    return '${startDate.day} ${getMonthName(startDate.month, context)} - ${endDate.day} ${getMonthName(endDate.month, context)} ${endDate.year}';
  }
}

/// Formats the given [date] into a string with the format "DD MonthName YYYY".
String formatDateDDMMYYYY(
  DateTime date,
  BuildContext context,
) {
  final languageVal = ControllerHelper.getLanguage(context);
  return DateFormat.yMMMMd(languageVal).format(date);
}

/// Formats the given [date] into a string representation.
///
/// The returned string will be in the format "day month", where "day" is the day of the month
/// and "month" is the name of the month.
///
/// Example:
/// ```dart
/// DateTime date = DateTime.now();
/// String formattedDate = formatDate(date); // e.g. "15 August"
/// ```
String formatDateDDMM(DateTime date, BuildContext context) {
  return '${date.day} ${getMonthName(date.month, context)}';
}

String getMonthName(
  int month,
  BuildContext context,
) {
  var isIndonesian = false;

  final state = context.read<SettingBloc>().state;
  if (state.selectedLanguage == Language.indonesia) {
    isIndonesian = true;
  } else {
    isIndonesian = false;
  }
  switch (month) {
    case 1:
      return isIndonesian ? 'Januari' : 'January';
    case 2:
      return isIndonesian ? 'Februari' : 'February';
    case 3:
      return isIndonesian ? 'Maret' : 'March';
    case 4:
      return isIndonesian ? 'April' : 'April';
    case 5:
      return isIndonesian ? 'Mei' : 'May';
    case 6:
      return isIndonesian ? 'Juni' : 'June';
    case 7:
      return isIndonesian ? 'Juli' : 'July';
    case 8:
      return isIndonesian ? 'Agustus' : 'August';
    case 9:
      return isIndonesian ? 'September' : 'September';
    case 10:
      return isIndonesian ? 'Oktober' : 'October';
    case 11:
      return isIndonesian ? 'November' : 'November';
    case 12:
      return isIndonesian ? 'Desember' : 'December';
    default:
      return '';
  }
}

/// format string like this: 2024-04-26 15:21:19.078552 to Apr 26
String getDayMonth(String dateString, BuildContext context) {
  final parts = dateString.split(' ')[0].split('-');
  final month = int.parse(parts[1]);
  final day = int.parse(parts[2]);

  var indo = false;

  final state = context.read<SettingBloc>().state;
  if (state.selectedLanguage == Language.indonesia) {
    indo = true;
  } else {
    indo = false;
  }
  var monthString = '';
  switch (month) {
    case 1:
      monthString = 'Jan';
    case 2:
      monthString = 'Feb';
    case 3:
      monthString = 'Mar';

    case 4:
      monthString = 'Apr';

    case 5:
      monthString = indo ? 'Mei' : 'May';

    case 6:
      monthString = 'Jun';

    case 7:
      monthString = 'Jul';

    case 8:
      monthString = indo ? 'Agu' : 'Aug';

    case 9:
      monthString = 'Sep';

    case 10:
      monthString = indo ? 'Okt' : 'Oct';

    case 11:
      monthString = 'Nov';

    case 12:
      monthString = indo ? 'Des' : 'Dec';

    default:
      monthString = '';
  }

  return '$monthString $day';
}

String? getBulanDariNama(String namaBulan, BuildContext context) {
  try {
    final locale = ControllerHelper.getLanguageLocale(context);
    // Parsing nama bulan dengan format dan locale yang sesuai
    final format = DateFormat.MMMM(locale.languageCode);
    final tanggal = format.parse(namaBulan);

    if (tanggal.month < 10) {
      return '0${tanggal.month}';
    } else {
      return tanggal.month.toString();
    }
  } catch (e) {
    // Return null jika nama bulan tidak dikenali
    return null;
  }
}
