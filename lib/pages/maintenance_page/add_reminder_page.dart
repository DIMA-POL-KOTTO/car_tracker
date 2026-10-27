import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:car_tracker/pages/maintenance_page/complete_maintenance.dart';
import 'package:car_tracker/models/maintenance_reminder.dart';
import 'package:car_tracker/services/car_manager.dart';
import 'package:car_tracker/services/maintenance_manager.dart';
import 'package:car_tracker/widgets/app_label.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:car_tracker/widgets/app_text_field.dart';
import 'package:car_tracker/widgets/app_date_field.dart';
import 'package:car_tracker/widgets/app_dropdown_field.dart';
import 'package:car_tracker/models/maintenance_category.dart';

class AddReminderPage extends StatefulWidget {
  final MaintenanceReminder? reminder;

  const AddReminderPage({super.key, this.reminder});

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  final CarManager _carManager = CarManager.instance;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _currentMileageController = TextEditingController();
  final _intervalMileageController = TextEditingController();
  final _nextMileageController = TextEditingController();
  final _intervalMonthsController = TextEditingController();
  final _categories = MaintenanceCategory.values;
  MaintenanceCategory? _category = MaintenanceCategory.oilChange;
  bool _byMileage = true;
  DateTime _currentDate = DateTime.now();
  DateTime? _nextDate;
  bool _updatingNextMileage = false;
  bool _updatingNextDate = false;
  bool _isRepeating = false;
  @override
  void initState() {
    super.initState();
    final reminder = widget.reminder;
    if (reminder != null) {
      _titleController.text = reminder.title;
      _category = reminder.category;
      _byMileage = reminder.reminderType == ReminderType.mileage;
      _nextMileageController.text = reminder.dueMileage?.toString() ?? '';
      _intervalMileageController.text = reminder.intervalM?.toString() ?? '';
      _intervalMonthsController.text = reminder.intervalD?.toString() ?? '';
      _nextDate = reminder.dueDate;
      _isRepeating = reminder.isRepeating;
    }
    _currentMileageController.addListener(_recalculateMileage);
    _intervalMileageController.addListener(_recalculateMileage);
    _intervalMonthsController.addListener(_recalculateDate);
    if (reminder == null) {
      _recalculateDate();
    }
    _loadCurrentMileage();
  }

  Future<void> _loadCurrentMileage() async {
    await _carManager.init();
    if (!mounted) return;
    if (_carManager.cars.isEmpty) {
      return;
    }
    final car = _carManager.cars.first;
    _updatingNextMileage = true;
    _currentMileageController.text = car.mileage.toString();
    _updatingNextMileage = false;
    if (widget.reminder == null) {
      _recalculateMileage();
    }
  }

  void _recalculateMileage() {
    if (_updatingNextMileage) return;
    final currentMileage = int.tryParse(_currentMileageController.text);
    final interval = int.tryParse(_intervalMileageController.text);
    if (currentMileage == null ||
        interval == null ||
        currentMileage < 0 ||
        interval < 0) {
      return;
    }
    _updatingNextMileage = true;
    _nextMileageController.text = (currentMileage + interval).toString();
    _nextMileageController.selection = TextSelection.collapsed(
      offset: _nextMileageController.text.length,
    );
    _updatingNextMileage = false;
  }

  void _recalculateDate() {
    if (_updatingNextDate) return;
    final months = int.tryParse(_intervalMonthsController.text);
    if (months == null || months < 0) {
      setState(() {
        _nextDate = null;
      });
      return;
    }
    setState(() {
      _nextDate = _addMonths(_currentDate, months);
    });
  }

  DateTime _addMonths(DateTime date, int months) {
    final monthIndex = date.month - 1 + months;
    final year = date.year + monthIndex ~/ 12;
    final month = monthIndex % 12 + 1;
    final lastDay = DateTime(year, month + 1, 0).day;
    final day = date.day > lastDay ? lastDay : date.day;
    return DateTime(year, month, day);
  }

  Future<DateTime?> _pickDate(DateTime initialDate) {
    final now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 30),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme
                .copyWith(primary: AppTheme.primaryColor),
          ),
          child: child!,
        );
      },
    );
  }

  Future<void> _selectCurrentDate() async {
    final selected = await _pickDate(_currentDate);
    if (selected == null || !mounted) return;
    setState(() {
      _currentDate = selected;
      final months = int.tryParse(_intervalMonthsController.text);
      _nextDate = months != null && months > 0
          ? _addMonths(selected, months)
          : null;
    });
  }

  Future<void> _selectNextDate() async {
    final selected = await _pickDate(_nextDate ?? _currentDate);
    if (selected == null || !mounted) return;
    setState(() {
      _nextDate = selected;
      _updatingNextDate = true;
      _intervalMonthsController.clear();
      _updatingNextDate = false;
    });
  }

  Future<void> _saveReminder() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isRepeating && !_byMileage && _nextDate == null) {
      _showMessage('Выберите дату следующего ТО');
      return;
    }
    final carManager = CarManager.instance;
    await carManager.init();
    if (!mounted) return;
    if (carManager.cars.isEmpty) {
      return;
    }
    final car = carManager.cars.first;
    final existingReminder = widget.reminder;
    final reminder = MaintenanceReminder(
      id: existingReminder?.id,
      carId: existingReminder?.carId ?? car.id!,
      title: _titleController.text.trim(),
      category: _category!,
      reminderType:
          _byMileage ? ReminderType.mileage : ReminderType.date,
      dueMileage: _isRepeating && _byMileage
          ? int.parse(_nextMileageController.text)
          : null,
      dueDate: _isRepeating && !_byMileage ? _nextDate : null,
      repeatByM: existingReminder?.repeatByM ?? 0,
      intervalM: _isRepeating && _byMileage
          ? int.tryParse(_intervalMileageController.text)
          : null,
      repeatByD: existingReminder?.repeatByD ?? 0,
      intervalD: _isRepeating && !_byMileage
          ? int.tryParse(_intervalMonthsController.text)
          : null,
      isRepeating: _isRepeating,
    );
    try {
      if (existingReminder == null) {
        await MaintenanceManager.instance.add(reminder);
      } else {
        await MaintenanceManager.instance.update(reminder);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Сохранено')));
      Navigator.pop(context);
    } catch (err) {
      if (!mounted) return;
      _showMessage('Ошибка сохранения');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _currentMileageController.dispose();
    _intervalMileageController.dispose();
    _nextMileageController.dispose();
    _intervalMonthsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.reminder == null
              ? l10n.new_reminder
              : l10n.editing,
        ),
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppLabel(text: l10n.maintenance_name),
                AppTextField(
                  controller: _titleController,
                  hint: '${l10n.for_example}: ${l10n.oil_change}',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.enter_maintenance_name;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                AppLabel(text: l10n.category),
                AppDropdownField<MaintenanceCategory>(
                  value: _category,
                  hint: l10n.enter_categoty,
                  items: _categories.map((category) {
                    return DropdownMenuItem<MaintenanceCategory>(
                      value: category,
                      child: Text(category.label),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _category = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return l10n.enter_categoty;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: AppLabel(text: l10n.repeate_maintenance)),
                    Switch(
                      inactiveThumbColor: colorScheme.onSurfaceVariant,
                      activeThumbColor: colorScheme.onPrimary,
                      trackOutlineColor: WidgetStatePropertyAll(AppTheme.primaryColor.withValues(alpha: 0.12)),
                      activeTrackColor: AppTheme.primaryColor,
                      inactiveTrackColor: AppTheme.primaryColor.withValues(alpha: 0.04),
                      trackOutlineWidth: WidgetStatePropertyAll(1),
                      value: _isRepeating, 
                      onChanged: (value) {
                        setState(() {
                          _isRepeating = value;
                        });
                      }
                    ),
                  ]
                ),
                if (_isRepeating) ...[
                  AppLabel(text: l10n.reminder_type),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        _buildModeButton(
                          title: l10n.by_mileage,
                          selected: _byMileage,
                          onTap: () {
                            setState(() {
                              _byMileage = true;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildModeButton(
                          title: l10n.by_date,
                          selected: !_byMileage,
                          onTap: () {
                            setState(() {
                              _byMileage = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_byMileage) ...[
                    AppLabel(text: l10n.fuel_mileage),
                    AppTextField(
                      controller: _currentMileageController,
                      hint: l10n.enter_current_mileage,
                      suffix: l10n.km,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.enter_current_mileage;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    AppLabel(text: l10n.interval),
                    AppTextField(
                      controller: _intervalMileageController,
                      hint: "${l10n.for_example} 10 000",
                      suffix: l10n.km,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        final interval = int.tryParse(value ?? '');
                        if (interval == null || interval < 0) {
                          return l10n.enter_a_valid_interval;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    AppLabel(text: l10n.next_mileage),
                    AppTextField(
                      controller: _nextMileageController,
                      hint: l10n.calculated_automatically,
                      suffix: l10n.km,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        final next = int.tryParse(value ?? '');
                        final current = int.tryParse(
                          _currentMileageController.text,
                        );
                        if (next == null) {
                          return l10n.enter_next_mileage;
                        }
                        if (widget.reminder == null &&
                            current != null &&
                            next < current) {
                          return l10n.mileage_cannot_be_less_than_current;
                        }
                        return null;
                      },
                    ),
                  ] else ...[
                    AppLabel(text: l10n.fuel_date),
                    AppDateField(date: _currentDate, onTap: _selectCurrentDate),
                    const SizedBox(height: 8),
                    AppLabel(text: l10n.interval),
                    AppTextField(
                      controller: _intervalMonthsController,
                      hint: "${l10n.for_example}: 6",
                      suffix: l10n.mon_point,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        final months = int.tryParse(value ?? '');
                        if (months == null || months < 0) {
                          return l10n.enter_a_valid_interval;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    AppLabel(text:l10n.next_date),
                    AppDateField(
                      date: _nextDate,
                      placeholder: l10n.calculated_automatically,
                      onTap: _selectNextDate,
                    ),
                  ],
                
                ],
                
                const SizedBox(height: 16),
                widget.reminder != null
                    ? SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton(
                          onPressed: () async {
                            final completed = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CompleteMaintenance(
                                  reminder: widget.reminder!,
                                ),
                              ),
                            );
                            if (completed != true || !context.mounted) return;
                            Navigator.pop(context, true);
                          },

                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.green),
                            foregroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            l10n.complete,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(height: 0),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _saveReminder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      widget.reminder == null
                          ? l10n.save
                          : l10n.change,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(microseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: selected ? colorScheme.primary : colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
