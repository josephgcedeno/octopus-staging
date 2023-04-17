import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/module/leaves/service/cubit/leaves_cubit.dart';

class NumberOfLeaves extends StatefulWidget {
  const NumberOfLeaves({
    Key? key,
  }) : super(key: key);

  @override
  State<NumberOfLeaves> createState() => _NumberOfLeavesState();
}

class _NumberOfLeavesState extends State<NumberOfLeaves> {
  //number of leaves fetched
  int consumedLeave = 0;
  //leaves per fiscal year
  int remainingLeave = 0;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        for (int i = 0; i < 2; i++)
          Column(
            children: <Widget>[
              BlocBuilder<LeavesCubit, LeavesState>(
                builder: (BuildContext context, LeavesState state) {
                  if (state is FetchAllLeavesDataSuccess) {
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: theme.primaryColor.withAlpha(30),
                            blurRadius: 30,
                          )
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Center(
                          child: Text(
                            i == 0
                                ? state.leaveCount!.consumedLeave.toString()
                                : state.leaveCount!.remainingLeave.toString(),
                            style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return leaveLoader(context);
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(
                  child: BlocBuilder<LeavesCubit, LeavesState>(
                    builder: (BuildContext context, LeavesState state) {
                      if (state is FetchAllLeavesDataSuccess) {
                        return Text(
                          i == 0 ? 'Consumed' : 'Left',
                          style: kIsWeb
                              ? theme.textTheme.titleLarge?.copyWith(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                )
                              : theme.textTheme.titleMedium?.copyWith(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                        );
                      } else {
                        return lineLoader(
                          height: height * 0.03,
                          width: width * 0.3,
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
      ],
    );
  }
}
