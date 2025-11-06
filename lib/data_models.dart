// lib/data_models.dart

class Car {
  final String make;
  final String model;
  final int year;
  final String registration;
  final String imageUrl;

  Car({
    required this.make,
    required this.model,
    required this.year,
    required this.registration,
    required this.imageUrl,
  });

  String get fullName => '$make $model $year';
}

class Expert {
  final String name;
  final String specialization;
  final double rating;
  final String location;
  final String imageUrl;

  Expert({
    required this.name,
    required this.specialization,
    required this.rating,
    required this.location,
    required this.imageUrl,
  });
}

enum ConsultationStatus { ongoing, completed, missed }

class Consultation {
  final Expert expert;
  final Car car;
  final ConsultationStatus status;
  final DateTime timestamp;

  Consultation({
    required this.expert,
    required this.car,
    required this.status,
    required this.timestamp,
  });
}

// --- Mock Data for UI Demonstration ---

// Helper function to get car image (checks assets first, then falls back to network/placeholder)
String getCarImageUrl(String make, String model) {
  // Try asset first (e.g., assets/images/cars/toyota_corolla.png)
  // For now, using placeholder - replace with actual asset path when images are added
  return 'https://placehold.co/300x200/0099CD/FFFFFF?text=${make}+${model}';
}

// Helper function to get expert image (checks assets first, then falls back to network/placeholder)
String getExpertImageUrl(String name) {
  // Try asset first (e.g., assets/images/experts/tunde_abraham.png)
  // For now, using placeholder - replace with actual asset path when images are added
  final initials = name.split(' ').map((n) => n[0]).take(2).join();
  return 'https://placehold.co/100x100/0099CD/FFFFFF?text=$initials';
}

// Images are placeholders or simple icons.
final mockCar = Car(
  make: 'Toyota',
  model: 'Corolla',
  year: 2008,
  registration: 'LAG-345-AE',
  imageUrl: 'assets/images/cars/1001057654.jpg', // Silver car image
);

final mockExperts = [
  Expert(
    name: 'Tunde Abraham',
    specialization: 'Mechanic',
    rating: 4.8,
    location: 'Ikeja, Lagos',
    imageUrl: 'assets/images/experts/1001057657.jpg', // Expert in orange apron
  ),
  Expert(
    name: 'Bola Salako',
    specialization: 'Electronics',
    rating: 4.5,
    location: 'Surulere, Lagos',
    imageUrl: 'assets/images/experts/1001057677.jpg', // Expert in green turtleneck
  ),
  Expert(
    name: 'Anita Wilson',
    specialization: 'Tyre Specialist',
    rating: 4.9,
    location: 'Yaba, Lagos',
    imageUrl: 'assets/images/experts/1001057657.jpg', // Using available expert image
  ),
  Expert(
    name: 'John Adetunji',
    specialization: 'Brakes',
    rating: 4.7,
    location: 'Oshodi, Lagos',
    imageUrl: 'assets/images/experts/1001057677.jpg', // Using available expert image
  ),
];

final mockConsults = [
  Consultation(
    expert: mockExperts[0],
    car: mockCar,
    status: ConsultationStatus.ongoing,
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
  ),
  Consultation(
    expert: mockExperts[3],
    car: mockCar,
    status: ConsultationStatus.completed,
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  Consultation(
    expert: mockExperts[1],
    car: mockCar,
    status: ConsultationStatus.missed,
    timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 10)),
  ),
  Consultation(
    expert: mockExperts[2],
    car: mockCar,
    status: ConsultationStatus.completed,
    timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
  ),
];
