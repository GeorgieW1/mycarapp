import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'login_screen.dart'; // IAuthService is likely defined here
import 'user_model.dart'; // User model definition
import 'shared_widgets.dart'; // Shared styles and widgets
import 'consults_screen.dart'; // Consultations Page
import 'onboarding_flow.dart'; // Import the onboarding flow
import 'package:rxdart/rxdart.dart';

// --- Global Theme & Styles (Now leveraging shared_widgets.dart) ---
final ThemeData kAppTheme = ThemeData(
  primaryColor: kPrimaryColor,
  scaffoldBackgroundColor: kBackgroundColor,
  fontFamily: 'Inter',
  appBarTheme: const AppBarTheme(
    backgroundColor: kBackgroundColor,
    elevation: 0,
    iconTheme: IconThemeData(color: kTextColor),
    titleTextStyle: TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w700,
      fontSize: 20,
      color: kTextColor,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kPrimaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      textStyle: kButtonText,
    ),
  ),
);

// --- 2. Auth Service (Simulated) ---
class AuthService implements IAuthService {
  final _authStreamController = BehaviorSubject<User?>.seeded(null);
  Stream<User?> get user => _authStreamController.stream;

  final String fixedEmail = "user@ladipo.com";
  final String fixedPassword = "password";

  static const String _authKey = 'is_authenticated';
  static const String _userDisplayNameKey = 'user_display_name';

  AuthService() {
    _loadAuthStatus();
  }

  Future<void> _loadAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isAuthenticated = prefs.getBool(_authKey) ?? false;
    final displayName = prefs.getString(_userDisplayNameKey) ?? 'Emmanuel';

    if (isAuthenticated) {
      final authenticatedUser = User(
          uid: 'fixed-user-id',
          email: fixedEmail,
          displayName: displayName);
      _authStreamController.add(authenticatedUser);
    }
  }

  Future<User?> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (email == fixedEmail && password == fixedPassword) {
      final authenticatedUser = User(
          uid: 'fixed-user-id',
          email: fixedEmail,
          displayName: 'Emmanuel');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_authKey, true);
      await prefs.setString(_userDisplayNameKey, authenticatedUser.displayName);

      _authStreamController.add(authenticatedUser);
      return authenticatedUser;
    }
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_authKey, false);
    // --- ADDED: Also clear the display name on logout ---
    await prefs.remove(_userDisplayNameKey);
    _authStreamController.add(null);
  }

  void dispose() {
    _authStreamController.close();
  }
}

// Global instance
final AuthService _authService = AuthService();
// SharedPreferences key for onboarding
const String _onboardingKey = 'has_completed_onboarding';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LadipoApp());
}

// --- UPDATED: LadipoApp is now a StatefulWidget ---
class LadipoApp extends StatefulWidget {
  const LadipoApp({Key? key}) : super(key: key);

  @override
  State<LadipoApp> createState() => _LadipoAppState();
}

class _LadipoAppState extends State<LadipoApp> {
  bool _isLoading = true;
  bool _hasCompletedOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  /// Checks SharedPreferences to see if onboarding has been completed.
  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompleted = prefs.getBool(_onboardingKey) ?? false;

    if (!hasCompleted) {
      // --- THIS IS THE FIX ---
      // If onboarding isn't done, we must ensure the user is logged out.
      // This prevents auto-login from a previous session before onboarding.
      await _authService.logout();
    }

    setState(() {
      _hasCompletedOnboarding = hasCompleted;
      _isLoading = false;
    });
  }

  /// Marks onboarding as complete in SharedPreferences and updates state.
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);

    setState(() {
      _hasCompletedOnboarding = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ladipo App',
      theme: kAppTheme,
      debugShowCheckedModeBanner: false,
      home: _buildHome(),
    );
  }

  /// Determines which screen to show based on loading and onboarding state.
  Widget _buildHome() {
    if (_isLoading) {
      // Show loading spinner while checking SharedPreferences
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: kPrimaryColor)),
      );
    }

    if (!_hasCompletedOnboarding) {
      // If onboarding is not complete, show the OnboardingFlow
      return OnboardingFlow(
        onOnboardingComplete: _completeOnboarding,
      );
    }

    // If onboarding IS complete, show the main app (auth flow)
    return StreamBuilder<User?>(
      stream: _authService.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // This "waiting" is for the auth stream, not the onboarding check
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: kPrimaryColor)),
          );
        }
        final user = snapshot.data;

        if (user != null) {
          return MainAppShell(user: user, onLogout: _authService.logout);
        } else {
          // This will now be shown after onboarding is complete
          return LoginScreen(authService: _authService);
        }
      },
    );
  }
}

// --- 3. Main App Shell (Unchanged) ---
class MainAppShell extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;

  const MainAppShell({Key? key, required this.user, required this.onLogout})
      : super(key: key);

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(
        user: widget.user,
        onLogout: widget.onLogout,
        onNavigate: _onItemTapped,
      ),
      const ConsultsScreen(),
      const Center(child: Text('My Cars Page')),
      const Center(child: Text('Profile Page')),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

