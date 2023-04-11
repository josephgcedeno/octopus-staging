import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum LeaveStatus {
  approved,
  pending,
  denied,
}

class LeaveStatusDetails {
  LeaveStatusDetails({
    required this.id,
    required this.statusName,
    required this.status,
    required this.color,
  });

  final String id;
  final String statusName;
  final LeaveStatus status;
  final Color color;
}

class LeaveStatusIndicator extends StatefulWidget {
  const LeaveStatusIndicator({
    required this.status,
    Key? key,
  }) : super(key: key);
  final LeaveStatus status;
  @override
  State<LeaveStatusIndicator> createState() => _LeaveStatusIndicatorState();
}

class _LeaveStatusIndicatorState extends State<LeaveStatusIndicator> {
  Map<LeaveStatus, LeaveStatusDetails> currentStatus =
      <LeaveStatus, LeaveStatusDetails>{
    LeaveStatus.approved: LeaveStatusDetails(
      id: '0',
      statusName: 'APPROVED',
      status: LeaveStatus.approved,
      color: const Color(0XFF39C0C7),
    ),
    LeaveStatus.denied: LeaveStatusDetails(
      id: '1',
      statusName: 'DENIED',
      status: LeaveStatus.denied,
      color: const Color(0xeee25252),
    ),
    LeaveStatus.pending: LeaveStatusDetails(
      id: '2',
      statusName: 'PENDING',
      status: LeaveStatus.pending,
      color: const Color(0XEEEC8D71),
    )
  };

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: currentStatus[widget.status]!.color),
        borderRadius: BorderRadius.circular(15),
        color: currentStatus[widget.status]!.color.withOpacity(0.1),
      ),
      width: kIsWeb ? width * 0.3 : width * 0.9,
      height: kIsWeb ? height * 0.15 : height * 0.12,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Your leave request has been',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: kIsWeb ? 15 : width * 0.04,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            currentStatus[widget.status]!.statusName,
            style: kIsWeb
                ? theme.textTheme.headlineMedium?.copyWith(
                    color: currentStatus[widget.status]!.color,
                    fontSize: 20,
                  )
                : theme.textTheme.headlineMedium?.copyWith(
                    color: currentStatus[widget.status]!.color,
                    fontSize: width * 0.06,
                  ),
          ),
        ],
      ),
    );
  }
}
