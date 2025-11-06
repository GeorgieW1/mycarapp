// lib/experts_screen.dart

import 'package:flutter/material.dart';
import 'shared_widgets.dart';
import 'data_models.dart';
import 'expert_profile_screen.dart';

class ExpertsScreen extends StatefulWidget {
  const ExpertsScreen({Key? key}) : super(key: key);

  @override
  State<ExpertsScreen> createState() => _ExpertsScreenState();
}

class _ExpertsScreenState extends State<ExpertsScreen> {
  // Show all available experts
  final List<Expert> _allExperts = mockExperts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Experts', style: kHeading1.copyWith(fontSize: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: kTextColor),
            onPressed: () {
              // Show search functionality
            },
          ),
        ],
      ),
      body: Column(
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
                  hintText: 'Search experts',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 12),
                ),
              ),
            ),
          ),
          // Experts List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _allExperts.length,
              itemBuilder: (context, index) {
                final expert = _allExperts[index];
                return Card(
                  elevation: 0.5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
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
                    title: Text(
                      expert.name,
                      style: kBodyText.copyWith(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${expert.rating}/5',
                              style: kBodyText.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: kSuccessGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Available',
                            style: kBodyText.copyWith(
                              fontSize: 11,
                              color: kSuccessGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.call, color: kPrimaryColor, size: 20),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.chat_bubble_outline, color: kDeepBlue, size: 20),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ExpertProfileScreen(expert: expert),
                        ),
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

