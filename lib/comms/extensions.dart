import 'package:flutter/material.dart';

extension TouchAnimationExtensions on Widget {

  Widget withLongPress(void Function() onLongPress) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: this,
    );
  }

  Widget clickAnim(Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: this,
    );
  }

}