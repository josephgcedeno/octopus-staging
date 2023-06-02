import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';

class SidebarButton extends StatelessWidget {
  const SidebarButton({
    required this.title,
    required this.onTap,
    required this.icon,
    required this.isActive,
    Key? key,
  }) : super(key: key);
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ColoredBox(
      color: isActive
          ? kBlue.withOpacity(0.10)
          : Colors.white, // Set the desired background color
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: isActive ? kBlue : null,
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isActive
                ? kBlue
                : kLightBlack.withOpacity(
                    0.70,
                  ),
          ),
        ),
      ),
    );
  }
}
