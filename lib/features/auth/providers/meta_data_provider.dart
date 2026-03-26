import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/core/constants/app_dialogs.dart';
import 'package:ride_lanka/features/auth/models/user_model.dart';
import 'package:ride_lanka/features/auth/providers/auth_provider.dart';
import 'package:ride_lanka/features/auth/services/auth_service.dart';
import 'package:ride_lanka/routes/app_routes.dart';

class MetaDataProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  List<String> selectedInterests = [];
  String? travelType;
  String? budget;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get isValid =>
      selectedInterests.isNotEmpty && travelType != null && budget != null;

  void toggleInterest(String interest) {
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else {
      selectedInterests.add(interest);
    }
    notifyListeners();
  }

  void setTravelType(String type) {
    travelType = type;
    notifyListeners();
  }

  void setBudget(String value) {
    budget = value;
    notifyListeners();
  }

  Future<void> saveUser(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) throw Exception('User not found');

      final authController = Provider.of<AuthController>(
        context,
        listen: false,
      );

      final user = UserModel(
        uid: firebaseUser.uid,
        firstName: authController.firstNameController.text.trim(),
        lastName: authController.lastNameController.text.trim(),
        email: authController.emailController.text.trim(),
        dob: authController.dobController.text.trim(),
        phone: authController.phoneNumberController.text.trim(),
        interests: selectedInterests,
        travelType: travelType!,
        budget: budget!,
        createdAt: DateTime.now(),
      );

      await _authService.saveProfile(user);

      _isLoading = false;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 100));

      if (context.mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.homeBottomNav, (route) => false);
        AppDialogs.registerSuccessDialog(context);
      }
    } catch (e) {
      Logger().e('saveUser error: $e');
      _isLoading = false;
      notifyListeners();
      if (context.mounted) {
        if (e is SocketException || e is TimeoutException) {
          AppDialogs.networkErrorDialog(context);
        } else {
          AppDialogs.registerFailedDialog(context);
        }
      }
    }
  }
}
