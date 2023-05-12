import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        return const SizedBox.shrink();
      },
    );
  }
}
