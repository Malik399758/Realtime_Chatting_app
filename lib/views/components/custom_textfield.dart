import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool? obscure;
  final IconData? prefixIcon;
  final IconData? postfixIcon;
  final VoidCallback? voidCallback;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    this.labelText,
    required this.hintText,
    required this.controller,
    required this.textInputType,
    this.voidCallback,
    this.obscure = false,
    this.postfixIcon,
    this.prefixIcon,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool isObscured;

  @override
  void initState() {
    super.initState();
    isObscured = widget.obscure ?? false; // Ensure initial state reflects `obscure`
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscured,
      validator: widget.validator,
      controller: widget.controller,
      keyboardType: widget.textInputType,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        filled: true,
        fillColor: Colors.grey.shade200,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: widget.postfixIcon == Icons.visibility
            ? IconButton(
          icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => isObscured = !isObscured),
        )
            : widget.postfixIcon != null
            ? Icon(widget.postfixIcon)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
