import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ride_lanka/core/constants/app_dialogs.dart';
import 'package:ride_lanka/features/auth/services/auth_service.dart';
import 'package:ride_lanka/routes/app_routes.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final TextEditingController _firstNameController = TextEditingController();
  TextEditingController get firstNameController => _firstNameController;

  final TextEditingController _lastNameController = TextEditingController();
  TextEditingController get lastNameController => _lastNameController;

  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  final TextEditingController _dobController = TextEditingController();
  TextEditingController get dobController => _dobController;

  final TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController get phoneNumberController => _phoneNumberController;

  final TextEditingController _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  final TextEditingController _confirmPasswordController =
      TextEditingController();
  TextEditingController get confirmPasswordController =>
      _confirmPasswordController;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void clearControllers() {
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _dobController.clear();
    _phoneNumberController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  Future<void> signUp(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = await _authService.registerUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (user == null) {
        if (context.mounted) AppDialogs.registerFailedDialog(context);
        return;
      }

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.metadata);
      }
    } catch (e) {
      Logger().e('signUp error: $e');
      if (context.mounted) {
        if (e is SocketException ||
            e is TimeoutException ||
            (e is FirebaseAuthException && e.code == 'network-request-failed')) {
          AppDialogs.networkErrorDialog(context);
        } else {
          AppDialogs.registerFailedDialog(context);
        }
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = await _authService.signInUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        context: context,
      );

      if (user == null) {
        if (context.mounted) AppDialogs.loginFailedDialog(context);
        return;
      }

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.homeBottomNav,
          (route) => false,
        );
      }
    } catch (e) {
      Logger().e('signIn error: $e');
      if (context.mounted) {
        if (e is SocketException ||
            e is TimeoutException ||
            (e is FirebaseAuthException && e.code == 'network-request-failed')) {
          AppDialogs.networkErrorDialog(context);
        } else {
          AppDialogs.loginErrorDialog(context);
        }
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _authService.signOutUser();
      clearControllers();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } catch (e) {
      Logger().e('signOut error: $e');
      if (context.mounted) {
        if (e is SocketException || e is TimeoutException) {
          AppDialogs.networkErrorDialog(context);
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    }
  }
}
