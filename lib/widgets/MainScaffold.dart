import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/auth_provider.dart';

class MainScaffold extends StatefulWidget {
  final Widget child;
  final int selectedIndex;
  const MainScaffold({Key? key, required this.child, required this.selectedIndex}) : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  bool isRailExtended = false;

  void toggleRail() {
    setState(() {
      isRailExtended = !isRailExtended;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        elevation: 4,
        title: const Text("NightOwl", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: toggleRail,
        ),
      ),
      body: Row(
        children: [
          NavigationRail(
            extended: isRailExtended,
            backgroundColor: Colors.black,
            selectedIndex: widget.selectedIndex >= 0 ? widget.selectedIndex : null,
            onDestinationSelected: (int index) {
              final routes = [
                '/analytics',
                '/settings',
                '/history',
                '/smart_alarm',
                '/tracker',
                '/lullabies',
                '/quotes',
                '/tips'
              ];

              if (index == 8) {
                // Logout
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        child: const Text("Cancel"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: const Text("Logout"),
                        onPressed: () {
                          authProvider.logout();
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                    ],
                  ),
                );
              } else {
                Navigator.pushReplacementNamed(context, routes[index]);
              }
            },
            leading: Column(
              children: [
                const SizedBox(height: 16),
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
                const SizedBox(height: 8),
                AnimatedCrossFade(
                  crossFadeState: isRailExtended
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 300),
                  firstChild: Column(
                    children: [
                      Text(
                        user?.name ?? 'Night Owl',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        user?.email ?? 'user@example.com',
                        style: const TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      const Divider(color: Colors.white24),
                    ],
                  ),
                  secondChild: const SizedBox.shrink(),
                ),
              ],
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.analytics),
                label: Text('Analytics'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.history),
                label: Text('Sleep History'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.alarm),
                label: Text('Smart Alarm'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.nightlight_round),
                label: Text('Tracker'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.music_note),
                label: Text('Lullaby'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.format_quote),
                label: Text('Quotes'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.lightbulb),
                label: Text('Tips'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.logout),
                label: Text('Logout'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, color: Colors.white12),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}