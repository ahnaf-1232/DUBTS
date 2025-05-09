import 'package:dubts/core/models/user_model.dart';
import 'storage_service.dart';

abstract class AuthService {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String name, String email, String password, {bool isGuide = false});
  Future<void> signOut();
  Future<void> verifyEmail(String code);
  Future<void> sendVerificationCode(String email);
  Future<void> resetPassword(String email);
}

class AuthServiceImpl implements AuthService {
  final StorageService _storageService;

  AuthServiceImpl(this._storageService);

  @override
  Future<UserModel?> getCurrentUser() async {
    final userData = await _storageService.read('user');
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock user data
    final user = UserModel(
      id: '1',
      name: 'John Doe',
      email: email,
      createdAt: DateTime.now(),
    );
    
    // Save user data
    await _storageService.write('user', user.toJson());
    
    return user;
  }

  @override
  Future<UserModel> signUp(String name, String email, String password, {bool isGuide = false}) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock user data
    final user = UserModel(
      id: '1',
      name: name,
      email: email,
      isGuide: isGuide,
      createdAt: DateTime.now(),
    );
    
    // Save user data
    await _storageService.write('user', user.toJson());
    
    return user;
  }

  @override
  Future<void> signOut() async {
    await _storageService.delete('user');
  }

  @override
  Future<void> verifyEmail(String code) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Validate code
    if (code != '537689') {
      throw Exception('Invalid verification code');
    }
  }

  @override
  Future<void> sendVerificationCode(String email) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> resetPassword(String email) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
  }
}