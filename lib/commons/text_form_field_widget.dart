import 'package:esjerukkadiri/commons/colors.dart';
import 'package:esjerukkadiri/commons/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    super.key,
    this.controller,
    required this.hint,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.suffixIcon,
    this.onTapSuffixIcon,
    this.prefixIcon,
    this.filled = false,
    this.enabled = true,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.height = 50,
    this.inputFormatters,
  });
  final String hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onTapSuffixIcon;
  final bool obscureText;
  final bool filled;
  final bool enabled;
  final String? initialValue;
  final TextInputType keyboardType;
  final int maxLines;
  final double height;
  final List<TextInputFormatter>? inputFormatters;

  final TextEditingController? controller;
  final Function()? onEditingComplete;

  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        inputFormatters: inputFormatters ?? const [],
        controller: controller,
        initialValue: initialValue,
        maxLines: maxLines,
        onEditingComplete: onEditingComplete,
        onChanged: onChanged,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontFamily: "Inter", fontSize: 16),
        textCapitalization: TextCapitalization.characters,
        decoration: InputDecoration(
          labelText: hint,
          labelStyle: const TextStyle(
            fontFamily: "Inter",
            fontSize: MySizes.fontSizeSm,
          ),
          hintStyle: TextStyle(
            fontFamily: "Inter",
            fontSize: MySizes.fontSizeSm,
            color: Colors.grey[400],
          ),
          floatingLabelStyle: const TextStyle(color: MyColors.primary),
          contentPadding: const EdgeInsets.all(10),
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 0.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 0.0),
          ),
          // hintText: hint,
          // hintStyle: const TextStyle(
          //   fontFamily: "Inter",
          //   fontSize: MySizes.fontSizeSm,
          // ),
          prefixIcon:
              prefixIcon != null
                  ? Icon(prefixIcon, color: MyColors.primary, size: 25)
                  : null,
          suffixIcon:
              suffixIcon != null
                  ? IconButton(
                    icon: Icon(suffixIcon, color: MyColors.primary, size: 15),
                    onPressed: onTapSuffixIcon,
                  )
                  : null,
          filled: filled,
          // enabled: enabled,
        ),
      ),
    );
  }
}
