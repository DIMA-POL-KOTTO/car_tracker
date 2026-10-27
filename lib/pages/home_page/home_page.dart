import 'package:car_tracker/pages/fuel_page/fuel_form.dart';
import 'package:car_tracker/pages/home_page/add_car_page.dart';
import 'package:car_tracker/pages/maintenance_page/add_reminder_page.dart';
import 'package:car_tracker/services/car_manager.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:car_tracker/models/maintenance_reminder.dart';
import 'package:car_tracker/services/maintenance_manager.dart';
import 'package:car_tracker/widgets/app_section_heading.dart';
import 'package:car_tracker/widgets/car_empty_card.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/models/car.dart';
import 'package:car_tracker/widgets/car_card.dart';
import 'package:car_tracker/widgets/fuel_card.dart';
import 'package:car_tracker/widgets/reminder_card.dart';
import 'package:car_tracker/services/fuel_manager.dart';
import 'package:car_tracker/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CarManager _carManager = CarManager.instance; //один на всё приложение
  final FuelManager _fuelManager = FuelManager.instance;
  final MaintenanceManager _maintenanceManager = MaintenanceManager.instance;

  @override
  void initState() {
    super.initState();
    _carManager.addListener(_onCarChanged);
    _carManager.init();
    _fuelManager.addListener(_onFuelChanged);
    _fuelManager.init();
    _maintenanceManager.addListener(_onMaintenanceChanged);
    _maintenanceManager.init();
  }

  @override
  void dispose() {
    _carManager.removeListener(_onCarChanged);
    _fuelManager.removeListener(_onFuelChanged);
    _maintenanceManager.removeListener(_onMaintenanceChanged);
    super.dispose();
  }

  void _onCarChanged() {
    setState(() {});
  }

  void _onFuelChanged() {
    setState(() {});
  }

  void _onMaintenanceChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home_page),
        titleTextStyle: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 28,
          fontWeight: FontWeight.bold
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildContent(l10n)
      ),
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    final List<Widget> children = [];
    if (_carManager.cars.isEmpty) {
      return EmptyCarCard(onAdd: () async { 
        await Navigator.push(context, MaterialPageRoute(
          builder: (context) => const AddCarPage()));
        });
    }
    else {
      Car car = _carManager.cars.first;
      children.add(CarCard(car: car, l10n: l10n, onDelete: () async {await _carManager.delete(car.id!);
        }, 
        onUpdate: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddCarPage(car: car)));
        },
        onUpdateMileage: (mileage) async {
          await _carManager.updateMileage(car.id!, mileage);
        },
      ),);
    }
    children.addAll([
      const SizedBox(height: 16,),
      AppSectionHeading(title: l10n.last_refill),
      _buildLastFuel(l10n),
      const SizedBox(height: 16),
      _buildUpcomingMaintenance(l10n),
    ]);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildLastFuel(AppLocalizations l10n) {
    if (_fuelManager.entries.isEmpty) {
      return Card(
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              l10n.no_refills_yet,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      );
    }
    return FuelCard(
      entry: _fuelManager.entries.first,
      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => FuelForm(entry: _fuelManager.entries.first, isEditing: true,)));},
    );
  }

  Widget _buildUpcomingMaintenance(AppLocalizations l10n) {
    final currentMileage = _carManager.cars.isEmpty
        ? null
        : _carManager.cars.first.mileage;
    final overdueReminders = <MapEntry<MaintenanceReminder, Color>>[];
    final upcomingReminders = <MapEntry<MaintenanceReminder, Color>>[];

    for (final reminder in _maintenanceManager.reminders) {
      final urgencyColor = maintenanceUrgencyColor(reminder, currentMileage);
      final entry = MapEntry(reminder, urgencyColor);
      if (urgencyColor == Colors.red) {
        overdueReminders.add(entry);
      } else if (urgencyColor == Colors.amber) {
        upcomingReminders.add(entry);
      }
    }

    final reminders = [...overdueReminders, ...upcomingReminders];
    if (reminders.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeading(title: l10n.nearest_maintenance),
        ...reminders.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ReminderCard(
              reminder: entry.key,
              urgencyColor: entry.value,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddReminderPage(reminder: entry.key),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
