import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/auth/providers/auth_provider.dart';
import 'package:ride_lanka/features/auth/widgets/auth_layout.dart';
import 'package:ride_lanka/features/auth/widgets/bottom_actions.dart';
import 'package:ride_lanka/features/auth/widgets/custom_divider.dart';
import 'package:ride_lanka/features/auth/widgets/custom_textfield.dart';
import 'package:ride_lanka/features/auth/widgets/google_button.dart';
import 'package:ride_lanka/features/auth/widgets/header_text.dart';
import 'package:ride_lanka/routes/app_routes.dart';
import 'package:ride_lanka/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {


    return AuthLayout(
      child: Consumer<AuthController>(
        builder: (context, authController, child) {
          return Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderText(
                  h1: "Let's travel you in",
                  h2: 'Discover Sri Lanka with every sign in',
                ),
                const SizedBox(height: 25),
                GoogleButton(onTap: () {}),
                const SizedBox(height: 25),
                const CustomDivider(),
                const SizedBox(height: 25),
                CustomTextfield(
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  isRegister: false,
                  controller: authController.emailController,
                  enabled: !authController.isLoading,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                CustomTextfield(
                  labelText: 'Password',
                  keyboardType: TextInputType.text,
                  isPassword: true,
                  isRegister: true, 
                  controller: authController.passwordController,
                  enabled: !authController.isLoading,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 25),
                authController.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.lowPrimaryColor,
                        ),
                      )
                    : PrimaryButton(
                        buttonText: 'Login',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            authController.signIn(context);
                          }
                        },
                      ),
                const SizedBox(height: 15),
                BottomActions(
                  title: "Don't have an account?",
                  actionText: 'Register',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.register,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
