import '../models/user_model.dart';

class AuthRepository {
  // Mock users database
  final List<Map<String, String>> _mockUsers = [
    {
      'id': '1',
      'email': 'user@example.com',
      'password': 'password123',
      'name': 'John Doe',
      'phone': '+62 812 3456 7890',
    },
    {
      'id': '2',
      'email': 'test@test.com',
      'password': 'test123',
      'name': 'Test User',
      'phone': '+62 811 1111 1111',
    },
  ];

  // Simulate API delay
  Future<void> _delay() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<UserModel> login(String email, String password) async {
    await _delay();

    final user = _mockUsers.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => throw Exception('Invalid email or password'),
    );

    return UserModel(
      id: user['id']!,
      email: user['email']!,
      name: user['name']!,
      phone: user['phone'],
    );
  }

  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    await _delay();

    // Check if email already exists
    final exists = _mockUsers.any((u) => u['email'] == email);
    if (exists) {
      throw Exception('Email already registered');
    }

    // Create new user
    final newUser = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'email': email,
      'password': password,
      'name': name,
      'phone': phone ?? '',
    };

    _mockUsers.add(newUser);

    return UserModel(
      id: newUser['id']!,
      email: newUser['email']!,
      name: newUser['name']!,
      phone: newUser['phone']!.isEmpty ? null : newUser['phone'],
    );
  }

  Future<void> logout() async {
    await _delay();
    // In real app, clear tokens, etc.
  }

  Future<UserModel?> getCurrentUser() async {
    await _delay();
    // In real app, check if user is logged in from shared preferences or secure storage
    return null;
  }
}