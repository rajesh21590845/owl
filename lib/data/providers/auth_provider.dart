import 'package:flutter/foundation.dart';
import '../models/app_user.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _currentUser;

  AppUser? get currentUser => _currentUser;

  void login(String name, String email) {
    _currentUser = AppUser(name: name, email: email);
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
