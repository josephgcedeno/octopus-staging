import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/service/cubit/secure_storage_cubit_cubit.dart';
import 'package:octopus/interfaces/screens/members_profile_screen.dart';
import 'package:octopus/interfaces/screens/side_bar_screen.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/internal/local_storage.dart';

enum LeadingButton {
  name,
  back,
  menu,
}

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlobalAppBar({
    required this.leading,
    this.isShowUserIcon = true,
    Key? key,
  }) : super(key: key);

  final LeadingButton leading;
  final bool isShowUserIcon;

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
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: 'Angel', style: theme.textTheme.bodySmall),
        ],
      ),
    );

    final Widget backButton = GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: const Icon(
        Icons.chevron_left,
        color: Colors.black,
      ),
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
      actions: <Widget>[
        if (isShowUserIcon)
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () {
                final PageRoute<dynamic> withAnimation =
                    leading == LeadingButton.name
                        ? MaterialPageRoute<dynamic>(
                            builder: (_) => const SidebarScreen(
                              child: MembersProfileScreen(
                                userView: UserView.user,
                              ),
                            ),
                          )
                        : PageRouteBuilder<dynamic>(
                            pageBuilder: (
                              BuildContext context,
                              Animation<double> animation1,
                              Animation<double> animation2,
                            ) =>
                                const SidebarScreen(
                              child: MembersProfileScreen(
                                userView: UserView.user,
                              ),
                            ),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          );
                Navigator.of(context).push(withAnimation);
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.blueAccent,
                child: FutureBuilder<String?>(
                  future: context
                      .read<SecureStorageCubit>()
                      .read(key: lsProfileImageSource),
                  builder:
                      (BuildContext context, AsyncSnapshot<String?> snapshot) {
                    if (snapshot.data != null) {
                      return Image.network(
                        snapshot.data!,
                      );
                    }
                    return lineLoader(
                      height: 30,
                      width: 30,
                      borderRadius: BorderRadius.circular(50),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
      elevation: 0,
    );
  }
}
