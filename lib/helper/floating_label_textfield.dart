import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FloatingLabelTextField extends StatefulWidget {
  const FloatingLabelTextField({super.key});

  @override
  State<FloatingLabelTextField> createState() => _FloatingLabelTextFieldState();
}

class _FloatingLabelTextFieldState extends State<FloatingLabelTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      style: const TextStyle(
        color: Color(0xFF2B3A58), // dark text color like screenshot
        fontSize: 18,
      ),
      cursorColor: Colors.blueGrey, // customize as you want
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Email Address',
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
        labelText: 'Email Address',
        labelStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        prefixIconConstraints: BoxConstraints(
          minWidth: 40,  // adjust this smaller to move label left
          minHeight: 40,
        ),
        prefixIcon: const Icon(
          Icons.mail_outline,
          color: Color(0xFF2B3A58),
        ),
        contentPadding: const EdgeInsets.only(left: 12, top: 16, bottom: 16, right: 20), // less left padding here
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) {
        setState(() {}); // rebuild to update UI if needed
      },
    );
  }
}
