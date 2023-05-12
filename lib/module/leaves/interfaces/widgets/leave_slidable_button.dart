import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:octopus/infrastructures/models/leaves/leaves_response.dart';
import 'package:octopus/internal/helper_function.dart';
import 'package:octopus/internal/string_helper.dart';
import 'package:octopus/internal/string_status.dart';

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

    return Slidable(
      endActionPane: ActionPane(
        extentRatio: kIsWeb ? 0.09 : 0.37,
        motion: const ScrollMotion(),
        children: <Widget>[
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
            height: 50,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: const Color(0x4739C0C7),
              borderRadius: BorderRadius.circular(5),
            ),
            child: FittedBox(
              child: IconButton(
                color: const Color(0xff39C0C7),
                onPressed: () {},
                icon: const Icon(Icons.check),
              ),
            ),
          ),
          Container(
            width: 30,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0x43E25252),
              borderRadius: BorderRadius.circular(5),
            ),
            child: FittedBox(
              child: IconButton(
                color: const Color(0xffE25252),
                onPressed: () {},
                icon: const Icon(Icons.close),
              ),
            ),
          ),
        ],
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
