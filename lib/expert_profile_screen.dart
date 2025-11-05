// lib/expert_profile_screen.dart

import 'package:flutter/material.dart';
import 'shared_widgets.dart';
import 'data_models.dart';
import 'package:intl/intl.dart'; // For formatting date/time

class ExpertProfileScreen extends StatelessWidget {
  final Expert expert;

  const ExpertProfileScreen({Key? key, required this.expert}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: kTextColor,
        title: Text(expert.name, style: kHeading2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(expert),
            _buildActionButtons(),
            _buildSessionHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Expert expert) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20),
      margin: const EdgeInsets.only(bottom: 15),
      child: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: kAccentBlue,
              backgroundImage: NetworkImage(expert.imageUrl),
              onBackgroundImageError: (exception, stackTrace) => const Icon(Icons.person, color: kDeepBlue, size: 50),
              child: expert.imageUrl.isEmpty 
                  ? Icon(Icons.person, color: kDeepBlue.withOpacity(0.7), size: 50) 
                  : null,
            ),
            const SizedBox(height: 10),
            Text(expert.name, style: kHeading1.copyWith(fontSize: 28)),
            const SizedBox(height: 4),
            Text(expert.specialization, style: kBodyText.copyWith(color: kPrimaryColor)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.grey, size: 16),
                const SizedBox(width: 4),
                Text(expert.location, style: kBodyText.copyWith(color: Colors.grey[700])),
                const SizedBox(width: 15),
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text('${expert.rating} (120 Reviews)', style: kBodyText.copyWith(color: Colors.grey[700])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPillButton('Call', Icons.call, kPrimaryColor),
          _buildPillButton('Chat', Icons.chat_bubble_outline, kDeepBlue),
          _buildPillButton('Video', Icons.videocam_outlined, Colors.green),
          _buildPillButton('Review', Icons.star_border, Colors.black54),
        ],
      ),
    );
  }

  Widget _buildPillButton(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 5),
          Text(text, style: kBodyText.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSessionHistory() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Session History', style: kHeading2),
          const SizedBox(height: 15),
          _buildHistoryItem(Icons.call_made, 'Outgoing Call', '3 min 24 secs', DateTime.now().subtract(const Duration(days: 2, hours: 5))),
          _buildHistoryItem(Icons.call_received, 'Incoming Call', '4 min 10 secs', DateTime.now().subtract(const Duration(days: 2, hours: 7))),
          _buildHistoryItem(Icons.call_missed_outgoing, 'Missed Call', '6:00 PM', DateTime.now().subtract(const Duration(days: 3, hours: 2))),
          _buildHistoryItem(Icons.chat_bubble_outline, 'Chat Consultation', '15 messages exchanged', DateTime.now().subtract(const Duration(days: 4))),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(IconData icon, String title, String durationOrTime, DateTime date) {
    final dateFormat = DateFormat('MMM d, h:mm a');
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: kPrimaryColor, size: 24),
        title: Text(title, style: kBodyText.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(durationOrTime, style: kBodyText.copyWith(color: Colors.grey[600])),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(dateFormat.format(date), style: kBodyText.copyWith(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
