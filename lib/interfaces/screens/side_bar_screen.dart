import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';
import 'package:octopus/infrastructures/service/cubit/user_cubit.dart';
import 'package:octopus/interfaces/screens/members_profile_screen.dart';
import 'package:octopus/interfaces/screens/pdf_viewer_screen.dart';
import 'package:octopus/interfaces/widgets/side_bar_button.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/screens/accomplishments_generator_screen.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/screens/daily_accomplishment_report_screen.dart';
import 'package:octopus/module/add_new_project/interfaces/screens/add_new_project_screen.dart';
import 'package:octopus/module/admin_registration/interfaces/screens/ids_form_screen.dart';
import 'package:octopus/module/admin_registration/interfaces/screens/personal_information_form_screen.dart';
import 'package:octopus/module/admin_registration/interfaces/screens/team_members_list_screen.dart';
import 'package:octopus/module/historical_data/interfaces/screens/daily_time_record_screen.dart';
import 'package:octopus/module/historical_data/interfaces/screens/dsr_screen.dart';
import 'package:octopus/module/historical_data/interfaces/screens/historical_data_screen.dart';
import 'package:octopus/module/historical_data/interfaces/screens/leave_request_screen.dart';
import 'package:octopus/module/historical_data/interfaces/screens/report_screen_generator.dart';
import 'package:octopus/module/hr_files/interfaces/screens/credential_list_screen.dart';
import 'package:octopus/module/hr_files/interfaces/screens/hr_files_screen.dart';
import 'package:octopus/module/hr_files/interfaces/screens/pdf_viewer_screen.dart'
    as pdf_viewer_hr_file;
import 'package:octopus/module/leaves/interfaces/screens/leaves_admin_screen.dart';
import 'package:octopus/module/leaves/interfaces/screens/leaves_details_screen.dart';
import 'package:octopus/module/leaves/interfaces/screens/leaves_screen.dart';
import 'package:octopus/module/standup_report/interfaces/screens/edit_task_screen.dart';
import 'package:octopus/module/standup_report/interfaces/screens/standup_report_screen.dart';
import 'package:octopus/module/time_record/interfaces/screens/request_offset_screen.dart';
import 'package:octopus/module/time_record/interfaces/screens/time_record_screen.dart';

class SidebarScreen extends StatelessWidget {
  const SidebarScreen({
    required this.child,
    Key? key,
  }) : super(key: key);
  final Widget child;

  void pushReplaceScreen(
    BuildContext context,
    Widget screen,
  ) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<dynamic>(
        pageBuilder: (
          BuildContext context,
          Animation<double> animation1,
          Animation<double> animation2,
        ) =>
            SidebarScreen(
          child: screen,
        ),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final UserRole? userrole = context.read<UserCubit>().state.currentUserRole;

    return Scaffold(
      body: Row(
        children: <Widget>[
          if (kIsWeb && width > smWebMinWidth)
            Container(
              width: width * 0.2, // 20% of the screen width
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 4,
                    blurRadius: 4,
                    offset: const Offset(
                      -5,
                      0,
                    ),
                  ),
                ],
              ),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SvgPicture.asset(logoSvgWithText),
                  ),
                  SidebarButton(
                    icon: Icons.timer_outlined,
                    isActive: child.runtimeType == TimeRecordScreen ||
                        child.runtimeType == RequestOffsetScreen,
                    onTap: child.runtimeType == TimeRecordScreen ||
                            child.runtimeType == RequestOffsetScreen
                        ? null
                        : () => pushReplaceScreen(
                              context,
                              const TimeRecordScreen(),
                            ),
                    title: 'Daily Time Record',
                  ),
                  SidebarButton(
                    icon: Icons.collections_bookmark_outlined,
                    isActive: child.runtimeType == StandupReportScreen ||
                        child.runtimeType == EditTaskScreen,
                    onTap: child.runtimeType == StandupReportScreen ||
                            child.runtimeType == EditTaskScreen
                        ? null
                        : () => pushReplaceScreen(
                              context,
                              const StandupReportScreen(),
                            ),
                    title: 'Daily Stand-Up Report',
                  ),
                  SidebarButton(
                    icon: Icons.calendar_today_outlined,
                    isActive: child.runtimeType == LeavesScreen ||
                        child.runtimeType == LeavesDetailsScreen,
                    onTap: child.runtimeType == LeavesScreen ||
                            child.runtimeType == LeavesDetailsScreen
                        ? null
                        : () => pushReplaceScreen(
                              context,
                              const LeavesScreen(),
                            ),
                    title: 'Leaves',
                  ),
                  SidebarButton(
                    icon: Icons.collections_bookmark_outlined,
                    isActive: child.runtimeType == HRFilesScreen ||
                        child.runtimeType == CredentialListScreen ||
                        child.runtimeType == pdf_viewer_hr_file.PDFViewerScreen,
                    onTap: child.runtimeType == HRFilesScreen ||
                            child.runtimeType == CredentialListScreen ||
                            child.runtimeType ==
                                pdf_viewer_hr_file.PDFViewerScreen
                        ? null
                        : () => pushReplaceScreen(
                              context,
                              const HRFilesScreen(),
                            ),
                    title: 'HR Files',
                  ),
                  if (userrole == UserRole.admin) ...<SidebarButton>[
                    SidebarButton(
                      icon: Icons.calendar_today_outlined,
                      isActive:
                          child.runtimeType == AccomplishmentsGeneratorScreen ||
                              child.runtimeType ==
                                  DailyAccomplishmentReportScreen ||
                              (child.runtimeType == PDFViewerScreen &&
                                  (child as PDFViewerScreen).title ==
                                      'Accomplishment Generator'),
                      onTap:
                          child.runtimeType == AccomplishmentsGeneratorScreen ||
                                  child.runtimeType ==
                                      DailyAccomplishmentReportScreen ||
                                  (child.runtimeType == PDFViewerScreen &&
                                      (child as PDFViewerScreen).title ==
                                          'Accomplishment Generator')
                              ? null
                              : () => pushReplaceScreen(
                                    context,
                                    const AccomplishmentsGeneratorScreen(),
                                  ),
                      title: 'Accompl. Generator',
                    ),
                    SidebarButton(
                      icon: Icons.folder_open_outlined,
                      isActive: child.runtimeType == LeavesAdminScreen,
                      onTap: child.runtimeType == LeavesAdminScreen
                          ? null
                          : () => pushReplaceScreen(
                                context,
                                const LeavesAdminScreen(),
                              ),
                      title: 'Request Leaves',
                    ),
                    SidebarButton(
                      icon: Icons.calendar_today_outlined,
                      isActive: child.runtimeType == TeamMembersScreen ||
                          (child.runtimeType == MembersProfileScreen &&
                              (child as MembersProfileScreen).userView ==
                                  UserView.admin) ||
                          child.runtimeType == PersonalInformationFormScreen ||
                          child.runtimeType == IdsFormScreen,
                      onTap: child.runtimeType == TeamMembersScreen ||
                              (child.runtimeType == MembersProfileScreen &&
                                  (child as MembersProfileScreen).userView ==
                                      UserView.admin) ||
                              child.runtimeType ==
                                  PersonalInformationFormScreen ||
                              child.runtimeType == IdsFormScreen
                          ? null
                          : () => pushReplaceScreen(
                                context,
                                const TeamMembersScreen(),
                              ),
                      title: 'Registration',
                    ),
                    SidebarButton(
                      icon: Icons.collections_bookmark_outlined,
                      isActive: child.runtimeType == HistoricalDataScreen ||
                          child.runtimeType == DailyTimeRecordScreen ||
                          child.runtimeType == DailyStandUpReportScreen ||
                          child.runtimeType == LeaveRequestScreen ||
                          child.runtimeType == ReportScreenGenerator ||
                          (child.runtimeType == PDFViewerScreen &&
                              (child as PDFViewerScreen).title ==
                                  'Historical Data'),
                      onTap: child.runtimeType == HistoricalDataScreen ||
                              child.runtimeType == DailyTimeRecordScreen ||
                              child.runtimeType == DailyStandUpReportScreen ||
                              child.runtimeType == LeaveRequestScreen ||
                              child.runtimeType == ReportScreenGenerator ||
                              (child.runtimeType == PDFViewerScreen &&
                                  (child as PDFViewerScreen).title ==
                                      'Historical Data')
                          ? null
                          : () => pushReplaceScreen(
                                context,
                                const HistoricalDataScreen(),
                              ),
                      title: 'Historical Data',
                    ),
                    SidebarButton(
                      icon: Icons.post_add_rounded,
                      isActive: child.runtimeType == AddNewProjectScreen,
                      onTap: child.runtimeType == AddNewProjectScreen
                          ? null
                          : () => pushReplaceScreen(
                                context,
                                const AddNewProjectScreen(),
                              ),
                      title: 'Add New Project',
                    ),
                  ],
                ],
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
  // }
}
