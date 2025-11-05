// lib/login_screen.dart

import 'package:flutter/material.dart';
import 'shared_widgets.dart'; // Import kPrimaryColor and kAppTheme
import 'user_model.dart'; // <-- IMPORT THE CANONICAL USER MODEL

// Define the AuthService contract (since we can't import the implementation from main.dart)
abstract class IAuthService {
  Future<User?> login(String email, String password);
}

// REMOVED: Simple User class to avoid main.dart dependency (now imported from user_model.dart)
// REMOVED: class User { ... }

class LoginScreen extends StatefulWidget {
  final IAuthService authService;

  const LoginScreen({Key? key, required this.authService}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController(text: 'user@ladipo.com');
  final TextEditingController _passwordController = TextEditingController(text: 'password');
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    final user = await widget.authService.login(email, password);

    if (user == null) {
      setState(() {
        _errorMessage = 'Invalid email or password.';
        _isLoading = false;
      });
    }
    // If successful, MainAppShell handles navigation via the StreamBuilder
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Ladipo Logo/Text
              Text(
                'ladipo.com',
                textAlign: TextAlign.center,
                style: kLargeTitle.copyWith(fontSize: 40, color: kDeepBlue),
              ),
              const SizedBox(height: 50),

              Text(
                'Let\'s get started!',
                style: kHeading1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Email Field
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email address',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.email_outlined, color: kPrimaryColor),
                ),
              ),
              const SizedBox(height: 20),

              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.lock_outline, color: kPrimaryColor),
                ),
              ),
              const SizedBox(height: 10),

              // Forgot Password Link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Navigate to forgot password screen
                  },
                  child: Text('Forgot password?', style: kBodyText.copyWith(color: kPrimaryColor)),
                ),
              ),
              
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    _errorMessage!,
                    style: kBodyText.copyWith(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Login Button
              ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Login'),
              ),
              const SizedBox(height: 20),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?', style: kBodyText.copyWith(color: kTextColor)),
                  TextButton(
                    onPressed: () {
                      // Navigate to sign up screen
                    },
                    child: Text('Sign up', style: kBodyText.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
