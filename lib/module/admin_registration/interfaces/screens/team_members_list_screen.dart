import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/module/admin_registration/interfaces/screens/personal_information_form_screen.dart';
import 'package:octopus/module/admin_registration/interfaces/widgets/admin_registration_template.dart';
import 'package:octopus/module/admin_registration/interfaces/widgets/team_member.dart';

class TeamMembersScreen extends StatefulWidget {
  const TeamMembersScreen({Key? key}) : super(key: key);

  @override
  State<TeamMembersScreen> createState() => _TeamMembersScreenState();
}

class _TeamMembersScreenState extends State<TeamMembersScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const GlobalAppBar(leading: LeadingButton.back),
      body: AdminRegistrationTemplate(
        buttonName: 'Add Member',
        subtitle: 'Current Members',
        title: 'Team Members',
        buttonFunction: () {
          Navigator.of(context).push(
            MaterialPageRoute<dynamic>(
              builder: (_) => const PersonalInformationFormScreen(),
            ),
          );
        },
        body: Column(
          children: <Widget>[
            for (int i = 1; i < 15; i++)
              TeamMember(
                name: 'Employee $i',
                imageLink:
                    'https://cdn-icons-png.flaticon.com/512/201/201634.png',
                position: 'Software Developer $i',
              ),
          ],
        ),
      ),
    );
  }
}
