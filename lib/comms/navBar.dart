import 'dart:io';

import 'package:flutter/material.dart';

import '../theme/theme.dart';

class NavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const NavBar({
    super.key,
    required this.pageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      shape: const CircularNotchedRectangle(),
      notchMargin: 2.0,
      elevation: 0.0,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: SizedBox.expand(
          child: Container(
            //width: double.infinity,
            height: 60,
            color: Themer.gradient1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                navItem(
                  Icons.home_outlined,
                  pageIndex == 0,
                  onTap: () => onTap(0),
                ),
                navItem(
                  Icons.message_outlined,
                  pageIndex == 1,
                  onTap: () => onTap(1),
                ),
                const SizedBox(width: 80),
                navItem(
                  Icons.notifications_none_outlined,
                  pageIndex == 2,
                  onTap: () => onTap(2),
                ),
                navItem(
                  Icons.person_outline,
                  pageIndex == 3,
                  onTap: () => onTap(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget navItem(IconData icon, bool selected, {Function()? onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: selected ? Colors.white : Colors.white.withOpacity(0.4),
        ),
      ),
    );
  }
}