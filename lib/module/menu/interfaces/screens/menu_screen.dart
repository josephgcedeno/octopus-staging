import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:octopus/module/admin/interfaces/screens/admin_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  static const String routeName = '/menu';

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<List<IconData>> actionIcons = <List<IconData>>[
    <IconData>[
      Icons.abc,
      Icons.ac_unit,
      Icons.access_alarms_outlined,
    ],
    <IconData>[
      Icons.accessibility_outlined,
      Icons.account_balance_rounded,
      Icons.account_balance_wallet_rounded
    ],
    <IconData>[
      Icons.account_box_rounded,
      Icons.admin_panel_settings_rounded,
      Icons.admin_panel_settings_rounded,
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    // final double height = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          for (int i = 0; i < 3; i++)
            Row(
              children: <Widget>[
                for (int j = 0; j < 3; j++)
                  if (i == 2 && j == 2)
                    const Expanded(child: SizedBox.shrink())
                  else
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: NeumorphicButton(
                          style: NeumorphicStyle(
                            color: theme.primaryColor,
                            lightSource: LightSource.top,
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.all(5),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Icon(
                                  actionIcons[i][j],
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            if (i == 2 && j == 1) {
                              PersistentNavBarNavigator.pushNewScreen<Widget>(
                                context,
                                screen: const AdminScreen(),
                                withNavBar: false,
                                customPageRoute: MaterialPageRoute<Widget>(
                                  builder: (BuildContext context) =>
                                      const AdminScreen(),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
              ],
            )
        ],
      ),
    );
  }
}
