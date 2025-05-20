import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/auth_provider.dart';

class SignupPage extends StatelessWidget {
  final String? prefillEmail;

  const SignupPage({Key? key, this.prefillEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController(text: prefillEmail ?? '');
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21), // Dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1E33),
        title: const Text("Sign Up"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person, size: 80, color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                'Create Account',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);
                    authProvider.login(
                        emailController.text, "user@example.com");
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Register", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
