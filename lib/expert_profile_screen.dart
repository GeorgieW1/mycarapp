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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kLightGray,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: kTextColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: kTextColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(expert.name, style: kHeading2),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined, color: kTextColor),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            labelColor: kPrimaryColor,
            unselectedLabelColor: kSubtextGray,
            indicatorColor: kPrimaryColor,
            tabs: const [
              Tab(text: 'Session History'),
              Tab(text: 'Reviews'),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileHeader(expert),
              _buildActionButtons(),
              const SizedBox(height: 10),
              SizedBox(
                height: 400,
                child: TabBarView(
                  children: [
                    _buildSessionHistory(),
                    _buildReviews(),
                  ],
                ),
              ),
            ],
          ),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text('Today', style: kHeading2.copyWith(fontSize: 16)),
          ),
          _buildHistoryItem(Icons.call_made, 'Outgoing call', 'Toyota Corolla 2008', '24 mins', DateTime.now().subtract(const Duration(hours: 1))),
          _buildHistoryItem(Icons.call_received, 'Incoming call', 'Toyota Corolla 2008', '12 mins', DateTime.now().subtract(const Duration(hours: 3))),
          _buildHistoryItem(Icons.call_missed_outgoing, 'Missed call', 'Toyota Corolla 2008', '6:00 PM', DateTime.now().subtract(const Duration(days: 1))),
        ],
      ),
    );
  }

  Widget _buildReviews() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text('Customer Reviews', style: kHeading2.copyWith(fontSize: 16)),
          ),
          _buildReviewItem('John Doe', 'Great service! Very professional.', 5, DateTime.now().subtract(const Duration(days: 2))),
          _buildReviewItem('Jane Smith', 'Quick response and helpful advice.', 5, DateTime.now().subtract(const Duration(days: 5))),
          _buildReviewItem('Mike Johnson', 'Could be better communication.', 4, DateTime.now().subtract(const Duration(days: 7))),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String name, String review, int rating, DateTime date) {
    final dateFormat = DateFormat('MMM d, yyyy');
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: kAccentBlue,
                  child: Text(
                    name[0].toUpperCase(),
                    style: kBodyText.copyWith(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: kBodyText.copyWith(fontWeight: FontWeight.w600)),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            Icons.star,
                            size: 14,
                            color: index < rating ? Colors.amber : Colors.grey[300],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Text(
                  dateFormat.format(date),
                  style: kBodyText.copyWith(fontSize: 12, color: kSubtextGray),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(review, style: kBodyText.copyWith(color: kSubtextGray)),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(IconData icon, String title, String car, String durationOrTime, DateTime date) {
    final timeFormat = DateFormat('h:mm a');
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: kPrimaryColor, size: 24),
        title: Text(title, style: kBodyText.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(car, style: kBodyText.copyWith(color: Colors.grey[600])),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(durationOrTime, style: kBodyText.copyWith(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(timeFormat.format(date), style: kBodyText.copyWith(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
