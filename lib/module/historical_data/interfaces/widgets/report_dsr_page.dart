import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/models/dsr/dsr_response.dart';
import 'package:octopus/internal/string_helper.dart';
import 'package:octopus/module/standup_report/interfaces/widgets/project_chip.dart';

class ReportDSRPage extends StatelessWidget {
  const ReportDSRPage({required this.userDsr, Key? key}) : super(key: key);
  final List<UserDSR> userDsr;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      color: kLightGrey.withOpacity(0.2),
      padding: const EdgeInsets.only(
        top: 24,
        right: 10,
      ),
      child: PageView.builder(
        itemCount: userDsr.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          final UserDSR userDSR = userDsr[index];

          final Map<String, List<DSRWorks>> dsrs = <String, List<DSRWorks>>{
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  entry.key.toCapitalized(),
                                  style: theme.textTheme.bodySmall?.copyWith(
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
                                            padding: const EdgeInsets.only(
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
                                                  name:
                                                      userDSRRecord.projectName,
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
}
