import 'package:flutter/material.dart';
import 'package:octopus/module/home/interfaces/screens/home_screen.dart';
import 'package:octopus/module/menu/interfaces/screens/menu_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class ControllerScreen extends StatefulWidget {
  const ControllerScreen({Key? key}) : super(key: key);
  static const String routeName = '/controller';

  @override
  State<ControllerScreen> createState() => _ControllerScreenState();
}

class _ControllerScreenState extends State<ControllerScreen> {
  final PersistentTabController _controller = PersistentTabController();

  List<Widget> _buildScreens() {
    return <Widget>[
      const HomeScreen(),
      const HomeScreen(),
      const MenuScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return <PersistentBottomNavBarItem>[
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.dashboard_rounded,
        ),
        activeColorPrimary: Colors.orange,
        inactiveColorPrimary: Colors.white,
        title: 'Dashboard',
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.document_scanner,
        ),
        activeColorPrimary: Colors.orange,
        inactiveColorPrimary: Colors.white,
        title: 'DSR',
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.menu_rounded,
        ),
        activeColorPrimary: Colors.orange,
        inactiveColorPrimary: Colors.white,
        title: 'Others',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        backgroundColor: const Color(0xFF017BFF),
        resizeToAvoidBottomInset: true,
        itemAnimationProperties: const ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: true,
        ),
        navBarStyle: NavBarStyle.neumorphic,
      ),
    );
  }
}
