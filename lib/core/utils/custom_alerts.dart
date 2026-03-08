import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/widgets/primary_button.dart';

class CustomAlerts extends StatelessWidget {
  final String alertTitle;
  final String subTitle;
  final String? buttonText;

  const CustomAlerts({
    super.key,
    required this.alertTitle,
    required this.subTitle,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width > 600;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isTablet ? 400 : size.width * 0.9,
          ),
          padding: const EdgeInsets.all(25),
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
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                alertTitle,
                style: const TextStyle(
                  fontFamily: 'Helvetica1',
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subTitle,
                style: const TextStyle(fontFamily: 'Helvetica1', fontSize: 14),
              ),
              const SizedBox(height: 25),
              PrimaryButton(
                buttonText: buttonText ?? 'Try Again',
                onPressed: () {
                  buttonText == 'Login'
                      ? Navigator.pushNamed(context, '/login')
                      : Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
