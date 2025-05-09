import 'package:dubts/core/providers/auth_provider.dart';
import 'package:dubts/core/providers/theme_provider.dart';
import 'package:dubts/core/services/auth_service.dart';
import 'package:dubts/core/services/bus_service.dart';
import 'package:dubts/core/services/storage_service.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Services
  getIt.registerLazySingleton<StorageService>(() => StorageServiceImpl());
  getIt.registerLazySingleton<AuthService>(() => AuthServiceImpl(getIt<StorageService>()));
  getIt.registerLazySingleton<BusService>(() => BusServiceImpl());
  
  // Providers
  getIt.registerFactory<ThemeProvider>(() => ThemeProvider(getIt<StorageService>()));
  getIt.registerFactory<AuthProvider>(() => AuthProvider(getIt<AuthService>()));
}