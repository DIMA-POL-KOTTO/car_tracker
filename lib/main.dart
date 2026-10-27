import 'package:car_tracker/pages/home_page/home_page.dart';
import 'package:car_tracker/pages/fuel_page/fuel_page.dart';
import 'package:car_tracker/pages/maintenance_page/maintenance_page.dart';
import 'package:car_tracker/pages/more_page/more_page.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/services/scan_manager.dart';

void main() {
  runApp(const CarCareApp());
}

class CarCareApp extends StatefulWidget {
  const CarCareApp({super.key});
  

  @override
  State<CarCareApp> createState() => _CarCareAppState();
}

class _CarCareAppState extends State<CarCareApp> {
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.light;
  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }
  void changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CarCare',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru', ''), // Русский
        Locale('en', ''), // Английский
      ],
      home: MainScreen(
        onChangeLanguage: changeLanguage,
        onChangeTheme: changeTheme,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final void Function(Locale) onChangeLanguage;
  final void Function(ThemeMode) onChangeTheme;
  const MainScreen({super.key, required this.onChangeLanguage, required this.onChangeTheme});

  @override
  State<MainScreen> createState() => _MainScreenState();
  
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final ScanManager _scanManager = ScanManager.instance;

  @override
  void initState(){
    super.initState();
    _scanManager.addListener(_onScanChanged);
  }

  @override
  void dispose() {
    _scanManager.removeListener(_onScanChanged);
    super.dispose();
  }

  void _onScanChanged() {
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<Widget> pages = [
      const HomePage(),
      const FuelPage(),
      const MaintenancePage(),
      MorePage(onChangeLanguage: widget.onChangeLanguage, onChangeTheme: widget.onChangeTheme),
    ];
    return Scaffold(
      body: Stack(children: [
        pages[_selectedIndex],
        
      ],),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,

        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.home_page,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.local_gas_station),
            label: l10n.fuel_page,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.build),
            label: l10n.maintenance_page,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.more_horiz),
            label: l10n.more_page,
          ),
        ],
      )
    );
  }
} 



