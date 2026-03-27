import 'package:flutter/material.dart';
import 'package:ride_lanka/core/constants/app_colors.dart';
import 'package:ride_lanka/core/utils/validators.dart';
import 'package:ride_lanka/routes/app_routes.dart';

class CustomTextfield extends StatefulWidget {
  final String labelText;
  final bool isPassword;
  final bool isRegister;
  final bool enabled;

  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  const CustomTextfield({
    super.key,
    required this.labelText,
    this.isPassword = false,
    this.isRegister = true,
    this.enabled = true,
    this.keyboardType,
    this.controller,
    this.textInputAction,
    this.validator,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  bool _rememberMe = false;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: const TextStyle(
            color: AppColors.dividerText,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          enabled: widget.enabled,
          obscureText: widget.isPassword && _isObscure,
          textInputAction: widget.textInputAction,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          validator:
              widget.validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  if (widget.labelText == 'First Name' ||
                      widget.labelText == 'Last Name') {
                    return "Required field";
                  }

                  return "${widget.labelText} is required";
                }

                if (widget.labelText == "Email" &&
                    !Validators.isValidEmail(value)) {
                  return "Enter a valid email";
                }

                if (widget.labelText == "Password" &&
                    !Validators.isValidPassword(value)) {
                  return "Password must be stronger";
                }

                return null;
              },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.withOpacity(0.05),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.buttonBorder,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.buttonBorder,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
              borderRadius: BorderRadius.circular(15),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _isObscure
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: AppColors.grey,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => _isObscure = !_isObscure);
                    },
                  )
                : null,
          ),
        ),
        if (widget.isRegister)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _rememberMe,
                        activeColor: AppColors.lowPrimaryColor,
                        onChanged: (value) {
                          setState(() => _rememberMe = value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Remember me',
                      style: TextStyle(
                        color: AppColors.dividerText,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.passwordreset);
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: AppColors.forgotPasswordText,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
