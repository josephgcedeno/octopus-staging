import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:octopus/infrastructures/models/hr/hr_response.dart';
import 'package:octopus/interfaces/screens/side_bar_screen.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';
import 'package:octopus/module/hr_files/interfaces/screens/credential_list_screen.dart';
import 'package:octopus/module/hr_files/interfaces/widgets/hr_menu_button.dart';

class HRFilesScreen extends StatelessWidget {
  const HRFilesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;

    void navigateToCredentialList() {
      Navigator.of(context).push(
        PageRouteBuilder<dynamic>(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation1,
            Animation<double> animation2,
          ) =>
              const SidebarScreen(
            child: CredentialListScreen(),
          ),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }

    return Scaffold(
      appBar: const GlobalAppBar(leading: LeadingButton.back),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
          ),
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Align(
                  alignment: kIsWeb && width > smWebMinWidth
                      ? Alignment.centerLeft
                      : Alignment.center,
                  child: Text(
                    'HR Files',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  const HrMenuButton(
                    icon: Icons.policy_outlined,
                    title: 'Company Policies',
                    companyFileType: CompanyFileType.policies,
                  ),
                  const HrMenuButton(
                    icon: Icons.task_outlined,
                    title: 'Company Guidelines',
                    companyFileType: CompanyFileType.guidelines,
                  ),
                  const HrMenuButton(
                    icon: Icons.corporate_fare_outlined,
                    title: 'Company Background',
                    companyFileType: CompanyFileType.background,
                  ),
                  const HrMenuButton(
                    icon: Icons.legend_toggle_outlined,
                    title: 'Organization Chart',
                    companyFileType: CompanyFileType.organizationChart,
                  ),
                  HrMenuButton(
                    icon: Icons.note_alt_outlined,
                    title: 'Credentials List',
                    isDropdown: false,
                    functionCall: navigateToCredentialList,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
