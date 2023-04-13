import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/module/hr_files/interfaces/screens/credential_list_screen.dart';
import 'package:octopus/module/hr_files/interfaces/widgets/hr_menu_button.dart';

class HRFilesScreen extends StatelessWidget {
  const HRFilesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    void navigateToCredentialList() {
      Navigator.of(context).push(
        MaterialPageRoute<dynamic>(
          builder: (_) => const CredentialListScreen(),
        ),
      );
    }

    return Scaffold(
      appBar: const GlobalAppBar(leading: LeadingButton.back),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: height,
          width: width,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                child: Column(
                  children: <Widget>[
                    Text(
                      'HR Files',
                      style: kIsWeb
                          ? theme.textTheme.titleLarge
                          : theme.textTheme.titleMedium,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: width * 0.04,
                        right: width * 0.04,
                      ),
                      height: height,
                      width: width,
                      child: Column(
                        children: <Widget>[
                          const HrMenuButton(
                            icon: Icons.policy_outlined,
                            title: 'Company Policies',
                          ),
                          const HrMenuButton(
                            icon: Icons.task_outlined,
                            title: 'Company Guidelines',
                          ),
                          const HrMenuButton(
                            icon: Icons.corporate_fare_outlined,
                            title: 'Company Background',
                          ),
                          const HrMenuButton(
                            icon: Icons.legend_toggle_outlined,
                            title: 'Organization Chart',
                          ),
                          HrMenuButton(
                            icon: Icons.note_alt_outlined,
                            title: 'Credentials List',
                            isDropdown: false,
                            functionCall: navigateToCredentialList,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
