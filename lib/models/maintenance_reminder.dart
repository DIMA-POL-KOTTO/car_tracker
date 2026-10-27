import 'package:car_tracker/models/maintenance_category.dart';

enum ReminderType {
  mileage,
  date,
}

class MaintenanceReminder {
  final int? id;
  final int carId;
  final String title;
  final MaintenanceCategory category;
  final ReminderType reminderType;
  final int? dueMileage;
  final DateTime? dueDate;
  final int repeatByM;
  final int? intervalM;
  final int repeatByD;
  final int? intervalD;
  final bool isRepeating;

  MaintenanceReminder({
    this.id,
    required this.carId,
    required this.title,
    required this.category,
    required this.reminderType,
    this.dueMileage,
    this.dueDate,
    this.repeatByM = 0,
    this.intervalM,
    this.repeatByD = 0,
    this.intervalD,
    this.isRepeating = false,
  });

  Map<String, dynamic> toDB() {
    return {
      'carId': carId,
      'title': title,
      'category': category.label,
      'reminderType': reminderType.name,
      'dueM': dueMileage,
      'dueD': dueDate?.toIso8601String(),
      'repeatByM': repeatByM,
      'intervalM': intervalM,
      'repeatByD': repeatByD,
      'intervalD': intervalD,
      'isRepeating': isRepeating ? 1 : 0,
    };
  }

  factory MaintenanceReminder.fromDB(Map<String, dynamic> data) {
    return MaintenanceReminder(
      id: data['id'] as int,
      carId: data['carId'] as int,
      title: data['title'] as String,
      category: MaintenanceCategory.fromLabel(data['category'] as String?),
      reminderType: ReminderType.values.firstWhere(
        (type) => type.name == data['reminderType'],
      ),
      dueMileage: data['dueM'] as int?,
      dueDate: data['dueD'] == null
          ? null
          : DateTime.parse(data['dueD'] as String),
      repeatByM: data['repeatByM'] as int? ?? 0,
      intervalM: data['intervalM'] as int?,
      repeatByD: data['repeatByD'] as int? ?? 0,
      intervalD: data['intervalD'] as int?,
      isRepeating: data['isRepeating'] == 1,
    );
  }

  MaintenanceReminder copyWith({
    int? id,
    int? carId,
    String? title,
    MaintenanceCategory? category,
    ReminderType? reminderType,
    int? dueMileage,
    DateTime? dueDate,
    int? repeatByM,
    int? intervalM,
    int? repeatByD,
    int? intervalD,
    bool? isRepeating,
  }) {
    return MaintenanceReminder(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      title: title ?? this.title,
      category: category ?? this.category,
      reminderType: reminderType ?? this.reminderType,
      dueMileage: dueMileage ?? this.dueMileage,
      dueDate: dueDate ?? this.dueDate,
      repeatByM: repeatByM ?? this.repeatByM,
      intervalM: intervalM ?? this.intervalM,
      repeatByD: repeatByD ?? this.repeatByD,
      intervalD: intervalD ?? this.intervalD,
      isRepeating: isRepeating ?? this.isRepeating,
    );
  }
}
