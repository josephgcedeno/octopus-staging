import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/internal/debug_utils.dart';
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
    return BlocListener<LeavesCubit, LeavesState>(
      listenWhen: (LeavesState previous, LeavesState current) =>
          current is FetchAllLeavesDataLoading ||
          current is FetchAllLeavesDataSuccess ||
          current is FetchAllLeavesDataSuccess,
      listener: (BuildContext context, LeavesState state) {
        if (state is FetchAllLeavesDataLoading) {
          consumedLeave = 0;
          remainingLeave = 0;
        } else if (state is FetchAllLeavesDataSuccess) {
          consumedLeave = state.leaveCount!.consumedLeave;
          remainingLeave = state.leaveCount!.remainingLeave;
        } else if (state is FetchAllLeavesDataFailed) {
          showSnackBar(
            message: state.message,
            snackBartState: SnackBartState.error,
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          for (int i = 0; i < 2; i++)
            Column(
              children: <Widget>[
                BlocBuilder<LeavesCubit, LeavesState>(
                  builder: (BuildContext context, LeavesState state) {
                    if (state is FetchAllLeavesDataLoading) {
                      return leaveLoader(context);
                    } else {
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
                                  ? consumedLeave.toString()
                                  : remainingLeave.toString(),
                              style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: BlocBuilder<LeavesCubit, LeavesState>(
                      builder: (BuildContext context, LeavesState state) {
                        if (state is FetchAllLeavesDataLoading) {
                          return lineLoader(
                            height: height * 0.03,
                            width: width * 0.3,
                          );
                        } else {
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
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }
}
