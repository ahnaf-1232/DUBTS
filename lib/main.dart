import 'package:dubts/core/models/user_model.dart';
import 'package:dubts/core/services/auth_service.dart';
import 'package:dubts/core/services/background_location_service.dart';
import 'package:dubts/core/theme/app_theme.dart';
import 'package:dubts/screens/wrapper.dart';
import 'package:dubts/shared/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Initialize foreground task
  await BackgroundLocationService.initForegroundTask();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        title: 'Bus Koi',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 3)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen();
            } else {
              return const Wrapper();
            }
          },
        ),
      ),
    );
  }
}
