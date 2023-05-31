import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';
import 'package:octopus/infrastructures/service/cubit/user_cubit.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/screens/accomplishments_generator_screen.dart';
import 'package:octopus/module/add_new_project/interfaces/screens/add_new_project_screen.dart';
import 'package:octopus/module/admin_registration/interfaces/screens/team_members_list_screen.dart';
import 'package:octopus/module/dashboard/interfaces/widgets/dashboard_button.dart';
import 'package:octopus/module/historical_data/interfaces/screens/historical_data_screen.dart';
import 'package:octopus/module/hr_files/interfaces/screens/hr_files_screen.dart';
import 'package:octopus/module/leaves/interfaces/screens/leaves_admin_screen.dart';
import 'package:octopus/module/leaves/interfaces/screens/leaves_screen.dart';
import 'package:octopus/module/standup_report/interfaces/screens/standup_report_screen.dart';
import 'package:octopus/module/time_record/interfaces/screens/time_record_screen.dart';

class ToolsAvailable extends StatefulWidget {
  const ToolsAvailable({Key? key}) : super(key: key);

  @override
  State<ToolsAvailable> createState() => _ToolsAvailableState();
}

class _ToolsAvailableState extends State<ToolsAvailable> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().fetchUserRole();
  }

  @override
  Widget build(BuildContext context) {
    final double width = kIsWeb ? 560 : MediaQuery.of(context).size.width;
    final double height = kIsWeb ? 560 : MediaQuery.of(context).size.height;

    return BlocBuilder<UserCubit, UserState>(
      buildWhen: (UserState previous, UserState current) =>
          current is FetchCurrentUserSuccess ||
          current is FetchCurrentUserLoading,
      builder: (BuildContext context, UserState state) {
        if (state is FetchCurrentUserSuccess) {
          return Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: height * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DashboardButton(
                      icon: Icons.timer_outlined,
                      label: 'Daily Time Record',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<dynamic>(
                            builder: (_) => const TimeRecordScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: width * 0.03),
                    DashboardButton(
                      icon: Icons.collections_bookmark_outlined,
                      label: 'Daily Stand-Up Report',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<dynamic>(
                            builder: (_) => const StandupReportScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: height * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DashboardButton(
                      icon: Icons.calendar_today_outlined,
                      label: 'Leaves',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<dynamic>(
                            builder: (_) => const LeavesScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: width * 0.03),
                    DashboardButton(
                      icon: Icons.collections_bookmark_outlined,
                      label: 'HR Files',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<dynamic>(
                            builder: (_) => const HRFilesScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              if (state.userRole.userRole == UserRole.admin)
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: height * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          DashboardButton(
                            icon: Icons.calendar_today_outlined,
                            label: 'Accompl. Generator',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<dynamic>(
                                  builder: (_) =>
                                      const AccomplishmentsGeneratorScreen(),
                                ),
                              );
                            },
                          ),
                          SizedBox(width: width * 0.03),
                          DashboardButton(
                            icon: Icons.folder_open_outlined,
                            label: 'Request Leaves',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<dynamic>(
                                  builder: (_) => const LeavesAdminScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: height * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          DashboardButton(
                            icon: Icons.calendar_today_outlined,
                            label: 'Registration',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<dynamic>(
                                  builder: (_) => const TeamMembersScreen(),
                                ),
                              );
                            },
                          ),
                          SizedBox(width: width * 0.03),
                          DashboardButton(
                            icon: Icons.collections_bookmark_outlined,
                            label: 'Historical Data',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<dynamic>(
                                  builder: (_) => const HistoricalDataScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: height * 0.02),
                      child: Row(
                        children: <Widget>[
                          DashboardButton(
                            icon: Icons.post_add_rounded,
                            label: 'Add New Project',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<dynamic>(
                                  builder: (_) => const AddNewProjectScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          );
        }
        return Column(
          children: <Widget>[
            for (int i = 0; i < 2; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    lineLoader(height: height * 0.1, width: width * 0.43),
                    SizedBox(width: width * 0.03),
                    lineLoader(height: height * 0.1, width: width * 0.43),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
