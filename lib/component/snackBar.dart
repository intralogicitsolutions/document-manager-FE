import 'package:flutter/material.dart';

import '../theme/theme.dart';

class CustomSnackbar {
  static void show(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.5 - 50, // Center vertically
        left: MediaQuery.of(context).size.width * 0.2, // Center horizontally
        right: MediaQuery.of(context).size.width * 0.2, // Center horizontally
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Themer.buttonColor, // You can replace this with Themer.buttonColor
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Remove the Snackbar after a delay
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}
