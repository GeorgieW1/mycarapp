// lib/cars_screen.dart

import 'package:flutter/material.dart';
import 'shared_widgets.dart';
import 'data_models.dart';
import 'add_car_screen.dart';
import 'my_cars_screen.dart';

class CarsScreen extends StatefulWidget {
  const CarsScreen({Key? key}) : super(key: key);

  @override
  State<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  // Mock list of user's cars
  List<Car> _myCars = [
    mockCar,
    Car(
      make: 'Honda',
      model: 'Accord',
      year: 2016,
      registration: 'XASA4AB',
      imageUrl: 'assets/images/cars/1001057668.jpg',
    ),
    Car(
      make: 'Lexus',
      model: 'RX 350',
      year: 2018,
      registration: 'ABC123',
      imageUrl: 'assets/images/cars/1001057654.jpg',
    ),
    Car(
      make: 'Toyota',
      model: 'RAV 4',
      year: 2012,
      registration: 'DEF456',
      imageUrl: 'assets/images/cars/1001057668.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('My Cars', style: kHeading1.copyWith(fontSize: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: kPrimaryColor),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddCarScreen()),
              );
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
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 12),
                ),
              ),
            ),
          ),
          // Car List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _myCars.length,
              itemBuilder: (context, index) {
                final car = _myCars[index];
                return Card(
                  elevation: 0.5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.directions_car,
                        color: kPrimaryColor,
                        size: 30,
                      ),
                    ),
                    title: Text(
                      car.fullName,
                      style: kBodyText.copyWith(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          car.registration,
                          style: kBodyText.copyWith(fontSize: 12, color: kSubtextGray),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Registered: 04, April 2023',
                          style: kBodyText.copyWith(fontSize: 12, color: kSubtextGray),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert, color: kSubtextGray),
                      onPressed: () {
                        // Show options menu
                      },
                    ),
                    onTap: () {
                      // Navigate to car details
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

