import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/providers/auth_provider.dart';
import 'data/providers/theme_provider.dart';
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
  const NightOwlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, ThemeProvider>(
      builder: (context, authProvider, themeProvider, _) {
        return MaterialApp(
          title: 'NightOwl',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.indigo,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.indigo,
            useMaterial3: true,
          ),
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: '/onboarding',
          routes: {
            '/onboarding': (context) => OnboardingPage(),
            '/login': (context) => const LoginPage(),
            '/signup': (context) => const SignupPage(),
            '/dashboard': (context) => authProvider.currentUser != null
                ? const DashboardPage()
                : const LoginPage(),
            '/tracker': (context) => TrackerPage(),
            '/add_sleep': (context) => AddSleepPage(),
            '/smart_alarm': (context) => const SmartAlarmPage(),
            '/history': (context) => SleepHistoryPage(),
            '/analytics': (context) => const AnalyticsPage(),
            '/tips': (context) => TipsPage(),
            '/settings': (context) => const SettingsPage(),
            '/quotes': (context) => const Placeholder(),
          },
        );
      },
    );
  }
}
