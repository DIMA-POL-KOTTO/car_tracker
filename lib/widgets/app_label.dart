import 'package:flutter/material.dart';
import 'package:car_tracker/theme/app_theme.dart';

class AppLabel extends StatelessWidget{
  final String text;

  const AppLabel ({super.key, required this.text});

  @override
   Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(color: AppTheme.textColor, fontSize: 15),
      ),
    );
  }
}
  
 