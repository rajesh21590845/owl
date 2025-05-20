import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/providers/auth_provider.dart';
import 'features/auth/login_page.dart';
import 'features/auth/signup_page.dart';
import 'features/auth/onboarding_page.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/sleep_tracker/tracker_page.dart';
import 'features/sleep_tracker/add_sleep_page.dart';
import 'features/sleep_tracker/smart_alarm_page.dart';
import 'features/history/sleep_history_page.dart';
import 'features/analytics/analytics_page.dart';
import 'features/tips/tips_page.dart';
import 'features/settings/settings_page.dart';

class NightOwlApp extends StatelessWidget {
  NightOwlApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return MaterialApp(
          title: 'NightOwl',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            brightness: Brightness.light,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.indigo,
            useMaterial3: true,
          ),
          themeMode: ThemeMode.system,
          initialRoute: '/onboarding',
          routes: {
            '/onboarding': (context) => OnboardingPage(),
            '/login': (context) => LoginPage(),
            '/signup': (context) => SignupPage(),
            '/dashboard': (context) => authProvider.currentUser != null
                ? DashboardPage()
                : LoginPage(),
            '/tracker': (context) => TrackerPage(),
            '/add_sleep': (context) => AddSleepPage(),
            '/smart_alarm': (context) => SmartAlarmPage(),
            '/history': (context) => SleepHistoryPage(),
            '/analytics': (context) => AnalyticsPage(),
            '/tips': (context) => TipsPage(),
            '/settings': (context) => SettingsPage(
                  onThemeToggle: () {
                    print("Theme toggled");
                  },
                ),
            '/quotes': (context) =>
                Placeholder(), // Replace with actual quotes widget
          },
        );
      },
    );
  }
}
