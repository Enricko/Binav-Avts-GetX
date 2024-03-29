import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.label,
    this.suffix,
    required this.type,
    this.initValue,
    this.validator,
    this.inputFormatters,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final String hint;
  final String? label;
  final String? suffix;
  final String? Function(String? value)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final String? initValue;
  final bool? readOnly;
  final TextInputType type;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(" $hint",style: GoogleFonts.roboto(color: Colors.black, fontSize: 15,fontWeight: FontWeight.w500),),
        SizedBox(
          width: double.infinity,
          child: TextFormField(
            readOnly: readOnly!,
            style: const TextStyle(fontSize: 14),
            controller: controller,
            initialValue: initValue,
            keyboardType: type,
            validator: validator,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
                hintText: hint,
                labelText: label,
                suffixText: suffix,
                // suffixStyle: Constants.labelstyle,
                labelStyle: Constants.labelstyle,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                ),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.black38)),
                disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.black38)),
                errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                filled: true,
                fillColor: Colors.white),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
