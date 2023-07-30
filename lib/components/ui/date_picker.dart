import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StyledDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Color color;
  final DateTime? date;
  final Function? validator;

  const StyledDatePicker({
    super.key,
    required this.controller,
    required this.labelText,
    this.color = Colors.green,
    this.date,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000, 1),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          controller.text = formattedDate;
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
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
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          validator: (value) {
            if (validator != null) return validator!(value);
            return null;
          },
          cursorColor: color,
        ),
      ),
    );
  }
}
