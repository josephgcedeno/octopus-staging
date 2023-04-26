import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/module/admin_registration/interfaces/widgets/admin_registration_template.dart';
import 'package:octopus/module/admin_registration/interfaces/widgets/team_member.dart';

class PersonalInformationFormScreen extends StatefulWidget {
  const PersonalInformationFormScreen({Key? key}) : super(key: key);

  @override
  State<PersonalInformationFormScreen> createState() =>
      _PersonalInformationFormScreenState();
}

class _PersonalInformationFormScreenState
    extends State<PersonalInformationFormScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const GlobalAppBar(leading: LeadingButton.back),
      body: AdminRegistrationTemplate(
          buttonName: 'Next',
          subtitle: 'Personal Information',
          title: 'Registration',
          buttonFunction: () {
            
          },
          body: Container()),
    );
  }
}
