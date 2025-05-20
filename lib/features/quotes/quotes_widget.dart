import 'package:flutter/material.dart';
import 'dart:math';
import '../../core/utils/quotes_loader.dart';

class QuotesWidget extends StatefulWidget {
const QuotesWidget({Key? key}) : super(key: key);


  @override
  State<QuotesWidget> createState() => _QuotesWidgetState();
}

class _QuotesWidgetState extends State<QuotesWidget> with SingleTickerProviderStateMixin {
  List<String> quotes = [];
  int currentIndex = 0;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    loadQuotes();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void loadQuotes() async {
    final loadedQuotes = await QuotesLoader.loadQuotes();
    setState(() {
      quotes = loadedQuotes;
      currentIndex = Random().nextInt(quotes.length);
    });
    _controller.forward();
  }

  void showNextQuote() {
    _controller.reverse().then((_) {
      setState(() {
        currentIndex = (currentIndex + 1) % quotes.length;
      });
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('Sleep Quotes'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: quotes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 12,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.format_quote, size: 40, color: Colors.blueAccent),
                          const SizedBox(height: 20),
                          Text(
                            quotes[currentIndex],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontStyle: FontStyle.italic,
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: showNextQuote,
                            icon: const Icon(Icons.navigate_next),
                            label: const Text('Next Quote'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
