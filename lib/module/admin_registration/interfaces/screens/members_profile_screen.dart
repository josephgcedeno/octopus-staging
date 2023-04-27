import 'package:flutter/material.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/module/admin_registration/interfaces/widgets/member_information_component.dart';

class MembersProfileScreen extends StatelessWidget {
  const MembersProfileScreen({Key? key}) : super(key: key);

  void showAlertDialogOnDeactivateAccount(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: const Color(0xffA8A8A8).withOpacity(0.40),
      builder: (BuildContext context) {
        final ThemeData theme = Theme.of(context);

        return AlertDialog(
          alignment: const Alignment(0.0, -0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Deactivate Account',
            style: theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          contentPadding: const EdgeInsets.only(left: 25, top: 10),
          content: Text(
            'Are you sure you want to deactivate this account?',
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xff1B252F),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: const Color(0xff1B252F)),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Confirm',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const GlobalAppBar(leading: LeadingButton.back),
      body: Stack(
        children: <Widget>[
          Container(
            height: height * 0.87,
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  minRadius: width * 0.18,
                  maxRadius: width * 0.18,
                  backgroundImage: const NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/201/201634.png',
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Text(
                  'Employee One',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                const Text('Software Developer I'),
                SizedBox(
                  height: height * 0.01,
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                const InformationComponent(type: 'ID', value: 'NXFY-0000'),
                const InformationComponent(type: 'Name', value: 'Employee One'),
                const InformationComponent(
                    type: 'Birthdate', value: '07/30/1997'),
                const InformationComponent(
                  type: 'Address',
                  value: 'Lorem Ipsum St. Davao City',
                ),
                const InformationComponent(type: 'TIN No.', value: '00000000'),
                const InformationComponent(type: 'SSS No.', value: '00000000'),
                const InformationComponent(
                    type: 'PAG-IBIG No.', value: '00000000'),
                const InformationComponent(
                  type: 'Philhealth No.',
                  value: '00000000',
                ),
                const InformationComponent(
                    type: 'Date Hired', value: '07/30/1921'),
              ],
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
              width: width,
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              margin: EdgeInsets.only(
                bottom: height * 0.02,
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    const Color(0xFFE25252).withOpacity(0.2),
                  ),
                  foregroundColor: MaterialStateProperty.all(
                    const Color(0xFFE25252),
                  ),
                  elevation: MaterialStateProperty.all(0),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                onPressed: () {
                  showAlertDialogOnDeactivateAccount(context);
                },
                child: const Text(
                  'Deactivate Account',
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
