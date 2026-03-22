import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ride_lanka/core/constants/app_dialogs.dart';
import 'package:ride_lanka/core/utils/validators.dart';
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
      if (Validators.isEmpty(_firstNameController.text) ||
          Validators.isEmpty(_lastNameController.text) ||
          Validators.isEmpty(_emailController.text) ||
          Validators.isEmpty(_dobController.text) ||
          Validators.isEmpty(_phoneNumberController.text) ||
          Validators.isEmpty(_passwordController.text) ||
          Validators.isEmpty(_confirmPasswordController.text)) {
        throw Exception('Please fill all fields');
      }
      if (!Validators.isValidEmail(_emailController.text)) {
        throw Exception('Invalid email');
      }
      if (!Validators.isValidPassword(_passwordController.text)) {
        throw Exception('Weak password');
      }
      if (!Validators.doPasswordsMatch(
        _passwordController.text,
        _confirmPasswordController.text,
      )) {
        throw Exception('Passwords do not match');
      }

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> signIn(BuildContext context) async {
    try {
      if (Validators.isEmpty(_emailController.text) ||
          Validators.isEmpty(_passwordController.text)) {
        throw Exception('Please fill all fields');
      }
      if (!Validators.isValidEmail(_emailController.text)) {
        throw Exception('Invalid email');
      }

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
        AppDialogs.loginErrorDialog(context);
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
}
