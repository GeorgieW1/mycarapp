// lib/my_experts_screen.dart

import 'package:flutter/material.dart';
import 'shared_widgets.dart';
import 'data_models.dart';
import 'expert_profile_screen.dart';

class MyExpertsScreen extends StatelessWidget {
  const MyExpertsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock list of saved experts
    final List<Expert> myExperts = [
      mockExperts[0], // Tunde Abraham
      mockExperts[3], // John Adetunji
      Expert(
        name: 'Bobby Mark',
        specialization: 'Engine Specialist',
        rating: 4.8,
        location: 'Lekki, Lagos',
        imageUrl: 'https://placehold.co/60x60/3A7BD5/FFFFFF?text=BM',
      ),
      Expert(
        name: 'Luke Bayo',
        specialization: 'Transmission Expert',
        rating: 4.6,
        location: 'Victoria Island, Lagos',
        imageUrl: 'https://placehold.co/60x60/1E3A8A/FFFFFF?text=LB',
      ),
    ];

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('My Experts', style: kHeading1.copyWith(fontSize: 20)),
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
                  hintText: 'Search',
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
              itemCount: myExperts.length,
              itemBuilder: (context, index) {
                final expert = myExperts[index];
                return Card(
                  elevation: 0.5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: kAccentBlue,
                      backgroundImage: NetworkImage(expert.imageUrl),
                      onBackgroundImageError: (exception, stackTrace) => const Icon(
                        Icons.person,
                        color: kDeepBlue,
                        size: 28,
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

