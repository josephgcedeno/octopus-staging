import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';

class ReportDTRPage extends StatelessWidget {
  const ReportDTRPage({required this.employeeAttendances, Key? key})
      : super(key: key);
  final List<EmployeeDailyTimeRecord> employeeAttendances;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.only(
        top: 24,
        right: 10,
      ),
      decoration: BoxDecoration(
        color: kLightGrey.withOpacity(0.2),
        border: kIsWeb && width > smWebMinWidth
            ? Border(
                bottom: BorderSide(
                  color: kLightBlack
                      .withOpacity(0.10), // Replace with your desired color
                  width: 2.0, // Replace with your desired width
                ),
              )
            : null,
      ),
      child: PageView.builder(
        itemCount: employeeAttendances.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          final EmployeeDailyTimeRecord employeeDailyTimeRecordDTO =
              employeeAttendances[index];

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
                          '${employeeDailyTimeRecordDTO.firstName} ${employeeDailyTimeRecordDTO.lastName}',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          employeeDailyTimeRecordDTO.position,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Table(
                        // Remove table borders
                        border: TableBorder.all(color: Colors.transparent),
                        children: <TableRow>[
                          // Table Header
                          TableRow(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: kLightBlack.withOpacity(0.1),
                                ),
                              ),
                            ),
                            children: <TableCell>[
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Date',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'In - Out',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Overtime',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // TableRow Body
                          if (employeeDailyTimeRecordDTO.attendances.isNotEmpty)
                            for (final DTRAttendance attendanceRecord
                                in employeeDailyTimeRecordDTO.attendances)
                              TableRow(
                                children: <TableCell>[
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        attendanceRecord.date,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        attendanceRecord.timeInOut,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        attendanceRecord.overTime,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          else
                            TableRow(
                              children: <TableCell>[
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SizedBox.shrink(),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'No result available',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(color: Colors.black),
                                    ),
                                  ),
                                ),
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SizedBox.shrink(),
                                  ),
                                ),
                              ],
                            )
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
