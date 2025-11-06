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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 60),
              // Ladipo Logo - image logo
              Center(
                child: LadipoLogo(height: 50),
              ),
              const SizedBox(height: 20),

              // Tagline
              Text(
                'Essential care, all in one place.',
                textAlign: TextAlign.center,
                style: kBodyText.copyWith(fontSize: 16, color: kSubtextGray),
              ),
              const SizedBox(height: 40),

              // Email Field
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Email address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kPrimaryColor, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              const SizedBox(height: 20),

              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kPrimaryColor, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.visibility_outlined, color: kSubtextGray),
                    onPressed: () {},
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Forgot Password Link - aligned right
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                    );
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text(
                    'Forgot password?',
                    style: kBodyText.copyWith(color: kPrimaryColor, fontSize: 14),
                  ),
                ),
              ),
              
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0, top: 10),
                  child: Text(
                    _errorMessage!,
                    style: kBodyText.copyWith(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 20),
              // Login Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : Text('Login', style: kButtonText.copyWith(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?', style: kBodyText.copyWith(color: kTextColor)),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const SignupEmailScreen()),
                      );
                    },
                    style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4)),
                    child: Text('Signup', style: kBodyText.copyWith(color: kPrimaryColor, fontWeight: FontWeight.w600)),
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

// Forgot Password Screen
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                'Forgot password',
                style: kHeading1.copyWith(fontSize: 28),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              Text(
                'Enter your account email.',
                style: kBodyText.copyWith(color: kSubtextGray, fontSize: 16),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Email address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kPrimaryColor, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle forgot password
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password reset email sent!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text('Next', style: kButtonText.copyWith(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Signup Email Screen
class SignupEmailScreen extends StatefulWidget {
  const SignupEmailScreen({Key? key}) : super(key: key);

  @override
  State<SignupEmailScreen> createState() => _SignupEmailScreenState();
}

class _SignupEmailScreenState extends State<SignupEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Placeholder image
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: kLightGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.directions_car, size: 80, color: kSubtextGray),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Let\'s get started!',
                style: kHeading1.copyWith(fontSize: 28),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 30),
              Text(
                'Your Email',
                style: kBodyText.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kPrimaryColor, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SignupPasswordScreen(email: _emailController.text),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text('Next', style: kButtonText.copyWith(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    'By registering you accept our ',
                    style: kBodyText.copyWith(fontSize: 12, color: kSubtextGray),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Terms of use',
                      style: kBodyText.copyWith(fontSize: 12, color: kPrimaryColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    ' and ',
                    style: kBodyText.copyWith(fontSize: 12, color: kSubtextGray),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Privacy Policy',
                      style: kBodyText.copyWith(fontSize: 12, color: kPrimaryColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: kBodyText.copyWith(fontSize: 14, color: kTextColor),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Sign in',
                      style: kBodyText.copyWith(fontSize: 14, color: kPrimaryColor, fontWeight: FontWeight.w600),
                    ),
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

// Signup Password Screen
class SignupPasswordScreen extends StatefulWidget {
  final String email;

  const SignupPasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<SignupPasswordScreen> createState() => _SignupPasswordScreenState();
}

class _SignupPasswordScreenState extends State<SignupPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Placeholder image
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: kLightGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.lock_outline, size: 60, color: kSubtextGray),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Create a password',
                style: kHeading1.copyWith(fontSize: 28),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 30),
              Text(
                'Password',
                style: kBodyText.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kPrimaryColor, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: kSubtextGray,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'At least 8 characters, containing a letter and a number',
                style: kBodyText.copyWith(fontSize: 12, color: kSubtextGray),
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle signup completion
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Account created successfully!')),
                    );
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text('Next', style: kButtonText.copyWith(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    'By registering you accept our ',
                    style: kBodyText.copyWith(fontSize: 12, color: kSubtextGray),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Terms of use',
                      style: kBodyText.copyWith(fontSize: 12, color: kPrimaryColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    ' and ',
                    style: kBodyText.copyWith(fontSize: 12, color: kSubtextGray),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Privacy Policy',
                      style: kBodyText.copyWith(fontSize: 12, color: kPrimaryColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: kBodyText.copyWith(fontSize: 14, color: kTextColor),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Text(
                      'Sign in',
                      style: kBodyText.copyWith(fontSize: 14, color: kPrimaryColor, fontWeight: FontWeight.w600),
                    ),
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
