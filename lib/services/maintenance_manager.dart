import 'package:car_tracker/models/maintenance_reminder.dart';
import 'package:car_tracker/services/db.dart';
import 'package:flutter/foundation.dart';

class MaintenanceManager extends ChangeNotifier {
  MaintenanceManager._();

  static final MaintenanceManager instance = MaintenanceManager._();

  final List<MaintenanceReminder> reminders = [];
  final List<Map<String, dynamic>> history = [];
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    final db = await DatabaseService.instance.database;
    final reminderRows = await db.query('maintenance_reminders', orderBy: 'id DESC');
    final historyRows = await db.query('maintenance_history', orderBy: 'id DESC');
    reminders.clear();
    for (final row in reminderRows) {
      reminders.add(MaintenanceReminder.fromDB(row));
    }
    history
      ..clear()
      ..addAll(historyRows.map(Map<String, dynamic>.from));

    notifyListeners();
  }

  Future<void> add(MaintenanceReminder reminder) async {
    final db = await DatabaseService.instance.database;
    final id = await db.insert('maintenance_reminders', reminder.toDB());
    reminders.insert(0, reminder.copyWith(id: id));
    notifyListeners();
  }

  Future<void> update(MaintenanceReminder reminder) async {
    final id = reminder.id;
    if (id == null) {
      throw ArgumentError('Reminder must have an id');
    }
    final db = await DatabaseService.instance.database;
    await db.update('maintenance_reminders', reminder.toDB(), where: 'id = ?', whereArgs: [id]);
    final index = reminders.indexWhere((item) => item.id == id);
    if (index != -1) {
      reminders[index] = reminder;
    }
    reminders.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
    notifyListeners();
  }

  Future<void> deleteReminders(Set<int> ids) async {
    if (ids.isEmpty) return;

    final db = await DatabaseService.instance.database;
    final placeholders = List.filled(ids.length, '?').join(',');
    await db.delete(
      'maintenance_reminders',
      where: 'id IN ($placeholders)',
      whereArgs: ids.toList(),
    );

    reminders.removeWhere(
      (reminder) => reminder.id != null && ids.contains(reminder.id),
    );
    notifyListeners();
  }

  Future<void> deleteHistoryEntries(Set<int> ids) async {
    if (ids.isEmpty) return;

    final db = await DatabaseService.instance.database;
    final placeholders = List.filled(ids.length, '?').join(',');
    await db.delete(
      'maintenance_history',
      where: 'id IN ($placeholders)',
      whereArgs: ids.toList(),
    );

    history.removeWhere((entry) => ids.contains(entry['id']));
    notifyListeners();
  }

  Future<void> completeReminder(Map<String, dynamic> historyEntry) async {
    final reminderId = historyEntry['reminderId'];
    if (reminderId is! int) {
      throw ArgumentError('History entry must have an integer reminderId');
    }

    final db = await DatabaseService.instance.database;
    final historyId = await db.transaction<int>((transaction) async {
      final id = await transaction.insert('maintenance_history', historyEntry);
      final deleted = await transaction.delete(
        'maintenance_reminders',
        where: 'id = ?',
        whereArgs: [reminderId],
      );
      if (deleted == 0) {
        throw StateError('Reminder $reminderId does not exist');
      }
      return id;
    });

    history.insert(0, {...historyEntry, 'id': historyId});
    reminders.removeWhere((reminder) => reminder.id == reminderId);
    notifyListeners();
  }
}
