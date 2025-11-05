import 'package:flutter/material.dart';
// Removed: import 'main.dart'; // This caused a circular dependency

// --- 1. DESIGN CONSTANTS ---
const Color kPrimaryBlue = Color(0xFF3A7BD5); // Primary Blue
const Color kDarkBlueAccent = Color(0xFF1E3A8A); // Dark Blue Accent
const Color kTextDarkGray = Color(0xFF111827); // Text Gray
const Color kTextMediumGray = Color(0xFF6B7280); // Subtext Gray
const Color kBackgroundWhite = Color(0xFFFFFFFF); // Neutral Background
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
    return const Scaffold(
      backgroundColor: kBackgroundWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GearAnimation(
              child: Icon(
                Icons.precision_manufacturing_rounded,
                size: 80,
                color: kDarkBlueAccent,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Ladipo',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: kTextDarkGray,
              ),
            ),
            SizedBox(height: 50),
            FadeTransitionWidget(
              child: Text(
                'Powered by Ladipo Tech',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: kTextMediumGray,
                ),
              ),
            ),
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
          'Keep your car in shape with expert advice, quality parts, and trusted support — all in one place.',
      'icon': Icons.directions_car_filled_rounded,
    },
    {
      'title': 'Get Advice From Experts',
      'description':
          'Talk directly to certified mechanics and specialists who understand your car’s needs.',
      'icon': Icons.support_agent_rounded,
    },
    {
      'title': 'Trusted Parts, Just for Your Car',
      'description':
          'Shop affordable, authentic spare parts from verified sellers — no guesswork.',
      'icon': Icons.hardware_rounded,
    },
    {
      'title': 'Take the Stress Out of Car Maintenance',
      'description':
          'Track maintenance, get reminders, and keep your car running smoothly without worry.',
      'icon': Icons.checklist_rounded,
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
              return _OnboardingSlide(
                title: slides[index]['title'] as String,
                description: slides[index]['description'] as String,
                iconData: slides[index]['icon'] as IconData,
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 40.0, left: 24, right: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        slides.length, (index) => _buildDot(index)),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: _currentPage == slides.length - 1
                          ? 'LET\'S START'
                          : 'NEXT',
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
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: widget.onLogin, // Call parent callback
                    child: Text(
                      'Login',
                      style: kButtonTextStyle.copyWith(
                        color: kDarkBlueAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
      width: _currentPage == index ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: _currentPage == index ? kPrimaryBlue : kLightGrayBorder,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final String title;
  final String description;
  final IconData iconData;

  const _OnboardingSlide({
    Key? key,
    required this.title,
    required this.description,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 3),
          Icon(
            iconData,
            size: 150,
            color: kPrimaryBlue.withOpacity(0.8),
          ),
          const Spacer(flex: 1),
          Text(
            title,
            style: kHeadingStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            description,
            style: kDescriptionStyle,
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 3),
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
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        shadowColor: color.withOpacity(0.4),
      ),
      child: Text(
        text,
        style: kButtonTextStyle.copyWith(color: textColor),
      ),
    );
  }
}
