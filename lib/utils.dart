import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:car_tracker/models/fuel_type.dart';


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
    l10n.december
  ];
  if (date.month < 1 || date.month > 12) {
    return '';
  }
  return '${months[date.month - 1]} ${date.year}';
}