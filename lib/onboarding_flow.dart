import 'package:flutter/material.dart';
import 'shared_widgets.dart';
// Removed: import 'main.dart'; // This caused a circular dependency

// --- 1. DESIGN CONSTANTS ---
const Color kPrimaryBlue = Color(0xFF0099CD); // Primary Color
const Color kDarkBlueAccent = Color(0xFF0099CD); // Primary Color (same as primary)
const Color kTextDarkGray = Color(0xFF111827); // Text Gray
const Color kTextMediumGray = Color(0xFF6B7280); // Subtext Gray
const Color kBackgroundWhite = Color(0xFFFFFFFF); // Neutral Background
const Color kBackgroundSecondary = Color(0xFFE3F6FB); // Secondary/Backup Background Color
const Color kLightGrayBorder = Color(0xFFE5E7EB); // Input Border

// Text Styles
const TextStyle kHeadingStyle = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 24,
  fontWeight: FontWeight.w700,
  color: kTextDarkGray,
);

const TextStyle kDescriptionStyle = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: kTextMediumGray,
);

const TextStyle kButtonTextStyle = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 16,
  fontWeight: FontWeight.w500,
  letterSpacing: 0.5,
);

const TextStyle kBodyText = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: kTextDarkGray,
);

// --- 2. MAIN APPLICATION WIDGET (UPDATED) ---

class OnboardingFlow extends StatefulWidget {
  // UPDATED: Renamed callbacks to a single, clear one
  final VoidCallback onOnboardingComplete;

  const OnboardingFlow({
    Key? key,
    required this.onOnboardingComplete,
  }) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  // 0: Splash, 1: Onboarding, 2: Done
  int _currentState = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _currentState = 1;
        });
      }
    });
  }

  /// This function will be called by OnboardingScreens when it's done.
  void _transitionToDone() {
    setState(() {
      _currentState = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentState == 0) {
      return const SplashScreen();
    } else if (_currentState == 1) {
      // Pass the _transitionToDone callback to OnboardingScreens
      return OnboardingScreens(
        onStart: _transitionToDone,
        onLogin: _transitionToDone,
      );
    } else {
      // State 2: Call the parent (main.dart) callback
      widget.onOnboardingComplete();
      // Return an empty container while main.dart rebuilds
      return Container(color: kBackgroundWhite);
    }
  }
}

// --- 3. SPLASH SCREEN (State 0) ---

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundWhite, // White background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ladipo Logo - no gradient, just the image
            LadipoLogo(height: 80),
          ],
        ),
      ),
    );
  }
}

class FadeTransitionWidget extends StatelessWidget {
  final Widget child;
  const FadeTransitionWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, opacity, _) => Opacity(opacity: opacity, child: child),
    );
  }
}

class GearAnimation extends StatefulWidget {
  final Widget child;
  const GearAnimation({super.key, required this.child});

  @override
  State<GearAnimation> createState() => _GearAnimationState();
}

class _GearAnimationState extends State<GearAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 0.05).animate(_controller),
        child: widget.child,
      ),
    );
  }
}

// --- 4. ONBOARDING SCREENS (State 1) ---

class OnboardingScreens extends StatefulWidget {
  final VoidCallback onStart;
  final VoidCallback onLogin;

  const OnboardingScreens({
    Key? key,
    required this.onStart,
    required this.onLogin,
  }) : super(key: key);

  @override
  State<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> slides = const [
    {
      'title': 'Welcome to Ladipo',
      'description':
          'Keep your car in top shape with the right expert advice, quality parts, and trusted support at your fingertips.',
    },
    {
      'title': 'Get Advice From Experts',
      'description':
          'Connect with certified mechanics and specialists to diagnose and resolve issues with your vehicle',
    },
    {
      'title': 'Trusted parts, just for your car',
      'description':
          'Enjoy peace of mind with affordable, authentic spare parts from trusted sellers.',
    },
    {
      'title': 'Take the stress out of maintaining your car',
      'description':
          'Keep your car running smoothly with easy maintenance tips and track document expires for peace of mind',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundWhite,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: slides.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 200.0), // Reserve space for bottom controls
                child: _OnboardingSlide(
                  title: slides[index]['title'] as String,
                  description: slides[index]['description'] as String,
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(bottom: 40.0, left: 24, right: 24, top: 24),
              decoration: BoxDecoration(
                color: kBackgroundWhite,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pagination dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        slides.length, (index) => _buildDot(index)),
                  ),
                  const SizedBox(height: 24), // Spacing between dots and button
                  // Next/Get Started button (solid)
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: _currentPage < slides.length - 1 ? 'Next' : 'Get Started',
                      onPressed: () {
                        if (_currentPage < slides.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOut,
                          );
                        } else {
                          widget.onStart(); // Call parent callback
                        }
                      },
                      color: kPrimaryBlue,
                      textColor: kBackgroundWhite,
                    ),
                  ),
                  const SizedBox(height: 12), // Spacing between buttons
                  // Login button (outlined)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: widget.onLogin,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: kPrimaryBlue, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                      child: Text(
                        'Login',
                        style: kButtonTextStyle.copyWith(
                          color: kPrimaryBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Logo at bottom left of first screen only
          if (_currentPage == 0)
            Positioned(
              bottom: 140,
              left: 24,
              child: LadipoLogo(height: 20),
            ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: _currentPage == index ? kPrimaryBlue : kLightGrayBorder,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final String title;
  final String description;

  const _OnboardingSlide({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 1),
          // Placeholder image - light gray square with rounded corners
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5), // Light gray
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const Spacer(flex: 2),
          // Title
          Text(
            title,
            style: kHeadingStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              description,
              style: kDescriptionStyle,
              textAlign: TextAlign.center,
            ),
          ),
          // Add significant spacing before the bottom section (where indicators and buttons are)
          // This ensures the text doesn't overlap with the bottom controls
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}

// --- 5. SHARED WIDGETS ---

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.color,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
      child: Text(
        text,
        style: kButtonTextStyle.copyWith(color: textColor),
      ),
    );
  }
}
