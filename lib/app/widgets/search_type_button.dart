import 'package:flutter/material.dart';

class SearchTypeButton extends StatelessWidget {
  const SearchTypeButton({
    super.key,
    required this.name,
    required this.isSelected,
    required this.onPressed,
  });

  final String name;
  final bool isSelected;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
              width: 2.0,
              color: isSelected ? Colors.green.shade300 : Colors.white70),
          backgroundColor: isSelected ? Colors.green : Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Text(name),
      ),
    );
  }
}
