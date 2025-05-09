import 'package:dubts/features/auth/presentation/screens/become_guide_screen.dart';
import 'package:dubts/features/auth/presentation/screens/login_screen.dart';
import 'package:dubts/features/auth/presentation/screens/signup_screen.dart';
import 'package:dubts/features/auth/presentation/screens/verify_email_screen.dart';
import 'package:dubts/features/bus/presentation/screens/bus_details_screen.dart';
import 'package:dubts/features/home/presentation/screens/home_screen.dart';
import 'package:dubts/features/splash/presentation/screens/launch_screen.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String launch = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String becomeGuide = '/become-guide';
  static const String verifyEmail = '/verify-email';
  static const String home = '/home';
  static const String busDetail = '/bus-detail';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.launch,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.launch,
        builder: (context, state) => const LaunchScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.becomeGuide,
        builder: (context, state) => const BecomeGuideScreen(),
      ),
      GoRoute(
        path: AppRoutes.verifyEmail,
        builder: (context, state) => const VerifyEmailScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.busDetail,
        builder: (context, state) {
          final busId = state.uri.queryParameters['id'];
          return BusDetailScreen(busId: busId);
        },
      ),
    ],
  );
}