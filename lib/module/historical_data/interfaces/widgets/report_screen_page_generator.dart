import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_response.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/internal/string_helper.dart';
import 'package:octopus/module/historical_data/services/cubit/historical_cubit.dart';
import 'package:octopus/module/historical_data/services/cubit/historical_dto.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/project_chip.dart';

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
          current is FetchAttendancesReportSucces ||
          current is FetchDSRReportLoading ||
          current is FetchDSRReportSuccess,
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
        } else if (state is FetchDSRReportSuccess) {
          return Container(
            color: kLightGrey.withOpacity(0.2),
            padding: const EdgeInsets.only(
              top: 24,
              right: 10,
            ),
            child: PageView.builder(
              itemCount: state.userDsr.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                final UserDSR userDSR = state.userDsr[index];

                final Map<String, List<DSRWorks>> dsrs =
                    <String, List<DSRWorks>>{
                  'done': userDSR.done,
                  'doing': userDSR.doing,
                  'blockers': userDSR.blockers,
                };

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
                              userDSR.userName,
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              userDSR.position,
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              for (MapEntry<String, List<DSRWorks>> entry
                                  in dsrs.entries)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        entry.key.toCapitalized(),
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (dsrs[entry.key]!.isNotEmpty)
                                        for (final DSRWorks userDSRRecord
                                            in dsrs[entry.key]!)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8.0,
                                              left: 8.0,
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    bottom: 8.0,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(userDSRRecord.text),
                                                      ProjectChip(
                                                        color: Color(
                                                          int.parse(
                                                            userDSRRecord.color,
                                                          ),
                                                        ),
                                                        id: userDSRRecord.tagId,
                                                        name: userDSRRecord
                                                            .projectName,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                      else
                                        const Center(
                                          child: Text('No record found.'),
                                        )
                                    ],
                                  ),
                                ),
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
