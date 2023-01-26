import 'package:flutter/material.dart';

enum LeadingButton {
  name,
  back,
  menu,
}

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlobalAppBar({required this.leading, Key? key}) : super(key: key);

  final LeadingButton leading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Widget nameButton = RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'Good Morning!\n',
            style: theme.textTheme.bodyText2?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: 'Angel', style: theme.textTheme.caption),
        ],
      ),
    );

    final Widget backButton = IconButton(
      onPressed: () {},
      icon: const Icon(Icons.keyboard_arrow_left_rounded),
    );

    final Widget menuButton = IconButton(
      onPressed: () {
        Navigator.of(context).popUntil((Route<dynamic> route) => route.isFirst);
      },
      icon: const Icon(
        Icons.grid_view_rounded,
        color: Colors.black,
      ),
    );

    Widget leadingButton() {
      switch (leading) {
        case LeadingButton.name:
          return nameButton;
        case LeadingButton.back:
          return backButton;
        case LeadingButton.menu:
          return menuButton;
      }
    }

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      centerTitle: false,
      title: leadingButton(),
      actions: const <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.blueAccent,
            child: Icon(
              Icons.face,
              color: Colors.white,
            ),
          ),
        ),
      ],
      elevation: 0,
    );
  }
}
