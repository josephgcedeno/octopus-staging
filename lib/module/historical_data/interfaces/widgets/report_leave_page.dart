import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/models/leaves/leaves_response.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:octopus/internal/string_helper.dart';
import 'package:octopus/internal/string_status.dart';

class ReportLeavePage extends StatelessWidget {
  const ReportLeavePage({
    required this.userLeaveRequests,
    required this.leaveType,
    Key? key,
  }) : super(key: key);
  final List<UserLeaveRequest> userLeaveRequests;
  final String leaveType;

  List<String> get leaveStatus => <String>[pending, approved, denied];

  List<LeaveRequest> getAllListRequest(
    String status,
    List<LeaveRequest> leaveRequests,
  ) =>
      leaveRequests
          .where(
            (LeaveRequest object) => object.status == status,
          )
          .toList();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    Widget resultsColumn(List<LeaveRequest> data) {
      late final Widget results;

      if (data.isNotEmpty) {
        results = Column(
          children: <Widget>[
            for (final LeaveRequest request in data)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(
                        request.reason,
                      ),
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          startDateToEndDateLabel(
                            from: dateTimeFromEpoch(
                              epoch: request.dateFromEpoch,
                            ),
                            to: dateTimeFromEpoch(
                              epoch: request.dateToEpoch,
                            ),
                          ),
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ],
        );
      } else {
        results = const Padding(
          padding: EdgeInsets.only(
            top: 8.0,
            left: 8.0,
          ),
          child: Text('No record found.'),
        );
      }
      return results;
    }

    return Container(
      color: kLightGrey.withOpacity(0.2),
      padding: const EdgeInsets.only(
        top: 24,
        right: 10,
      ),
      child: PageView.builder(
        itemCount: userLeaveRequests.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          final UserLeaveRequest leaveRequest = userLeaveRequests[index];
          return Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 15),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          leaveRequest.userName,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          leaveRequest.position,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (leaveType == leaveTypeVacationLeave)
                            for (String status in leaveStatus)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      status.toCapitalized(),
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8.0,
                                        left: 8.0,
                                      ),
                                      child: resultsColumn(
                                        getAllListRequest(
                                          status,
                                          leaveRequest.leaveRequest,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                          else
                            resultsColumn(leaveRequest.leaveRequest)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
