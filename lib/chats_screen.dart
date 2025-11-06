// lib/chats_screen.dart

import 'package:flutter/material.dart';
import 'shared_widgets.dart';
import 'data_models.dart';
import 'package:intl/intl.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  // Mock chat conversations
  final List<Map<String, dynamic>> _chats = [
    {
      'expert': mockExperts[0], // Tunde Abraham
      'lastMessage': 'Thanks for the consultation. Your car is in good shape.',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'unreadCount': 2,
      'car': mockCar,
    },
    {
      'expert': mockExperts[3], // John Adetunji
      'lastMessage': 'I can help you with the brake issue.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'unreadCount': 0,
      'car': mockCar,
    },
    {
      'expert': mockExperts[1], // Bola Salako
      'lastMessage': 'The electronic issue has been resolved.',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'unreadCount': 0,
      'car': mockCar,
    },
    {
      'expert': mockExperts[2], // Anita Wilson
      'lastMessage': 'Your tyre replacement is scheduled for tomorrow.',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'unreadCount': 1,
      'car': mockCar,
    },
  ];

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Chats', style: kHeading1.copyWith(fontSize: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: kTextColor),
            onPressed: () {
              // Show search functionality
            },
          ),
        ],
      ),
      body: _chats.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No chats yet',
                    style: kBodyText.copyWith(color: kSubtextGray),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start a conversation with an expert',
                    style: kBodyText.copyWith(color: kSubtextGray, fontSize: 12),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: kLightGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search chats',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 12),
                      ),
                    ),
                  ),
                ),
                // Chats List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _chats.length,
                    itemBuilder: (context, index) {
                      final chat = _chats[index];
                      final expert = chat['expert'] as Expert;
                      final car = chat['car'] as Car;
                      final unreadCount = chat['unreadCount'] as int;

                      return Card(
                        elevation: 0.5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: kAccentBlue,
                                child: ClipOval(
                                  child: SmartImage(
                                    imageUrl: expert.imageUrl,
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                    errorWidget: const Icon(
                                      Icons.person,
                                      color: kDeepBlue,
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ),
                              if (unreadCount > 0)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: kPrimaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: Text(
                                      unreadCount > 9 ? '9+' : '$unreadCount',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  expert.name,
                                  style: kBodyText.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: unreadCount > 0 ? kTextColor : kTextColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                _formatTimestamp(chat['timestamp'] as DateTime),
                                style: kBodyText.copyWith(
                                  fontSize: 11,
                                  color: kSubtextGray,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                chat['lastMessage'] as String,
                                style: kBodyText.copyWith(
                                  fontSize: 13,
                                  color: kSubtextGray,
                                  fontWeight: unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                car.fullName,
                                style: kBodyText.copyWith(
                                  fontSize: 11,
                                  color: kSubtextGray,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            // Navigate to chat detail screen
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Opening chat with ${expert.name}')),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

