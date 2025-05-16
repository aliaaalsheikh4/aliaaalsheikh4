import 'package:flutter/material.dart';

class fixedtexts extends StatelessWidget {
  final String hintText;
  final TextEditingController theText;
  const fixedtexts({super.key, required this.hintText, required this.theText});

  @override
  Widget build(BuildContext context) {
    return TextFormField( 
              controller: theText,
              decoration: InputDecoration( 
                hintText: hintText, 
                filled: true, 
                fillColor: const Color(0xFFF5F4F2),
                contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0), 
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(31.5), 
                  borderSide: BorderSide.none, 
                ),
              ),
            );
  }
}

