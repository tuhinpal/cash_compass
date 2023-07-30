import 'package:flutter/material.dart';

class StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Color color;
  final int? rows;
  final TextInputType keyboardType;
  final Function? validator;

  const StyledTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.color = Colors.green,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.rows = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      minLines: rows,
      maxLines: rows,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: color),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: color,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: color,
          ),
        ),
        errorMaxLines: 1,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      validator: (value) {
        if (validator != null) return validator!(value);
        return null;
      },
      keyboardType: keyboardType,
      cursorColor: color,
    );
  }
}
