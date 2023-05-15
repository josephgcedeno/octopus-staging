import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/models/leaves/leaves_response.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/module/leaves/interfaces/widgets/leave_slidable_button.dart';
import 'package:octopus/module/leaves/service/cubit/leaves_cubit.dart';

class LeaveStatusGenerator extends StatefulWidget {
  const LeaveStatusGenerator({Key? key}) : super(key: key);

  @override
  State<LeaveStatusGenerator> createState() => _LeaveStatusGeneratorState();
}

class _LeaveStatusGeneratorState extends State<LeaveStatusGenerator> {
  final List<LeaveRequest> leaves = <LeaveRequest>[];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    context.read<LeavesCubit>().fetchAllLeaveRequest();
  }

  void removeLeaves(
    String requestId,
    String message,
  ) {
    setState(() {
      leaves.removeWhere(
        (LeaveRequest item) => item.id == requestId,
      );
    });

    showSnackBar(
      message: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return BlocListener<LeavesCubit, LeavesState>(
      listenWhen: (LeavesState previous, LeavesState current) =>
          current is DeclineLeaveRequestLoading ||
          current is DeclineLeaveRequestSuccess ||
          current is DeclineLeaveRequestFailed ||
          current is FetchAllLeaveRequestLoading ||
          current is FetchAllLeaveRequestSuccess ||
          current is FetchAllLeaveRequestFailed ||
          current is ApprovedLeaveRequestLoading ||
          current is ApprovedLeaveRequestSuccess ||
          current is ApprovedLeaveRequestFailed,
      listener: (BuildContext context, LeavesState state) {
        if (state is FetchAllLeaveRequestLoading) {
          setState(() {
            isLoading = true;
          });
        }
        if (state is ApprovedLeaveRequestSuccess) {
          // Remove the item from the list
          removeLeaves(
            state.leaveRequest.id,
            '${state.leaveRequest.userName ?? ''} leave request has been approved. User will be notified by it.',
          );
        }
        if (state is FetchAllLeaveRequestSuccess) {
          setState(() {
            isLoading = false;
            leaves.addAll(state.leaves);
          });
        }

        if (state is DeclineLeaveRequestSuccess) {
          // Pop alert dialog once success.
          Navigator.of(context).pop();
          // Remove the item from the list
          removeLeaves(
            state.leaveRequest.id,
            '${state.leaveRequest.userName ?? ''} leave request has been declined. User will be notified by it.',
          );
        }
      },
      child: isLoading
          ? Column(
              children: <Widget>[
                for (int i = 0; i < 5; i++)
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: lineLoader(height: height * 0.065, width: width),
                    ),
                  )
              ],
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: leaves.length,
              itemBuilder: (BuildContext context, int index) {
                return LeaveSlideableButton(
                  leaveRequest: leaves[index],
                );
              },
            ),
    );
  }
}
