import 'package:flutter/material.dart';

class DashboardButton extends StatelessWidget {
  const DashboardButton({
    required this.icon,
    required this.label,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final String label;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7F9),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(vertical: height * 0.03),
          child: Column(
            children: <Widget>[
              Icon(
                icon,
                color: theme.primaryColor,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  label,
                  style: theme.textTheme.bodyText1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
