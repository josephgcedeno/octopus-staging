import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/module/leaves/interfaces/widgets/leave_slidable_button.dart';
import 'package:octopus/module/leaves/service/cubit/leaves_cubit.dart';

class LeaveStatusGenerator extends StatefulWidget {
  const LeaveStatusGenerator({Key? key}) : super(key: key);

  @override
  State<LeaveStatusGenerator> createState() => _LeaveStatusGeneratorState();
}

class _LeaveStatusGeneratorState extends State<LeaveStatusGenerator> {
  @override
  void initState() {
    super.initState();
    context.read<LeavesCubit>().fetchAllLeaveRequest();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return BlocConsumer<LeavesCubit, LeavesState>(
      listener: (BuildContext context, LeavesState state) {},
      buildWhen: (LeavesState previous, LeavesState current) =>
          current is FetchAllLeaveRequestLoading ||
          current is FetchAllLeaveRequestSuccess,
      builder: (BuildContext context, LeavesState state) {
        if (state is FetchAllLeaveRequestSuccess) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.leaves.length,
            itemBuilder: (BuildContext context, int index) {
              return LeaveSlideableButton(
                leaveRequest: state.leaves[index],
              );
            },
          );
        }
        return Column(
          children: <Widget>[
            for (int i = 0; i < 5; i++)
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: lineLoader(height: height * 0.065, width: width),
                ),
              )
          ],
        );
      },
    );
  }
}
