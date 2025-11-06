// lib/consults_screen.dart

import 'package:flutter/material.dart';
import 'shared_widgets.dart';
import 'data_models.dart';
import 'expert_profile_screen.dart'; // To navigate to the profile
import 'package:intl/intl.dart'; // For date formatting

class ConsultsScreen extends StatefulWidget {
  const ConsultsScreen({Key? key}) : super(key: key);

  @override
  State<ConsultsScreen> createState() => _ConsultsScreenState();
}

class _ConsultsScreenState extends State<ConsultsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Consultation> _allConsults = mockConsults;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Consultation> _filterConsults(ConsultationStatus? status) {
    if (status == null) return _allConsults;
    return _allConsults.where((c) => c.status == status).toList();
  }

  Map<String, List<Consultation>> _groupByDate(List<Consultation> consults) {
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final yesterday = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 1)));

    Map<String, List<Consultation>> grouped = {};

    for (var consult in consults) {
      final dateKey = DateFormat('yyyy-MM-dd').format(consult.timestamp);
      
      String groupTitle;
      if (dateKey == today) {
        groupTitle = 'Today';
      } else if (dateKey == yesterday) {
        groupTitle = 'Yesterday';
      } else {
        groupTitle = DateFormat('MMMM d, yyyy').format(consult.timestamp);
      }

      if (!grouped.containsKey(groupTitle)) {
        grouped[groupTitle] = [];
      }
      grouped[groupTitle]!.add(consult);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text('Consults', style: kHeading1.copyWith(color: kTextColor)),
              pinned: true,
              floating: true,
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(80.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: _buildSearchBar(),
                    ),
                    TabBar(
                      controller: _tabController,
                      indicatorColor: kPrimaryColor,
                      labelColor: kPrimaryColor,
                      unselectedLabelColor: kTextColor,
                      labelStyle: kBodyText.copyWith(fontWeight: FontWeight.w600),
                      unselectedLabelStyle: kBodyText.copyWith(fontWeight: FontWeight.w500),
                      tabs: const [
                        Tab(text: 'All'),
                        Tab(text: 'Completed'),
                        Tab(text: 'Missed'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildConsultList(null),
            _buildConsultList(ConsultationStatus.completed),
            _buildConsultList(ConsultationStatus.missed),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: kLightGray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search experts or car consults',
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 8),
        ),
      ),
    );
  }

  Widget _buildConsultList(ConsultationStatus? status) {
    final filteredConsults = _filterConsults(status);
    final groupedConsults = _groupByDate(filteredConsults);
    final sortedGroups = groupedConsults.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: sortedGroups.length,
      itemBuilder: (context, index) {
        final groupTitle = sortedGroups[index];
        final consults = groupedConsults[groupTitle]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 8.0),
              child: Text(
                groupTitle,
                style: kHeading2.copyWith(fontSize: 16),
              ),
            ),
            ...consults.map((consult) => _buildConsultCard(context, consult)).toList(),
          ],
        );
      },
    );
  }

  Widget _buildConsultCard(BuildContext context, Consultation consult) {
    String statusText;
    Color statusColor;
    IconData actionIcon;

    switch (consult.status) {
      case ConsultationStatus.ongoing:
        statusText = 'Ongoing';
        statusColor = kDeepBlue;
        actionIcon = Icons.call;
        break;
      case ConsultationStatus.completed:
        statusText = 'Completed';
        statusColor = Colors.green;
        actionIcon = Icons.call_made;
        break;
      case ConsultationStatus.missed:
        statusText = 'Missed';
        statusColor = Colors.redAccent;
        actionIcon = Icons.call_missed_outgoing;
        break;
    }

    final time = DateFormat('h:mm a').format(consult.timestamp);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExpertProfileScreen(expert: consult.expert),
          ),
        );
      },
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: kAccentBlue,
              child: ClipOval(
                child: SmartImage(
                  imageUrl: consult.expert.imageUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorWidget: const Icon(Icons.person, color: kDeepBlue, size: 24),
                ),
              ),
            ),
            title: Text(consult.expert.name, style: kBodyText.copyWith(fontWeight: FontWeight.w600)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(consult.car.fullName, style: kBodyText.copyWith(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 2),
                Text(statusText, style: kBodyText.copyWith(fontSize: 12, color: statusColor, fontWeight: FontWeight.bold)),
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(time, style: kBodyText.copyWith(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                Icon(actionIcon, size: 20, color: kPrimaryColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
