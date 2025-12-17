import 'package:flutter/material.dart';

class TextfieldPrefixIcon extends StatelessWidget {
  final String assetName;
  const TextfieldPrefixIcon({super.key, required this.assetName});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 10, bottom: 14, top: 14),
        height: 14,
        width: 14,
        child: Image.asset(
          assetName,
          height: 13,
          width: 13,
          fit: BoxFit.contain,
        ),
    );
  }
}