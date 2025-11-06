import 'package:flutter/material.dart';

// --- 1. Design Constants (Based on Ladipo App Branding) ---
// Color Palette
const Color kPrimaryColor = Color(0xFF0099CD); // Primary Color
const Color kDeepBlue = Color(0xFF0099CD); // Primary Color (same as primary)
const Color kBackgroundColor = Color(0xFFFFFFFF); // White background
const Color kBackgroundSecondary = Color(0xFFE3F6FB); // Secondary/Backup Background Color
const Color kLightGray = Color(0xFFF5F6FA); // Soft gray for background elements
const Color kTextColor = Color(0xFF111827); // Dark Text
const Color kSubtextGray = Color(0xFF6B7280); // Subtext Gray
const Color kAccentYellow = Color(0xFFFACC15);
const Color kSuccessGreen = Color(0xFF22C55E);

// Typography (Assuming Inter font is available)
const TextStyle kLargeTitle = TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 28, color: kTextColor);
const TextStyle kHeading1 = TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 24, color: kTextColor);
const TextStyle kHeading2 = TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 18, color: kTextColor);
const TextStyle kBodyText = TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 14, color: kTextColor);
const TextStyle kButtonText = TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white);

// Additional colors
const Color kAccentBlue = Color(0xFFE3F6FB); // Secondary/Backup color for backgrounds

// --- 2. Shared Widgets ---

// Helper widget to load images from assets or network
class SmartImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const SmartImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if it's an asset path
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ??
            const Icon(Icons.image_not_supported, color: kSubtextGray),
      );
    } else {
      // Network image
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ??
              Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                ),
              );
        },
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ??
            const Icon(Icons.image_not_supported, color: kSubtextGray),
      );
    }
  }
}

// Ladipo Logo Widget (reusable across the app)
class LadipoLogo extends StatelessWidget {
  final double? height;
  final double? width;

  const LadipoLogo({
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Display image logo as-is, no gradient, no background color, no text fallback
    // Maintains aspect ratio and displays exactly as the image file
    return Image.asset(
      'assets/images/1001057869.jpg', // Ladipo logo
      height: height,
      width: width,
      fit: BoxFit.contain, // Preserves aspect ratio, fits within bounds
      filterQuality: FilterQuality.high, // High quality rendering
      errorBuilder: (context, error, stackTrace) {
        // Return empty container if image not found - no text fallback
        return SizedBox(
          height: height,
          width: width,
        );
      },
    );
  }
}

// Expert Card Widget (for displaying experts in horizontal list)
class ExpertCard extends StatelessWidget {
  final String name;
  final String specialization;
  final String imageUrl;
  final double rating;

  const ExpertCard({
    Key? key,
    required this.name,
    required this.specialization,
    required this.imageUrl,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expert Image
            Center(
              child: CircleAvatar(
                radius: 35,
                backgroundColor: kAccentBlue,
                child: ClipOval(
                  child: SmartImage(
                    imageUrl: imageUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorWidget: const Icon(Icons.person, color: kDeepBlue, size: 35),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Expert Name
            Text(
              name,
              style: kBodyText.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Specialization
            Text(
              specialization,
              style: kBodyText.copyWith(fontSize: 12, color: kSubtextGray),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            // Rating
            Row(
              children: [
                const Icon(Icons.star, color: kAccentYellow, size: 14),
                const SizedBox(width: 4),
                Text(
                  '${rating.toStringAsFixed(1)}',
                  style: kBodyText.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(Icons.call, kPrimaryColor, () {}),
                _buildActionButton(Icons.chat_bubble_outline, kDeepBlue, () {}),
                _buildActionButton(Icons.videocam_outlined, kSuccessGreen, () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

// Primary Button Widget
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? kPrimaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
        ),
        child: Text(
          text,
          style: kButtonText.copyWith(color: textColor ?? Colors.white),
        ),
      ),
    );
  }
}

// App Drawer Widget
class AppDrawer extends StatelessWidget {
  final dynamic user;
  final VoidCallback onLogout;

  const AppDrawer({
    Key? key,
    required this.user,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header with logo
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: LadipoLogo(height: 28),
            ),
            const Divider(),
            // Menu items
            ListTile(
              leading: const Icon(Icons.store_outlined, color: kTextColor),
              title: Text('Vendor', style: kBodyText),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.build_outlined, color: kTextColor),
              title: Text('Workshop', style: kBodyText),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined, color: kTextColor),
              title: Text('Order', style: kBodyText),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined, color: kTextColor),
              title: Text('Settings', style: kBodyText),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_outlined, color: Colors.red),
              title: Text('Logout', style: kBodyText.copyWith(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                onLogout();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// App Bottom Navigation Bar Widget
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: onTap,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey[500],
        selectedLabelStyle: kBodyText.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: kBodyText.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Experts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Consults',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}