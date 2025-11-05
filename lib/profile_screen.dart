// lib/profile_screen.dart

import 'package:flutter/material.dart';
import 'shared_widgets.dart'; // Import shared widgets and constants
import 'user_model.dart'; // Import User model

class ProfileScreen extends StatelessWidget {
  final User user; // Pass the current user for profile details
  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings', style: kLargeTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 20),

            _buildProfileSection(
              context,
              title: 'My Profile',
              icon: Icons.person_outline,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('My Profile tapped')));
                // Navigate to a detailed profile editing screen
              },
            ),
            _buildProfileSection(
              context,
              title: 'My Cars',
              icon: Icons.directions_car_outlined,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('My Cars tapped')));
                // Navigate to a list of user's cars
              },
            ),
            _buildProfileSection(
              context,
              title: 'My Experts',
              icon: Icons.people_outline,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('My Experts tapped')));
                // Navigate to a list of preferred experts
              },
            ),
            _buildProfileSection(
              context,
              title: 'App Settings',
              icon: Icons.settings_outlined,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('App Settings tapped')));
                // Navigate to app settings
              },
            ),
            const SizedBox(height: 30),

            Center(
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Log out tapped')));
                  // In a real app, this would trigger the actual logout mechanism
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
              // backgroundImage: NetworkImage('URL_TO_PROFILE_IMAGE'), // Use actual image
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName, // Display user's name from the User model
                  style: kLargeTitle.copyWith(fontSize: 22),
                ),
                Text(
                  user.email, // Display user's email
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
