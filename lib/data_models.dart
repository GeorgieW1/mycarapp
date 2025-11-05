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

// Images are placeholders or simple icons.
final mockCar = Car(
  make: 'Toyota',
  model: 'Corolla',
  year: 2008,
  registration: 'LAG-345-AE',
  imageUrl: '[https://placehold.co/100x60/1E3A8A/FFFFFF?text=Car+Icon](https://placehold.co/100x60/1E3A8A/FFFFFF?text=Car+Icon)',
);

final mockExperts = [
  Expert(
    name: 'Tunde Abraham',
    specialization: 'Mechanic',
    rating: 4.8,
    location: 'Ikeja, Lagos',
    imageUrl: '[https://placehold.co/60x60/3A7BD5/FFFFFF?text=TA](https://placehold.co/60x60/3A7BD5/FFFFFF?text=TA)',
  ),
  Expert(
    name: 'Bola Salako',
    specialization: 'Electronics',
    rating: 4.5,
    location: 'Surulere, Lagos',
    imageUrl: '[https://placehold.co/60x60/1E3A8A/FFFFFF?text=BS](https://placehold.co/60x60/1E3A8A/FFFFFF?text=BS)',
  ),
  Expert(
    name: 'Anita Wilson',
    specialization: 'Tyre Specialist',
    rating: 4.9,
    location: 'Yaba, Lagos',
    imageUrl: '[https://placehold.co/60x60/3A7BD5/FFFFFF?text=AW](https://placehold.co/60x60/3A7BD5/FFFFFF?text=AW)',
  ),
  Expert(
    name: 'John Adetunji',
    specialization: 'Brakes',
    rating: 4.7,
    location: 'Oshodi, Lagos',
    imageUrl: '[https://placehold.co/60x60/1E3A8A/FFFFFF?text=JA](https://placehold.co/60x60/1E3A8A/FFFFFF?text=JA)',
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
