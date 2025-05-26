import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/app_user.dart';
import 'package:path_provider/path_provider.dart';
class AuthProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  // SignUp saves user data securely (simulate)
  Future<void> signUp(String name, String email, String password) async {
    // Save user details in secure storage
    await _storage.write(key: 'name', value: name);
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'password', value: password);

    _currentUser = AppUser(name: name, email: email);
    notifyListeners();
  }

  // Login checks saved credentials (simulate)
  Future<void> login(String email, String password) async {
    final storedEmail = await _storage.read(key: 'email');
    final storedPassword = await _storage.read(key: 'password');
    final storedName = await _storage.read(key: 'name');

    if (email == storedEmail && password == storedPassword) {
      _currentUser = AppUser(name: storedName ?? 'User', email: email);
      notifyListeners();
    } else {
      throw Exception('Invalid email or password');
    }
  }
  Future<void> updateUser({required String name, required String email}) async {
    if (_currentUser == null) {
      throw Exception('No user logged in');
    }
    // Update secure storage
    await _storage.write(key: 'name', value: name);
    await _storage.write(key: 'email', value: email);

    // Update currentUser model
    _currentUser = AppUser(name: name, email: email);
    notifyListeners();
  }

  static const _keyImagePath = 'profile_image_path';

  Future<void> saveProfileImagePath(String path) async {
    await _storage.write(key: _keyImagePath, value: path);
  }

  Future<String?> getProfileImagePath() async {
    return await _storage.read(key: _keyImagePath);
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final storedEmail = await _storage.read(key: 'email');
    final storedPassword = await _storage.read(key: 'password');
    final storedName = await _storage.read(key: 'name');

    if (storedEmail != null && storedPassword != null) {
      _currentUser = AppUser(name: storedName ?? 'User', email: storedEmail);
      notifyListeners();
      return true;
    }
    return false;
  }
}