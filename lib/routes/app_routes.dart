import 'package:flutter/material.dart';
import 'package:ride_lanka/features/auth/screens/login_screen.dart';
import 'package:ride_lanka/features/auth/screens/meta_data_screen.dart';
import 'package:ride_lanka/features/auth/screens/password_reset_screen.dart';
import 'package:ride_lanka/features/auth/screens/register_screen.dart';
import 'package:ride_lanka/features/home/screens/main_home.dart';
import 'package:ride_lanka/features/badges/screens/badges_info.dart';
import 'package:ride_lanka/features/home/screens/place_details.dart';
import 'package:ride_lanka/features/profile/screens/profile_screen.dart';
import 'package:ride_lanka/features/quests/screens/quests_screen.dart';
import 'package:ride_lanka/features/splash/screens/land_screen.dart';
import 'package:ride_lanka/features/splash/screens/splash_screen.dart';
import 'package:ride_lanka/features/trip%20history/screens/trip_history.dart';
import 'package:ride_lanka/features/trip/screens/new_trip_screen.dart';
import 'package:ride_lanka/features/trip/screens/trip_plan_screen.dart';
import 'package:ride_lanka/features/wishlist/screens/wishlist_screen.dart';
import 'package:ride_lanka/home_bottom_nav.dart';

class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String land = '/land';
  static const String login = '/login';
  static const String register = '/register';
  static const String passwordreset = 'passwordreset';
  static const String metadata = '/metadata';
  static const String homeBottomNav = '/homeBottomNav';
  static const String home = '/home';
  static const String wishlist = '/wishlist';
  static const String tripPlan = '/tripPlan';
  static const String profile = '/profile';
  static const String badgesInfo = '/badges';
  static const String quests = '/quests';
  static const String tripHistory = '/history';
  static const String placeDetails = '/placeDetails';
  static const String newTrpPlanScreen = '/newTripPlanScreen';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    land: (context) => const LandScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    passwordreset: (context) => const PasswordResetScreen(),
    metadata: (context) => const MetaDataScreen(),
    homeBottomNav: (context) => const HomeBottomNav(),
    home: (context) => const MainHome(),
    wishlist: (context) => const WishlistScreen(),
    tripPlan: (context) => TripPlanScreen(),
    profile: (context) => const ProfileScreen(),
    badgesInfo: (context) => const BadgesInfo(),
    quests: (context) => const QuestsScreen(),
    tripHistory: (context) => const TripHistory(),
    placeDetails: (context) => const PlaceDetails(),
    newTrpPlanScreen: (context) => const NewTripScreen(),
  };
}
