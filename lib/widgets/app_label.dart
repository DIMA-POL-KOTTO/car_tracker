import 'package:flutter/material.dart';

class AppLabel extends StatelessWidget{
  final String text;

  const AppLabel ({super.key, required this.text});

  @override
   Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(color: colorScheme.onSurface, fontSize: 15),
      ),
    );
  }
}
