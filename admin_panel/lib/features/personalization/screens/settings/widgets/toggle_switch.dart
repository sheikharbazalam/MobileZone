import 'package:flutter/material.dart';
import 'package:t_utils/utils/constants/colors.dart';

class ToggleSwitch extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;

  const ToggleSwitch({super.key, required this.title, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Switch(value: value, onChanged: onChanged, activeColor: TColors().primary),
      ],
    );
  }
}
