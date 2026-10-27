import 'package:car_tracker/theme/app_theme.dart';
import 'package:flutter/material.dart';

class EmptyCarCard extends StatelessWidget {
  final VoidCallback onAdd;

  const EmptyCarCard({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.directions_car,
              size: 64,
              color: AppTheme.primaryColor,
            ),

            const SizedBox(height: 16),

            Text(
              'Автомобиль не добавлен',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Добавьте автомобиль, чтобы начать отслеживать его состояние и заправки.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Добавить автомобиль'),
            ),
          ],
        ),
      ),
    );
  }
}
