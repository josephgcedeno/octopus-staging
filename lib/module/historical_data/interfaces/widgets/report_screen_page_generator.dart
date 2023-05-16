import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/module/historical_data/services/cubit/historical_cubit.dart';
import 'package:octopus/module/historical_data/services/cubit/historical_dto.dart';

class ReportScreenPageGenerator extends StatefulWidget {
  const ReportScreenPageGenerator({Key? key}) : super(key: key);

  @override
  State<ReportScreenPageGenerator> createState() =>
      _ReportScreenPageGeneratorState();
}

class _ReportScreenPageGeneratorState extends State<ReportScreenPageGenerator> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return BlocBuilder<HistoricalCubit, HistoricalState>(
      buildWhen: (HistoricalState previous, HistoricalState current) =>
          current is FetchAttendancesReportLoading ||
          current is FetchAttendancesReportSucces,
      builder: (BuildContext context, HistoricalState state) {
        if (state is FetchAttendancesReportSucces) {
          return Container(
            color: kLightGrey.withOpacity(0.2),
            padding: const EdgeInsets.only(
              top: 24,
              right: 10,
            ),
            child: PageView.builder(
              itemCount: state.employeeAttendances.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                final EmployeeDailyTimeRecordDTO employeeDailyTimeRecordDTO =
                    state.employeeAttendances[index];

                return Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
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
                              if (employeeDailyTimeRecordDTO
                                  .attendances.isNotEmpty)
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
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
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
                );
              },
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Center(
            child: Container(
              child: lineLoader(height: height * 0.75, width: width),
            ),
          ),
        );
      },
    );
  }
}
