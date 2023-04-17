import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:octopus/infrastructures/models/leaves/leaves_response.dart';
import 'package:octopus/internal/helper_function.dart';

class LeaveDetails extends StatefulWidget {
  const LeaveDetails({
    required this.leaveRequest,
    Key? key,
  }) : super(key: key);
  final LeaveRequest leaveRequest;

  @override
  State<LeaveDetails> createState() => _LeaveDetailsState();
}

class _LeaveDetailsState extends State<LeaveDetails> {
  final TextEditingController reasonTextController = TextEditingController();
  final List<String> labels = <String>[
    'Date From:',
    'Date To:',
    'Classification:',
  ];

  late LeaveRequest leaveRequest;
  late DateTime fromDateEpoch =
      dateTimeFromEpoch(epoch: leaveRequest.dateFromEpoch);
  late DateTime toDateEpoch =
      dateTimeFromEpoch(epoch: leaveRequest.dateToEpoch);

  late String fromDate = DateFormat.yMMMMEEEEd('en-us').format(fromDateEpoch);
  late String toDate = DateFormat.yMMMMEEEEd('en-us').format(toDateEpoch);
  late List<String> values = <String>[
    fromDate,
    toDate,
    leaveRequest.leaveType,
  ];

  @override
  void initState() {
    super.initState();
    leaveRequest = widget.leaveRequest;
    reasonTextController.text = widget.leaveRequest.reason;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(top: height * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < 3; i++)
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    labels[i],
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.grey, fontSize: 15),
                  ),
                  Text(
                    values[i],
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 15),
                  ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.only(bottom: height * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Reason:',
                  style:
                      theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          TextFormField(
            controller: reasonTextController,
            maxLines: 8,
            minLines: 8,
            enabled: false,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Fields cannot be empty.';
              }
              return null;
            },
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              hintText: 'Write reason (e.g. Process personal documents)',
              hintStyle: theme.textTheme.bodySmall,
              filled: true,
            ),
          ),
        ],
      ),
    );
  }
}
