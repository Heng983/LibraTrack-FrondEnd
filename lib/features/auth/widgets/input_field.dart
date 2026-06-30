import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextInputType keyboardType;
  final Widget? suffix;
  final String? Function(String?)? validator;

  const InputField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.suffix,
    this.validator,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool _isObscure;
  bool _isValid = false;
  bool _isDirty = false; // track if user has typed

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscure;
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (widget.validator != null) {
      final error = widget.validator!(widget.controller.text);
      setState(() {
        _isDirty = widget.controller.text.isNotEmpty;
        _isValid = error == null && _isDirty;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // border color logic
    Color borderColor = AppColors.borderColor;
    if (_isDirty && _isValid) {
      borderColor = Colors.green;
    }

    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscure,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(color: AppColors.navy, fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.fieldBg,
        hintText: widget.hint,
        hintStyle: const TextStyle(color: AppColors.hintGray, fontSize: 14),
        prefixIcon: Icon(widget.icon, color: AppColors.hintGray, size: 20),
        suffixIcon: widget.obscure
            ? IconButton(
                icon: Icon(
                  _isObscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.hintGray,
                  size: 20,
                ),
                onPressed: () => setState(() => _isObscure = !_isObscure),
              )
            : widget.suffix,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),

        // ── Normal border ──
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor),
        ),

        // ── Focused border ──
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: _isValid ? Colors.green : AppColors.navy,
            width: 1.5,
          ),
        ),

        // ── Error border ──
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),

        // ── Focused error border ──
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),

        errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }
}
