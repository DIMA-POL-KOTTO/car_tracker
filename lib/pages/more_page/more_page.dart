import 'package:car_tracker/pages/more_page/settings_page.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class MorePage extends StatelessWidget {
  final void Function(Locale) onChangeLanguage;
  final void Function(ThemeMode) onChangeTheme;
  const MorePage({super.key, required this.onChangeLanguage, required this.onChangeTheme});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.more_page),
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 28,
          fontWeight: FontWeight.bold
        )
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(l10n.settings),
            trailing: const Icon(Icons.chevron_right),
            iconColor: colorScheme.onSurface,
            textColor: colorScheme.onSurface,
            onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    onChangeLanguage: onChangeLanguage,
                    onChangeTheme: onChangeTheme
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
