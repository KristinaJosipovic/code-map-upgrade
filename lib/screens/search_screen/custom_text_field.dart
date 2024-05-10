import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {Key? key,
        required this.hint,
        this.suffixIcon,
        this.onTapSuffixIcon,
        this.obscureText = false,
        this.validator,
        this.onChanged,
        this.onEditingComplete,
        this.controller,
        required this.prefixIcon,
        this.filled = false,
        this.enabled = true,
        this.initialValue})
      : super(key: key);
  String hint;
  IconData prefixIcon;
  IconData? suffixIcon;
  VoidCallback? onTapSuffixIcon;
  bool obscureText;
  bool filled;
  bool enabled;
  String? initialValue;

  TextEditingController? controller;
  Function()? onEditingComplete;

  String? Function(String?)? validator;
  Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 50,
        child: TextFormField(
          initialValue: initialValue,
          onEditingComplete: onEditingComplete,
          controller: controller,
          onChanged: onChanged,
          validator: validator,
          obscureText: obscureText,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.black45),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.black45),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.black45),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(color: Colors.red),
            ),
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.black26,
            ),
            prefixIcon: Icon(
              prefixIcon,
              color: Colors.black,
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                suffixIcon,
                color: Colors.black,
                size: 20,
              ),
              onPressed: onTapSuffixIcon,
            ),
            fillColor: Colors.white,
            enabled: enabled,
          ),
        ),
      ),

    );
  }
}