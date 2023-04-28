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
    return Scaffold(
      appBar: const GlobalAppBar(leading: LeadingButton.back),
      body: AdminRegistrationTemplate(
        templateVariation: TemplateVariation.teamMembers,
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
          children: const <Widget>[
            TeamMember(
              name: 'Employee 1',
              imageLink:
                  'https://cdn-icons-png.flaticon.com/512/201/201634.png',
              position: 'Software Developer 1',
            ),
            TeamMember(
              name: 'Employee 1',
              imageLink:
                  'https://cdn-icons-png.flaticon.com/512/201/201634.png',
              position: 'Software Developer 1',
            ),
          ],
        ),
      ),
    );
  }
}
