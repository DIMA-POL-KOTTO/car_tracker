import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:car_tracker/models/maintenance_reminder.dart';
import 'package:car_tracker/models/fuel_type.dart';
import 'package:flutter/material.dart';

String fuelTypeName(FuelType type, AppLocalizations l10n) {
  switch (type) {
    case FuelType.petrol92:
      return l10n.ron_92;
    case FuelType.petrol95:
      return l10n.ron_95;
    case FuelType.petrol98:
      return l10n.ron_98;
    case FuelType.petrol100:
      return l10n.ron_100;
    case FuelType.diesel:
      return l10n.diesel;
    case FuelType.gas:
      return l10n.gas;
    case FuelType.electric:
      return l10n.electric;
  }
}

String fuelTypeCarName(FuelTypeCar type, AppLocalizations l10n) {
  switch (type) {
    case FuelTypeCar.petrol:
      return l10n.petrol;
    case FuelTypeCar.diesel:
      return l10n.diesel;
    case FuelTypeCar.gas:
      return l10n.gas;
    case FuelTypeCar.electric:
      return l10n.electric;
  }
}

String formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}.'
      '${date.month.toString().padLeft(2, '0')}.'
      '${date.year}';
}

Color maintenanceUrgencyColor(
  MaintenanceReminder reminder,
  int? currentMileage,
) {
  if (reminder.reminderType == ReminderType.mileage) {
    final dueMileage = reminder.dueMileage;
    if (dueMileage == null || currentMileage == null) return Colors.green;
    if (currentMileage >= dueMileage) return Colors.red;
    if (dueMileage - currentMileage <= 1000) return Colors.amber;
    return Colors.green;
  }

  final dueDate = reminder.dueDate;
  if (dueDate == null) return Colors.green;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  if (dueDate.isBefore(today)) return Colors.red;
  if (!dueDate.isAfter(_addCalendarMonth(today))) return Colors.amber;
  return Colors.green;
}

DateTime _addCalendarMonth(DateTime date) {
  final monthIndex = date.month;
  final year = date.year + monthIndex ~/ 12;
  final month = monthIndex % 12 + 1;
  final lastDay = DateTime(year, month + 1, 0).day;
  final day = date.day > lastDay ? lastDay : date.day;
  return DateTime(year, month, day);
}

String monthName(DateTime date, AppLocalizations l10n) {
  final months = [
    l10n.january,
    l10n.february,
    l10n.march,
    l10n.april,
    l10n.may,
    l10n.june,
    l10n.july,
    l10n.august,
    l10n.september,
    l10n.october,
    l10n.november,
    l10n.december,
  ];
  if (date.month < 1 || date.month > 12) {
    return '';
  }
  return '${months[date.month - 1]} ${date.year}';
}
