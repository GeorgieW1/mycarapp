// lib/user_model.dart

class User {
  final String uid;
  final String email;
  final String displayName; // <-- Added based on previous context

  User({required this.uid, required this.email, this.displayName = 'User'});
}
