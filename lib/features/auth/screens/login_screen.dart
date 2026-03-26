import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/core/constants/app_assets.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/auth/providers/auth_provider.dart';
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
    final size = MediaQuery.of(context).size;

    final bool isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.white,

      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          RepaintBoundary(
            child: Image.asset(
              AppAssets.loginBack,
              filterQuality: FilterQuality.low,
              fit: BoxFit.cover,
              width: size.width,
              height: size.height,
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          AppAssets.logo,
                          color: AppColors.black,
                          width: 43,
                          height: 33,
                        ),
                        const Text(
                          'Ride\nLanka',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: isTablet ? 500 : double.infinity,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: isTablet ? 40 : 30,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(50),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
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
                                ),
                                const SizedBox(height: 20),
                                CustomTextfield(
                                  labelText: 'Password',
                                  keyboardType: TextInputType.text,
                                  isPassword: true,
                                  isRegister: true,
                                  controller: authController.passwordController,
                                  enabled: !authController.isLoading,
                                ),
                                const SizedBox(height: 25),
                                authController.isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.lowPrimaryColor,
                                        ),
                                      )
                                    : PrimaryButton(
                                        buttonText: 'Login',
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
