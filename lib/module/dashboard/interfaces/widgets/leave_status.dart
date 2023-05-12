import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:octopus/infrastructures/models/leaves/leaves_response.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:octopus/internal/string_helper.dart';
import 'package:octopus/module/leaves/service/cubit/leaves_cubit.dart';

class PanelLeavesStatus extends StatefulWidget {
  const PanelLeavesStatus({Key? key}) : super(key: key);

  @override
  State<PanelLeavesStatus> createState() => _PanelLeavesStatusState();
}

class _PanelLeavesStatusState extends State<PanelLeavesStatus> {
  Widget listView({
    required ThemeData theme,
    required String status,
    required String startAndEndDate,
    required String leaveType,
  }) {
    late Color statusColor;
    switch (status) {
      case 'APPROVED':
        statusColor = const Color(0XFF39C0C7);
        break;
      case 'PENDING':
        statusColor = const Color(0XFFEC8D71);
        break;
      case 'DECLINED':
        statusColor = const Color(0XFFE25252);
        break;
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7F9), // Set the background color
        borderRadius: BorderRadius.circular(10.0), // Set the border radius
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          Icons.circle,
          color: statusColor,
          size: 15,
        ),
        title: Transform.translate(
          offset: const Offset(-30, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  startAndEndDate,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: const Color(0xAF1B252F)),
                ),
              ),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    leaveType.split(' ')[0],
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: Text(
          status.toCapitalized(),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: statusColor,
          ),
        ),
        onTap: () {},
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    context.read<LeavesCubit>().fetchLeaveStatusToday();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return BlocConsumer<LeavesCubit, LeavesState>(
      buildWhen: (LeavesState previous, LeavesState current) =>
          current is FetchAllLeaveTodaySuccess,
      listenWhen: (LeavesState previous, LeavesState current) =>
          current is FetchAllLeaveTodayFailed,
      listener: (BuildContext context, LeavesState state) {
        if (state is FetchAllLeaveTodayFailed) {
          showSnackBar(
            message: state.message,
            snackBartState: SnackBartState.error,
          );
        }
      },
      builder: (BuildContext context, LeavesState state) {
        if (state is FetchAllLeaveTodaySuccess) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: height * 0.02),
                child: Text(
                  'Leave Status',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: state.leaveRequests.length,
                itemBuilder: (BuildContext context, int index) {
                  final LeaveRequest leaveRequest = state.leaveRequests[index];
                  final DateTime dateTimeFrom =
                      dateTimeFromEpoch(epoch: leaveRequest.dateFromEpoch);

                  final DateTime dateTimeTo =
                      dateTimeFromEpoch(epoch: leaveRequest.dateToEpoch);

                  final String startAndEndDate = '${DateFormat(
                    'MMM dd',
                  ).format(dateTimeFrom)} - ${DateFormat(
                    'MMM dd',
                  ).format(dateTimeTo)}';

                  return listView(
                    startAndEndDate: startAndEndDate,
                    status: leaveRequest.status,
                    leaveType: leaveRequest.leaveType,
                    theme: theme,
                  );
                },
              ),
            ],
          );
        }
        return Column(
          children: <Widget>[
            for (int i = 0; i < 2; i++)
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: lineLoader(height: height * 0.055, width: width),
                ),
              )
          ],
        );
      },
    );
  }
}
