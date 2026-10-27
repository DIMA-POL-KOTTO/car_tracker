import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:car_tracker/models/maintenance_category.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/widgets/app_section_heading.dart';
import 'package:flutter/material.dart';

class HistoryMaintenancePage extends StatelessWidget {
  final Map<String, dynamic> history;

  const HistoryMaintenancePage({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final title = history['title']?.toString() ?? l10n.maintenance_page;
    final category = history['category']?.toString();
    final maintenanceCategory = MaintenanceCategory.fromLabel(category);
    final comment = history['comment']?.toString().trim();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.history_details),
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: AppTheme.primaryColor.withValues(alpha: 0.12),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: maintenanceCategory.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      maintenanceCategory.icon,
                      color: maintenanceCategory.color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (category != null && category.isNotEmpty) ...[
                          const SizedBox(height: 5),
                          Text(
                            category,
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          AppSectionHeading(title: l10n.maintenance_details),
          Card(
            color: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _DetailRow(
                    icon: Icons.event_outlined,
                    label: l10n.fuel_date,
                    value: _formatDate(history['date']?.toString()) ??
                        l10n.not_specified,
                  ),
                  _DetailRow(
                    icon: Icons.speed,
                    label: l10n.fuel_mileage,
                    value: _formatMileage(history['mileage'], l10n),
                  ),
                  _DetailRow(
                    icon: Icons.payments_outlined,
                    label: l10n.cost,
                    value: _formatCost(history['cost']) ?? l10n.not_specified,
                  ),
                  _DetailRow(
                    icon: Icons.notes_outlined,
                    label: l10n.comment,
                    value: comment == null || comment.isEmpty
                        ? l10n.not_specified
                        : comment,
                    isLast: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String? _formatDate(String? value) {
    if (value == null || value.isEmpty) return null;
    final parsedDate = DateTime.tryParse(value);
    if (parsedDate == null) return value;
    return '${parsedDate.day.toString().padLeft(2, '0')}.'
        '${parsedDate.month.toString().padLeft(2, '0')}.'
        '${parsedDate.year}';
  }

  static String _formatMileage(dynamic value, AppLocalizations l10n) {
    if (value == null) return l10n.not_specified;
    return '$value ${l10n.km}';
  }

  static String? _formatCost(dynamic value) {
    if (value == null) return null;
    final amount = value is num ? value.toDouble() : double.tryParse('$value');
    if (amount == null) return null;
    final formatted = amount == amount.roundToDouble()
        ? amount.toStringAsFixed(0)
        : amount.toStringAsFixed(2);
    return '$formatted BYN';
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: colorScheme.onSurfaceVariant, size: 21),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}
