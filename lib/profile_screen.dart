// lib/profile_screen.dart

import 'package:flutter/material.dart';
import 'shared_widgets.dart'; // Import shared widgets and constants
import 'user_model.dart'; // Import User model
import 'my_cars_screen.dart';
import 'my_experts_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  final User user; // Pass the current user for profile details
  final VoidCallback onLogout;
  
  const ProfileScreen({Key? key, required this.user, required this.onLogout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Remove back button when accessed from bottom nav
        title: Text('My Profile', style: kHeading1.copyWith(fontSize: 20)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(user: user),
                  ),
                );
              },
              icon: const Icon(Icons.edit_outlined, color: kPrimaryColor),
              label: Text('Edit profile', style: kBodyText.copyWith(color: kPrimaryColor)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                side: const BorderSide(color: kPrimaryColor),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 30),
            _buildProfileSection(
              context,
              title: 'My Cars',
              icon: Icons.directions_car_outlined,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyCarsScreen()),
                );
              },
            ),
            _buildProfileSection(
              context,
              title: 'Dashboard',
              icon: Icons.dashboard_outlined,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dashboard coming soon!')));
              },
            ),
            _buildProfileSection(
              context,
              title: 'My Experts',
              icon: Icons.people_outline,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyExpertsScreen()),
                );
              },
            ),
            _buildProfileSection(
              context,
              title: 'App settings',
              icon: Icons.settings_outlined,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('App Settings coming soon!')));
              },
            ),
            const SizedBox(height: 30),

            Center(
              child: TextButton(
                onPressed: () {
                  onLogout();
                },
                child: const Text('Log Out', style: TextStyle(color: Colors.red, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: kPrimaryColor,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName,
                  style: kLargeTitle.copyWith(fontSize: 22),
                ),
                Text(
                  user.email,
                  style: kBodyText.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: kPrimaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
