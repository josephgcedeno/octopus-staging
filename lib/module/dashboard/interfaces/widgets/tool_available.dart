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
  List<DashboardButton> dashboardButtons(
    BuildContext context,
    UserRole userRole,
  ) {
    return <DashboardButton>[
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
      if (userRole == UserRole.admin) ...<DashboardButton>[
        DashboardButton(
          icon: Icons.calendar_today_outlined,
          label: 'Accompl. Generator',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<dynamic>(
                builder: (_) => const AccomplishmentsGeneratorScreen(),
              ),
            );
          },
        ),
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
      ]
    ];
  }

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().fetchUserRole();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return BlocBuilder<UserCubit, UserState>(
      buildWhen: (UserState previous, UserState current) =>
          current is FetchCurrentUserSuccess ||
          current is FetchCurrentUserLoading,
      builder: (BuildContext context, UserState state) {
        if (state is FetchCurrentUserSuccess) {
          final List<DashboardButton> dashboardBtn = dashboardButtons(
            context,
            state.userRole.userRole,
          );
          return Column(
            children: <Widget>[
              /// Minus 1 since the last button should be displayed as 1
              for (int i = 0; i < dashboardBtn.length - 1; i = i + 2)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      dashboardBtn[i],
                      const SizedBox(width: 16),
                      dashboardBtn[i + 1]
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
          );
        }

        return Column(
          children: <Widget>[
            for (int i = 0; i < 2; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Expanded(
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          lineLoader(
                            height: height * 0.1,
                            width: constraints.maxWidth * 0.45,
                          ),
                          const SizedBox(width: 16),
                          lineLoader(
                            height: height * 0.1,
                            width: constraints.maxWidth * 0.45,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
