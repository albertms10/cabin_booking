import 'package:flutter/material.dart';

class JumpBarField extends StatelessWidget {
  final TextEditingController? controller;

  const JumpBarField({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Type a new booking',
        filled: false,
        border: InputBorder.none,
        icon: Padding(
          padding: EdgeInsetsDirectional.only(start: 12),
          child: Icon(Icons.search),
        ),
        contentPadding: EdgeInsetsDirectional.only(end: 16),
      ),
    );
  }
}
