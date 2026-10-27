import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:car_tracker/models/maintenance_reminder.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/utils.dart';

class ReminderCard extends StatelessWidget {
  final MaintenanceReminder reminder;
  final VoidCallback? onTap;
  final Color? urgencyColor;

  const ReminderCard({super.key, required this.reminder, this.onTap, this.urgencyColor});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final isMileageReminder = reminder.reminderType == ReminderType.mileage;
    final dueMileage = reminder.dueMileage;
    final dueDate = reminder.dueDate;
    final hasDueMileage = dueMileage != null;
    final hasDueDate = dueDate != null;

    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: EdgeInsets.zero,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.12)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: reminder.category.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      reminder.category.icon,
                      color: reminder.category.color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reminder.title,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reminder.category.label,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (urgencyColor != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: urgencyColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
              if ((isMileageReminder && hasDueMileage) ||
                  (!isMileageReminder && hasDueDate)) ...[
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      isMileageReminder ? Icons.speed : Icons.calendar_today,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isMileageReminder
                            ? '${l10n.next_maintenance}: $dueMileage ${l10n.km}'
                            : '${l10n.next_maintenance}: ${formatDate(dueDate!)}',
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
