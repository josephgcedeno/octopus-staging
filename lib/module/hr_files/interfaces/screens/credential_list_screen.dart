import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/module/hr_files/interfaces/widgets/credentials_card.dart';

class CredentialListScreen extends StatelessWidget {
  const CredentialListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const GlobalAppBar(leading: LeadingButton.back),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          width: width,
          child: Container(
            width: width,
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.055,
              vertical: height * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(Icons.note_alt_outlined),
                    Padding(
                      padding: EdgeInsets.only(left: width * 0.03),
                      child: Text(
                        'Credentials List',
                        textAlign: TextAlign.left,
                        style: kIsWeb
                            ? theme.textTheme.titleLarge
                            : theme.textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const CredentialsCard(
                  appTitle: 'Udemy',
                  email: 'emailaddress@tech',
                  password: 'password123',
                ),
                const CredentialsCard(
                  appTitle: 'Figma',
                  email: 'emailaddress@tech',
                  password: 'password123',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
