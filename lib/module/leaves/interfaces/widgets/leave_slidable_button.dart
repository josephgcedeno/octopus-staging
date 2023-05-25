import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:octopus/infrastructures/models/leaves/leaves_response.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';
import 'package:octopus/internal/string_helper.dart';
import 'package:octopus/internal/string_status.dart';
import 'package:octopus/module/leaves/service/cubit/leaves_cubit.dart';

class LeaveSlideableButton extends StatefulWidget {
  const LeaveSlideableButton({required this.leaveRequest, Key? key})
      : super(key: key);
  final LeaveRequest leaveRequest;

  @override
  State<LeaveSlideableButton> createState() => _LeaveSlideableButtonState();
}

class _LeaveSlideableButtonState extends State<LeaveSlideableButton> {
  late final String startAndEndDate;
  bool isExpanded = false;
  bool isApprovedBtnDisabled = false;
  String deniedReason = '';
  bool isBarrierDismissible = true;

  IconData getIconForLeaveType(String leaveType) {
    late final IconData icon;

    switch (leaveType) {
      case leaveTypeSickLeave:
        icon = Icons.sick_outlined;
        break;
      case leaveTypeVacationLeave:
        icon = Icons.card_travel_outlined;
        break;
      case leaveTypeEmergencyLeave:
        icon = Icons.my_location_outlined;
        break;
    }
    return icon;
  }

  void showDeclineAlertDialog(ThemeData theme) => showDialog<void>(
        barrierDismissible: isBarrierDismissible,
        context: context,
        builder: (BuildContext context) {
          bool isSubmitted = false;
          return StatefulBuilder(
            builder: (
              BuildContext context,
              void Function(void Function()) setState,
            ) {
              return AlertDialog(
                title: Text(
                  'Leave Request Denial',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: Colors.black),
                ),
                content: TextField(
                  maxLines: 5,
                  minLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Write reason for the denial..',
                    hintStyle: theme.textTheme.bodySmall,
                    filled: true,
                  ),
                  onChanged: (String value) {
                    deniedReason = value;
                  },
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: isSubmitted
                        ? null
                        : () {
                            isBarrierDismissible = true;
                            Navigator.of(context).pop();
                          },
                    child: Text(
                      'Cancel',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      backgroundColor: const Color(0xff017BFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      if (deniedReason.isEmpty) {
                        showSnackBar(
                          message: 'Deny reason should not be empty!',
                          snackBartState: SnackBartState.error,
                        );
                        return;
                      }

                      setState(() {
                        isSubmitted = true;
                      });
                      context.read<LeavesCubit>().declineLeaveRequest(
                            requestId: widget.leaveRequest.id,
                            username: widget.leaveRequest.userName ?? '',
                            declineReason: deniedReason,
                          );
                    },
                    child: isSubmitted
                        ? const SizedBox(
                            width: 25,
                            height: 25,
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Text(
                            'Confirm',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: Colors.white),
                          ),
                  ),
                ],
              );
            },
          );
        },
      );

  @override
  void initState() {
    super.initState();

    final DateTime dateTimeFrom =
        dateTimeFromEpoch(epoch: widget.leaveRequest.dateFromEpoch);

    final DateTime dateTimeTo =
        dateTimeFromEpoch(epoch: widget.leaveRequest.dateToEpoch);

    startAndEndDate = '${DateFormat(
      'MMM dd',
    ).format(dateTimeFrom)} - ${DateFormat(
      'MMM dd',
    ).format(dateTimeTo)}';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;

    List<Widget> actionButton() => <Widget>[
          if (!(kIsWeb && width > smWebMinWidth))
            Transform.rotate(
              angle: -math.pi / 2,
              child: IconButton(
                onPressed: () => setState(() {
                  isExpanded = !isExpanded;
                }),
                icon: Icon(
                  isExpanded ? Icons.close_fullscreen : Icons.open_in_full,
                ),
              ),
            ),
          Container(
            width: 30,
            height: kIsWeb && width > smWebMinWidth ? 40 : 50,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: isApprovedBtnDisabled
                  ? const Color(0x1639C0C7)
                  : const Color(0x4739C0C7),
              borderRadius: BorderRadius.circular(5),
            ),
            child: FittedBox(
              child: IconButton(
                color: const Color(0xff39C0C7),
                onPressed: isApprovedBtnDisabled
                    ? null
                    : () {
                        setState(() => isApprovedBtnDisabled = true);
                        context.read<LeavesCubit>().approvedLeaveRequest(
                              requestId: widget.leaveRequest.id,
                              username: widget.leaveRequest.userName ?? '',
                            );
                      },
                icon: const Icon(Icons.check),
              ),
            ),
          ),
          Container(
            width: 30,
            height: kIsWeb && width > smWebMinWidth ? 40 : 50,
            decoration: BoxDecoration(
              color: const Color(0x43E25252),
              borderRadius: BorderRadius.circular(5),
            ),
            child: FittedBox(
              child: IconButton(
                color: const Color(0xffE25252),
                onPressed: () {
                  // Make the isBarrierDismissible false, to prevent closing by not clicking cancel.
                  setState(() {
                    isBarrierDismissible = false;
                  });
                  showDeclineAlertDialog(theme);
                },
                icon: const Icon(Icons.close),
              ),
            ),
          )
        ];

    return kIsWeb && width > smWebMinWidth
        ? Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Row(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(right: 3.0),
                            child: Icon(
                              Icons.person_2_outlined,
                              size: 15,
                            ),
                          ),
                          Text(
                            widget.leaveRequest.userName ?? '',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 3.0),
                          child: Icon(
                            getIconForLeaveType(widget.leaveRequest.leaveType),
                            size: 15,
                          ),
                        ),
                        Text(
                          widget.leaveRequest.leaveType
                              .split(' ')[0]
                              .toCapitalized(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(right: 3.0),
                          child: Icon(
                            Icons.calendar_month,
                            size: 15,
                          ),
                        ),
                        Text(
                          startAndEndDate,
                          style: theme.textTheme.bodySmall,
                        )
                      ],
                    ),
                    Row(
                      children: actionButton(),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Reason:',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      widget.leaveRequest.reason,
                      style: theme.textTheme.bodyMedium,
                    )
                  ],
                )
              ],
            ),
          )
        : Slidable(
            endActionPane: ActionPane(
              extentRatio: kIsWeb && width > smWebMinWidth ? 0.09 : 0.37,
              motion: const ScrollMotion(),
              children: actionButton(),
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0x5C1B252F)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.only(right: 3.0),
                                child: Icon(
                                  Icons.person_2_outlined,
                                  size: 15,
                                ),
                              ),
                              Text(
                                widget.leaveRequest.userName ?? '',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 3.0),
                              child: Icon(
                                getIconForLeaveType(
                                  widget.leaveRequest.leaveType,
                                ),
                                size: 15,
                              ),
                            ),
                            Text(
                              widget.leaveRequest.leaveType
                                  .split(' ')[0]
                                  .toCapitalized(),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(right: 3.0),
                        child: Icon(
                          Icons.calendar_month,
                          size: 15,
                        ),
                      ),
                      Text(
                        startAndEndDate,
                        style: theme.textTheme.bodySmall,
                      )
                    ],
                  ),
                  if (isExpanded)
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Reason:',
                            style: theme.textTheme.bodySmall,
                          ),
                          Text(
                            widget.leaveRequest.reason,
                            style: theme.textTheme.bodyMedium,
                          )
                        ],
                      ),
                    )
                ],
              ),
            ),
          );
  }
}
