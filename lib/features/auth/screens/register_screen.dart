import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/features/auth/providers/auth_provider.dart';
import 'package:ride_lanka/features/auth/widgets/bottom_actions.dart';
import 'package:ride_lanka/features/auth/widgets/country_code_phone.dart';
import 'package:ride_lanka/features/auth/widgets/custom_textfield.dart';
import 'package:ride_lanka/features/auth/widgets/date_picker.dart';
import 'package:ride_lanka/features/auth/widgets/auth_layout.dart';
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
    return AuthLayout(
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
                        controller: authProvider.firstNameController,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustomTextfield(
                        labelText: 'Last Name',
                        keyboardType: TextInputType.name,
                        isRegister: false,
                        enabled: !authProvider.isLoading,
                        controller: authProvider.lastNameController,
                        textInputAction: TextInputAction.next,
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
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 15),
                DatePicker(
                  controller: authProvider.dobController,
                  enabled: !authProvider.isLoading,
                ),
                const SizedBox(height: 15),
                CountryCodePhone(
                  enabled: !authProvider.isLoading,
                  controller: authProvider.phoneNumberController,
                ),
                const SizedBox(height: 15),
                CustomTextfield(
                  labelText: 'Password',
                  keyboardType: TextInputType.text,
                  isRegister: false,
                  isPassword: true,
                  enabled: !authProvider.isLoading,
                  controller: authProvider.passwordController,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 15),
                CustomTextfield(
                  labelText: 'Confirm Password',
                  keyboardType: TextInputType.text,
                  isPassword: true,
                  isRegister: false, 
                  enabled: !authProvider.isLoading,
                  controller: authProvider.confirmPasswordController,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Confirm Password is required";
                    }
                    if (value != authProvider.passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                authProvider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.lowPrimaryColor,
                        ),
                      )
                    : PrimaryButton(
                        buttonText: 'Register',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
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
    );
  }
}
