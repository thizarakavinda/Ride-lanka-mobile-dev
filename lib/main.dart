import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/features/auth/providers/auth_provider.dart';
import 'package:ride_lanka/features/auth/providers/meta_data_provider.dart';
import 'package:ride_lanka/features/home/providers/home_provider.dart';
import 'package:ride_lanka/features/quests/providers/quests_provider.dart';
import 'package:ride_lanka/features/trip/providers/trip_provider.dart';
import 'package:ride_lanka/features/trip/services/trip_service.dart';
import 'package:ride_lanka/features/wishlist/providers/wishlist_provider.dart';
import 'package:ride_lanka/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => MetaDataProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => TripProvider(TripService())),
        ChangeNotifierProvider(create: (_) => QuestProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.splash,
    );
  }
}
