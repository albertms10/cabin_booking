import 'package:flutter/material.dart';

class JumpBarItem extends StatelessWidget {
  final IconData? icon;
  final Widget? child;
  final bool selected;
  final VoidCallback? onTap;

  const JumpBarItem({
    super.key,
    this.icon,
    this.child,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: child,
      selected: selected,
      onTap: onTap,
    );
  }
}
