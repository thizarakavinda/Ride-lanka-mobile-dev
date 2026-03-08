import 'package:flutter/material.dart';
import 'package:ride_lanka/features/auth/screens/login_screen.dart';
import 'package:ride_lanka/features/auth/screens/register_screen.dart';
import 'package:ride_lanka/features/splash/screens/land_screen.dart';
import 'package:ride_lanka/features/splash/screens/splash_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String land = '/land';
  static const String login = '/login';
  static const String register = '/register';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    land: (context) => const LandScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
  };
}
