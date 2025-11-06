// lib/edit_profile_screen.dart

import 'package:flutter/material.dart';
import 'shared_widgets.dart';
import 'user_model.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.displayName);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: '0802237712'); // Mock data
    _addressController = TextEditingController(
      text: '5, Alfred Jones street, Iwo Road, Ibadan, Oyo',
    ); // Mock data
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Edit Profile', style: kHeading1.copyWith(fontSize: 20)),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile saved successfully!')),
              );
              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: kBodyText.copyWith(color: kPrimaryColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Profile Picture with Edit Icon
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: kAccentBlue,
                  child: const Icon(Icons.person, size: 60, color: kDeepBlue),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            _buildTextField('Full Name', _nameController),
            const SizedBox(height: 20),
            _buildTextField('Email Address', _emailController),
            const SizedBox(height: 20),
            _buildTextField('Phone number', _phoneController, keyboardType: TextInputType.phone),
            const SizedBox(height: 20),
            _buildTextField('Address', _addressController, maxLines: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: kBodyText.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
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
      ],
    );
  }
}

