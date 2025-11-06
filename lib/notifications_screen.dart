// lib/notifications_screen.dart

import 'package:flutter/material.dart';
import 'shared_widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Mock notifications data
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'New Expert Available',
      'message': 'Tunde Abraham is now available for consultation',
      'time': '2 min ago',
      'isRead': false,
      'type': 'expert',
    },
    {
      'title': 'Car Service Reminder',
      'message': 'Your Toyota Corolla 2008 is due for service',
      'time': '1 hour ago',
      'isRead': false,
      'type': 'service',
    },
    {
      'title': 'Document Expiring Soon',
      'message': 'Your vehicle registration expires in 30 days',
      'time': '3 hours ago',
      'isRead': true,
      'type': 'document',
    },
    {
      'title': 'Consultation Completed',
      'message': 'Your consultation with John Adetunji has been completed',
      'time': 'Yesterday',
      'isRead': true,
      'type': 'consultation',
    },
    {
      'title': 'New Parts Available',
      'message': 'New parts for your car model are now available',
      'time': '2 days ago',
      'isRead': true,
      'type': 'parts',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Notifications', style: kHeading1.copyWith(fontSize: 20)),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var notification in _notifications) {
                  notification['isRead'] = true;
                }
              });
            },
            child: Text(
              'Mark all as read',
              style: kBodyText.copyWith(color: kPrimaryColor),
            ),
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications',
                    style: kBodyText.copyWith(color: kSubtextGray),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return Card(
                  elevation: 0.5,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: notification['isRead'] ? Colors.white : kPrimaryColor.withOpacity(0.05),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _getNotificationColor(notification['type']).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getNotificationIcon(notification['type']),
                        color: _getNotificationColor(notification['type']),
                        size: 24,
                      ),
                    ),
                    title: Text(
                      notification['title'],
                      style: kBodyText.copyWith(
                        fontWeight: FontWeight.w600,
                        color: notification['isRead'] ? kTextColor : kPrimaryColor,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          notification['message'],
                          style: kBodyText.copyWith(
                            fontSize: 13,
                            color: kSubtextGray,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification['time'],
                          style: kBodyText.copyWith(
                            fontSize: 11,
                            color: kSubtextGray,
                          ),
                        ),
                      ],
                    ),
                    trailing: notification['isRead']
                        ? null
                        : Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: kPrimaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                    onTap: () {
                      setState(() {
                        notification['isRead'] = true;
                      });
                    },
                  ),
                );
              },
            ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'expert':
        return Icons.person_add;
      case 'service':
        return Icons.build;
      case 'document':
        return Icons.description;
      case 'consultation':
        return Icons.chat;
      case 'parts':
        return Icons.shopping_bag;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'expert':
        return kPrimaryColor;
      case 'service':
        return kAccentYellow;
      case 'document':
        return Colors.orange;
      case 'consultation':
        return kSuccessGreen;
      case 'parts':
        return Colors.purple;
      default:
        return kPrimaryColor;
    }
  }
}

