import 'package:flutter/material.dart';

class CustomGradientBackground extends StatelessWidget {
  final Widget child;
  const CustomGradientBackground({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xffa49bbf),
            Color(0xff020715),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}
