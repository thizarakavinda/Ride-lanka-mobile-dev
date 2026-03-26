import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/core/constants/app_assets.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/auth/providers/auth_provider.dart';
import 'package:ride_lanka/features/auth/widgets/bottom_actions.dart';
import 'package:ride_lanka/features/auth/widgets/country_code_phone.dart';
import 'package:ride_lanka/features/auth/widgets/custom_textfield.dart';
import 'package:ride_lanka/features/auth/widgets/date_picker.dart';
import 'package:ride_lanka/features/auth/widgets/header_text.dart';
import 'package:ride_lanka/widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width > 600;
    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,
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
            child: Column(
              children: [
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: isTablet ? 550 : double.infinity,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: isTablet ? 40 : 25,
                      ),
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
                      child: SingleChildScrollView(
                        child: Consumer<AuthController>(
                          builder: (context, authProvider, child) {
                            return Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const HeaderText(
                                    h1: "Let's travel you in",
                                    h2: 'Discover Sri Lanka signup now',
                                  ),
                                  const SizedBox(height: 25),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomTextfield(
                                          labelText: 'First Name',
                                          keyboardType: TextInputType.name,
                                          isRegister: false,
                                          enabled: !authProvider.isLoading,
                                          controller:
                                              authProvider.firstNameController,
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: CustomTextfield(
                                          labelText: 'Last Name',
                                          keyboardType: TextInputType.name,
                                          isRegister: false,
                                          enabled: !authProvider.isLoading,
                                          controller:
                                              authProvider.lastNameController,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  CustomTextfield(
                                    labelText: 'Email',
                                    keyboardType: TextInputType.emailAddress,
                                    isRegister: false,
                                    enabled: !authProvider.isLoading,
                                    controller: authProvider.emailController,
                                  ),
                                  const SizedBox(height: 15),
                                  DatePicker(
                                    controller: authProvider.dobController,
                                    enabled: !authProvider.isLoading,
                                  ),
                                  const SizedBox(height: 15),
                                  CountryCodePhone(
                                    enabled: !authProvider.isLoading,
                                    controller:
                                        authProvider.phoneNumberController,
                                  ),
                                  const SizedBox(height: 15),
                                  CustomTextfield(
                                    labelText: 'Password',
                                    keyboardType: TextInputType.text,
                                    isRegister: false,
                                    isPassword: true,
                                    enabled: !authProvider.isLoading,
                                    controller: authProvider.passwordController,
                                  ),
                                  const SizedBox(height: 15),
                                  CustomTextfield(
                                    labelText: 'Confirm Password',
                                    keyboardType: TextInputType.text,
                                    isPassword: true,
                                    isRegister: false,
                                    enabled: !authProvider.isLoading,
                                    controller:
                                        authProvider.confirmPasswordController,
                                  ),
                                  const SizedBox(height: 25),
                                  authProvider.isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.lowPrimaryColor,
                                          ),
                                        )
                                      : PrimaryButton(
                                          buttonText: 'Register',
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              authProvider.signUp(context);
                                            }
                                          },
                                        ),
                                  const SizedBox(height: 15),
                                  BottomActions(
                                    title: 'Already have an account?',
                                    actionText: 'Login',
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
