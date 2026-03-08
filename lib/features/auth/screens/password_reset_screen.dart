import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_assets.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/core/constants/app_dialogs.dart';
import 'package:ride_lanka/features/auth/widgets/bottom_actions.dart';
import 'package:ride_lanka/features/auth/widgets/custom_textfield.dart';
import 'package:ride_lanka/features/auth/widgets/header_text.dart';
import 'package:ride_lanka/widgets/primary_button.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final bool isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.white,

      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssets.loginBack,
              filterQuality: FilterQuality.high,
              fit: BoxFit.cover,
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
                          width: isTablet ? 60 : 43,
                          height: isTablet ? 50 : 33,
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HeaderText(
                            h1: "Reset your password",
                            h2: 'Provide your email for send the password reset link',
                          ),
                          const SizedBox(height: 25),
                          const CustomTextfield(
                            labelText: 'Email',
                            isRegister: false,
                          ),
                          const SizedBox(height: 20),
                          PrimaryButton(
                            buttonText: 'Send',
                            onPressed: () {
                              AppDialogs.passwordResetSendSuccessDialog(
                                context,
                              );
                            },
                          ),
                          const SizedBox(height: 15),
                          BottomActions(
                            title: 'Remember Me?',
                            actionText: 'Login',
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
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
