import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/stars_overlay.png',
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    isLastPage = index == 3;
                  });
                },
                children: [
                  buildPage(
                    title: 'Track Your Sleep',
                    description: 'Understand your sleep patterns and improve your rest.',
                    imageAsset: 'assets/images/onboarding_sleep.png',
                  ),
                  buildPage(
                    title: 'Smart Alarm',
                    description: 'Wake up refreshed with intelligent alarm scheduling.',
                    imageAsset: 'assets/images/onboarding_alarm.png',
                  ),
                  buildPage(
                    title: 'Sleep Analytics',
                    description: 'Get insights into your sleep habits and progress.',
                    imageAsset: 'assets/images/onboarding_analytics.png',
                  ),
                  buildPage(
                    title: 'Wake Up Refreshed',
                    description: 'Start your day energized with smart wake-up times.',
                    imageAsset: 'assets/images/onboarding_wakeup.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? Container(
              color: Colors.black,
              height: 80,
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  print("Navigating to login...");
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text('Get Started'),
              ),
            )
          : Container(
              color: Colors.black,
              height: 80,
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  _controller.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: Text(
                  'Next',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
    );
  }

  Widget buildPage({
    required String title,
    required String description,
    required String imageAsset,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imageAsset, height: 250),
        SizedBox(height: 24),
        Text(
          title,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Text(
          description,
          style: TextStyle(fontSize: 16, color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
