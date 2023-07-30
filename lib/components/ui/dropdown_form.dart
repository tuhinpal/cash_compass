import 'package:flutter/material.dart';

class StyledDropdownButtonFormField extends StatelessWidget {
  final List<DropdownMenuItem> items;
  final String? value;
  final Function? onChanged;
  final Function? validator;
  final String labelText;
  final Color color;

  const StyledDropdownButtonFormField({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
    required this.labelText,
    this.color = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      items: items,
      value: value,
      onChanged: (value) {
        if (onChanged != null) onChanged!(value);
      },
      validator: (value) {
        if (validator != null) return validator!(value);
        return null;
      },
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
    );
  }
}
