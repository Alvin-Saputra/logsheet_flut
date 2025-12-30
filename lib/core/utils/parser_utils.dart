import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

int? parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

DateTime? parseDateTime(dynamic value) {
  if (value is String) return DateTime.tryParse(value);
  if (value is DateTime) return value;
  return null;
}

double? parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

TimeOfDay? parseTimeOfDay(dynamic value) {
  if (value == null) return null;
  if (value is String && value.isNotEmpty) {
    final parts = value.split(':');
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour != null && minute != null) {
      return TimeOfDay(hour: hour, minute: minute);
    }
  }
  return null;
}

String? formatTimeOfDay(TimeOfDay? time, {bool showSecond = true}) {
  if (time == null) {
    return null;
  }
  // padLeft ensures that single-digit hours/minutes get a leading zero (e.g., 9 becomes '09')
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  if (showSecond) {
    return '$hour:$minute:00';
  } else {
    return '$hour:$minute';
  }
  // We add ':00' for seconds to match the standard TIME format
}

String? formatDatetoString(DateTime? date, String format) {
  if (date == null) {
    return "";
  }
  try {
    return DateFormat(format).format(date);
  } catch (e) {
    print("Error parsing date: $date");
    return null; // Return null jika format tanggal dari API aneh
  }
}

DateTime? formatStringtoDate(String? date, String format) {
  // 1. Cek Safety: Jika null atau string kosong, langsung return null
  if (date == null || date.trim().isEmpty) {
    return null;
  }

  try {
    return DateFormat(format).parse(date);
  } catch (e) {
    print("Error parsing date: $date");
    return null; // Return null jika format tanggal dari API aneh
  }
}

dynamic changeStringDateFormat(
  String date,
  String inputFormat,
  String outputFormat, {
  bool returnDateTime = false,
  bool withTime = false,
}) {
  final inputDateTime = DateFormat(inputFormat).parse(date);

  if (returnDateTime) {
    return inputDateTime; // return DateTime
  }

  if (returnDateTime && withTime) {
    final date = DateTime.now();

    DateTime(
      inputDateTime.year,
      inputDateTime.month,
      inputDateTime.day,
      date.hour,
      date.minute,
      date.second,
    );
    final timeFormat = '$outputFormat HH:mm:ss';
    return DateFormat(
      timeFormat,
    ).format(inputDateTime); // return String with time
  }

  return DateFormat(outputFormat).format(inputDateTime); // return String
}
