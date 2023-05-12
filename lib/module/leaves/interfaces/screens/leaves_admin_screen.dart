import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/module/leaves/interfaces/widgets/leave_status_generator.dart';

class LeavesAdminScreen extends StatefulWidget {
  const LeavesAdminScreen({Key? key}) : super(key: key);

  @override
  State<LeavesAdminScreen> createState() => _LeavesAdminScreenState();
}

class _LeavesAdminScreenState extends State<LeavesAdminScreen> {
  List<User> activated = <User>[];
  List<User> deactivated = <User>[];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const GlobalAppBar(leading: LeadingButton.back),
      body: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: height * 0.03, top: 20),
                child: Center(
                  child: Text(
                    'Leaves',
                    style: kIsWeb
                        ? theme.textTheme.titleLarge
                        : theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                height: height * 0.75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Request',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: Colors.black),
                    ),
                    const Expanded(child: LeaveStatusGenerator()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
