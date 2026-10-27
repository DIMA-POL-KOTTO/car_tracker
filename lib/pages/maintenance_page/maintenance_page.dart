import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:car_tracker/widgets/app_section_heading.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/pages/maintenance_page/add_reminder_page.dart';
import 'package:car_tracker/pages/maintenance_page/history_maintenance.dart';
import 'package:car_tracker/models/maintenance_reminder.dart';
import 'package:car_tracker/services/car_manager.dart';
import 'package:car_tracker/services/maintenance_manager.dart';
import 'package:car_tracker/widgets/history_maintenance_card.dart';
import 'package:car_tracker/widgets/reminder_card.dart';
import 'package:car_tracker/utils.dart';

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({super.key});

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  final CarManager _carManager = CarManager.instance;
  final MaintenanceManager _maintenanceManager = MaintenanceManager.instance;
  final Set<int> _selectedHistoryIds = {};
  bool _isHistorySelectionMode = false;

  @override
  void initState() {
    super.initState();
    _carManager.addListener(_onCarManagerChanged);
    _maintenanceManager.addListener(_onMaintenanceChanged);
    _carManager.init();
    _maintenanceManager.init();
  }

  void _onCarManagerChanged() {
    if (mounted) setState(() {});
  }

  void _onMaintenanceChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _openReminderForm({MaintenanceReminder? reminder}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddReminderPage(reminder: reminder),
      ),
    );
  }

  @override
  void dispose() {
    _carManager.removeListener(_onCarManagerChanged);
    _maintenanceManager.removeListener(_onMaintenanceChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isHistorySelectionMode
              ? '${l10n.selected}: ${_selectedHistoryIds.length}'
              : l10n.maintenance_page,
        ),
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          if (_isHistorySelectionMode)
            IconButton(
              onPressed: _selectedHistoryIds.isEmpty
                  ? null
                  : _confirmDeleteHistory,
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildContent(l10n),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_maintenance_button',
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: colorScheme.onPrimary,
        onPressed: () => _openReminderForm(),
        child: const Icon(Icons.add, size: 31),
      ),
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    final reminders = _maintenanceManager.reminders;
    final history = _maintenanceManager.history;
    final currentMileage = _carManager.cars.isEmpty
        ? null
        : _carManager.cars.first.mileage;

    if (reminders.isEmpty && history.isEmpty) {
      return Center(child: Text(l10n.no_maintenance_reminders_yet));
    }

    return ListView(
      children: [
        if (reminders.isNotEmpty) ...[
          AppSectionHeading(title: l10n.reminders),
          ...reminders.map(
            (reminder) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ReminderCard(
                reminder: reminder,
                urgencyColor: maintenanceUrgencyColor(reminder, currentMileage),
                onTap: () => _openReminderForm(reminder: reminder),
              ),
            ),
          ),
        ],
        if (history.isNotEmpty) ...[
          AppSectionHeading(title: l10n.history),
          ...history.map(_buildHistoryCard),
        ],
      ],
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> entry) {
    final id = entry['id'];
    final isSelected = id is int && _selectedHistoryIds.contains(id);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: HistoryMaintenanceCard(
        history: entry,
        leading: _isHistorySelectionMode && id is int
            ? Checkbox(
                value: isSelected,
                onChanged: (_) => _toggleHistorySelection(id),
              )
            : null,
        onLongPress: id is int ? () => _startHistorySelection(id) : null,
        onTap: () {
          if (_isHistorySelectionMode) {
            if (id is int) _toggleHistorySelection(id);
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryMaintenancePage(history: entry),
            ),
          );
        },
      ),
    );
  }

  void _startHistorySelection(int id) {
    setState(() {
      _isHistorySelectionMode = true;
      _selectedHistoryIds.add(id);
    });
  }

  void _toggleHistorySelection(int id) {
    setState(() {
      if (_selectedHistoryIds.contains(id)) {
        _selectedHistoryIds.remove(id);
      } else {
        _selectedHistoryIds.add(id);
      }
      if (_selectedHistoryIds.isEmpty) {
        _isHistorySelectionMode = false;
      }
    });
  }

  Future<void> _confirmDeleteHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить записи ТО?'),
        content: Text('Выбрано ${_selectedHistoryIds.length}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await _maintenanceManager.deleteHistoryEntries(_selectedHistoryIds);
    if (!mounted) return;
    setState(() {
      _selectedHistoryIds.clear();
      _isHistorySelectionMode = false;
    });
  }
}
