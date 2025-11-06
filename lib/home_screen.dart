import 'package:flutter/material.dart';
import 'shared_widgets.dart'; // Import shared widgets and constants
import 'user_model.dart'; // Import User model
import 'data_models.dart'; // Import Data Models
import 'expert_profile_screen.dart'; // To navigate to the profile
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  final dynamic user; // Now accepts User object
  final VoidCallback onLogout; // Callback to trigger logout
  final Function(int) onNavigate; // Callback to change the bottom navigation index

  // Mock data for this screen (MUST be final for StatelessWidget)
  final Car _userCar = mockCar;
  final List<Expert> _availableExperts;
  final List<Expert> _myExperts;

  HomeScreen({
    Key? key,
    required this.user,
    required this.onLogout,
    required this.onNavigate,
  })  : _availableExperts = mockExperts.sublist(0, 3),
        _myExperts = mockExperts.sublist(1, 4),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      // 2. Navigation Drawer
      // --- THIS IS THE FIX ---
      // We must pass the onLogout function to the AppDrawer
      drawer: AppDrawer(user: user, onLogout: onLogout),
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Greeting and Cart
          SliverAppBar(
            backgroundColor: kBackgroundColor,
            elevation: 0,
            floating: true,
            titleSpacing: 0,
            automaticallyImplyLeading: false, // Let the Builder handle the leading widget
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: kTextColor),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('Hi ${user.displayName.split(' ')[0]}', style: kHeading1),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: kTextColor),
                onPressed: () {
                  // Navigate to Cart Page
                },
              ),
              const SizedBox(width: 8),
            ],
          ),

          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      // User's Car Details Card
                      _buildCarCard(context),
                      const SizedBox(height: 25),

                      // Experts Available Section
                      _buildSectionHeader(context, 'Experts Available'),
                      const SizedBox(height: 10),
                      _buildExpertsAvailableList(),
                      const SizedBox(height: 25),

                      // My Experts Section
                      _buildSectionHeader(context, 'My Experts'),
                      const SizedBox(height: 10),
                      _buildMyExpertsList(),
                      const SizedBox(height: 25),

                      // Recent Activity
                      _buildSectionHeader(context, 'Recent Activity'),
                      const SizedBox(height: 10),
                      _buildRecentActivityList(context),
                      const SizedBox(height: 80), // Padding for the bottom navbar
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kHeading2),
        GestureDetector(
          onTap: () {
            // Logic to view all (e.g., navigate to Consults or My Experts page)
            if (title == 'Recent Activity' || title == 'Experts Available') {
              onNavigate(1); // Navigate to Consults tab
            } else if (title == 'My Experts') {
              // Navigate to a dedicated My Experts list page
            }
          },
          child: Text(
            'View all',
            style: kBodyText.copyWith(color: kPrimaryColor, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildCarCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kLightGray,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          SmartImage(
            imageUrl: _userCar.imageUrl,
            width: 100,
            height: 60,
            fit: BoxFit.cover,
            errorWidget: const Icon(Icons.directions_car, size: 60, color: kDeepBlue),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userCar.fullName,
                  style: kHeading2.copyWith(fontSize: 16),
                ),
                Text(
                  _userCar.registration,
                  style: kBodyText.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () => onNavigate(2), // Navigate to My Cars tab
                  child: Text(
                    'View My Cars',
                    style: kBodyText.copyWith(color: kPrimaryColor, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpertsAvailableList() {
    return SizedBox(
      height: 220, // Increased height to fix overflow issue
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _availableExperts.length,
        itemBuilder: (context, index) {
          final expert = _availableExperts[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ExpertProfileScreen(expert: expert),
                ),
              );
            },
            child: ExpertCard(
              name: expert.name,
              specialization: expert.specialization,
              imageUrl: expert.imageUrl,
              rating: expert.rating,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMyExpertsList() {
    return Column(
      children: _myExperts.map((expert) {
        return _buildMiniExpertCard(expert);
      }).toList(),
    );
  }

  Widget _buildMiniExpertCard(Expert expert) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: () {
          // Handle expert tap action
        },
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: kAccentBlue,
          child: ClipOval(
            child: SmartImage(
              imageUrl: expert.imageUrl,
              fit: BoxFit.cover,
              width: 40,
              height: 40,
              errorWidget: const Icon(Icons.person, color: kDeepBlue, size: 28),
            ),
          ),
        ),
        title: Text(expert.name, style: kBodyText.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(expert.specialization, style: kBodyText.copyWith(fontSize: 12, color: Colors.grey[600])),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: Icon(Icons.call, color: kPrimaryColor, size: 20), onPressed: () {}),
            IconButton(icon: Icon(Icons.chat_bubble_outline, color: kDeepBlue, size: 20), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityList(BuildContext context) {
    // Show only the 3 most recent consultations
    return Column(
      children: mockConsults.sublist(0, 3).map((consult) {
        return _buildActivityTile(context, consult);
      }).toList(),
    );
  }

  Widget _buildActivityTile(BuildContext context, Consultation consult) {
    final timeFormat = DateFormat('h:mm a');
    final timeString = consult.status == ConsultationStatus.ongoing
        ? 'Ongoing'
        : timeFormat.format(consult.timestamp);

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(
          consult.status == ConsultationStatus.ongoing ? Icons.call_outlined : Icons.chat_bubble_outline,
          color: kDeepBlue,
        ),
        title: Text(
          'Consultation with ${consult.expert.name}',
          style: kBodyText.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${consult.car.model} • ${consult.status.name.toUpperCase()}',
          style: kBodyText.copyWith(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: Text(
          timeString,
          style: kBodyText.copyWith(fontSize: 12, color: kPrimaryColor, fontWeight: FontWeight.w600),
        ),
        onTap: () => onNavigate(1), // Navigate to Consults tab
      ),
    );
  }
}
