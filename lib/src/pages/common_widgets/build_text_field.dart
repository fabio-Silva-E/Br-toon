import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BuildTextField extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSecret;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final bool readOnly;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextEditingController? controller;

  final GlobalKey<FormFieldState>? formFieldkey;
  const BuildTextField({
    super.key,
    required this.icon,
    required this.label,
    this.isSecret = false,
    this.inputFormatters,
    this.initialValue,
    this.readOnly = false,
    this.validator,
    this.controller,
    this.onSaved,
    this.formFieldkey,
  });

  @override
  State<BuildTextField> createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<BuildTextField> {
  bool isObscure = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isObscure = widget.isSecret;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        readOnly: widget.readOnly,
        initialValue: widget.initialValue,
        obscureText: isObscure,
        controller: widget.controller,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.icon),
          suffixIcon: widget.isSecret
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                  icon:
                      Icon(isObscure ? Icons.visibility : Icons.visibility_off),
                )
              : null,
          labelText: widget.label,
          labelStyle: const TextStyle(
            // Define o estilo do texto da label
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.visible, // Define a cor do texto da label
          ),
          isDense: true,
          filled: true,
          fillColor: Colors.grey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
