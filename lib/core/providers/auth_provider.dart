import 'package:dubts/core/models/user_model.dart';
import 'package:dubts/core/services/auth_service.dart';
import 'package:flutter/material.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  
  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;
  
  AuthProvider(this._authService) {
    _checkCurrentUser();
  }
  
  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  
  Future<void> _checkCurrentUser() async {
    _status = AuthStatus.loading;
    notifyListeners();
    
    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        _user = user;
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
    }
    
    notifyListeners();
  }
  
  Future<bool> signIn(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final user = await _authService.signIn(email, password);
      _user = user;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> signUp(String name, String email, String password, {bool isGuide = false}) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final user = await _authService.signUp(name, email, password, isGuide: isGuide);
      _user = user;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<void> signOut() async {
    _status = AuthStatus.loading;
    notifyListeners();
    
    try {
      await _authService.signOut();
      _user = null;
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
    }
    
    notifyListeners();
  }
  
  Future<bool> verifyEmail(String code) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
    
    try {
      await _authService.verifyEmail(code);
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> sendVerificationCode(String email) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
    
    try {
      await _authService.sendVerificationCode(email);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> resetPassword(String email) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
    
    try {
      await _authService.resetPassword(email);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}