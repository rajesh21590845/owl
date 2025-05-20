import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/auth_provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: 0,
            labelType: NavigationRailLabelType.all,
            leading: Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
                const SizedBox(height: 8),
                Text(
                  user?.name ?? 'Night Owl',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  user?.email ?? 'user@example.com',
                  style: const TextStyle(fontSize: 12),
                ),
                const Divider(thickness: 1),
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
            onDestinationSelected: (int index) {
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, '/analytics');
                  break;
                case 1:
                  Navigator.pushNamed(context, '/settings');
                  break;
                case 2:
                  Navigator.pushNamed(context, '/history');
                  break;
                case 3:
                  Navigator.pushNamed(context, '/smart_alarm');
                  break;
                case 4:
                  Navigator.pushNamed(context, '/tracker');
                  break;
                case 5:
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Lullaby playback coming soon!')),
                  );
                  break;
                case 6:
                  Navigator.pushNamed(context, '/quotes');
                  break;
                case 7:
                  Navigator.pushNamed(context, '/tips');
                  break;
                case 8:
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
                  break;
              }
            },
          ),
          const VerticalDivider(thickness: 1),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/dashboard_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Welcome to NightOwl",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Track. Sleep. Improve.",
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
