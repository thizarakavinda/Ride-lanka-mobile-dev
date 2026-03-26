import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_assets.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/auth/services/auth_service.dart';
import 'package:ride_lanka/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkConnectivityAndNavigate();
  }

  Future<void> _checkConnectivityAndNavigate() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      if (!mounted) return;
      _showNoInternetDialog();
    } else {
      _handleSplashNavigation();
    }
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('No Internet Connection'),
        content: const Text(
          'Please check your internet connection to continue. Some features may not work offline.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _checkConnectivityAndNavigate();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSplashNavigation() async {
    final stopwatch = Stopwatch()..start();

    if (FirebaseAuth.instance.currentUser != null) {
      try {
        final profileFuture = AuthService().fetchProfile();
        
        await Future.wait([
          Future.delayed(const Duration(seconds: 3)),
          profileFuture,
        ]);

        final profile = await profileFuture;
        
        if (!mounted) return;

        if (profile != null) {
          Navigator.pushReplacementNamed(context, AppRoutes.homeBottomNav);
        } else {
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      } catch (e) {
        final elapsed = stopwatch.elapsedMilliseconds;
        if (elapsed < 3000) {
          await Future.delayed(Duration(milliseconds: 3000 - elapsed));
        }
        
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, AppRoutes.homeBottomNav);
      }
    } else {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.land);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppAssets.logo),
            const SizedBox(height: 10),
            Text(
              'Ride',
              style: TextStyle(color: AppColors.white, fontSize: 18),
            ),
            Text(
              'L a n k a',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
