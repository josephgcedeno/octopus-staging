import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/models/leaves/leaves_response.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/interfaces/widgets/date_and_time_picker.dart';
import 'package:octopus/interfaces/widgets/loading_indicator.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/module/leaves/interfaces/screens/leaves_details_screen.dart';
import 'package:octopus/module/leaves/interfaces/widgets/leave_details.dart';
import 'package:octopus/module/leaves/interfaces/widgets/number_of_leaves.dart';
import 'package:octopus/module/leaves/service/cubit/leaves_cubit.dart';

class LeavesScreen extends StatefulWidget {
  const LeavesScreen({Key? key}) : super(key: key);

  @override
  State<LeavesScreen> createState() => _LeavesScreenState();
}

class _LeavesScreenState extends State<LeavesScreen> {
  final OutlineInputBorder descriptionBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.circular(10),
  );
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> leaveTypes = <String>[
    'SICK LEAVE',
    'VACATION LEAVE',
    'EMERGENCY LEAVE'
  ];
  late DateTime fromDate;
  late DateTime toDate;
  late bool isLoading = false;
  String? leaveType;
  final TextEditingController reasonTextController = TextEditingController();

  Color formBackgroundColor = const Color(0xFFf5f7f9);
  final Color blackColor = const Color(0xff1B252F).withOpacity(70 / 100);

  void save() {
    context.read<LeavesCubit>().submitLeaveRequest(
          dateUsed: fromDate,
          reason: reasonTextController.text,
          leaveType: leaveType ?? 'SICK LEAVE',
          from: fromDate,
          to: toDate,
        );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<LeavesCubit>().fetchAllLeaves();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return BlocListener<LeavesCubit, LeavesState>(
      listenWhen: (LeavesState previous, LeavesState current) =>
          current is SubmitLeaveRequestLoading ||
          current is SubmitLeaveRequestSuccess ||
          current is SubmitLeavesRequestFailed,
      listener: (BuildContext context, LeavesState state) {
        if (state is SubmitLeaveRequestLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is SubmitLeaveRequestSuccess) {
          if (state.leaveRequest != null) {
            setState(() {
              isLoading = false;
              Navigator.of(context).push(
                MaterialPageRoute<dynamic>(
                  builder: (_) => LeavesDetailsScreen(
                    leaveRequest: state.leaveRequest,
                  ),
                ),
              );

              showSnackBar(message: 'Saved');
            });
          }
        } else if (state is SubmitLeavesRequestFailed) {
          setState(() {
            isLoading = false;
          });
          showSnackBar(
            message: state.message,
            snackBartState: SnackBartState.error,
          );
        }
      },
      child: Scaffold(
        appBar: const GlobalAppBar(leading: LeadingButton.back),
        body: Container(
          height: height * 0.87,
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.only(bottom: height * 0.03, top: 20),
                        child: Text(
                          'Request Leave Form',
                          style: kIsWeb
                              ? theme.textTheme.titleLarge
                              : theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Status of Leaves/Fiscal Year',
                          style: kIsWeb
                              ? theme.textTheme.titleLarge
                              : theme.textTheme.titleMedium,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(bottom: height * 0.03, top: 25),
                        child: const NumberOfLeaves(),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(bottom: height * 0.01, top: 20),
                        child: const Text("I'll be taking a leave..."),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: height * 0.01,
                          bottom: height * 0.02,
                        ),
                        child: DateTimePicker<DateTime>(
                          type: PickerType.date,
                          callBack: (DateTime from, DateTime to) {
                            fromDate = from;
                            toDate = to;
                          },
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 5.0,
                            ),
                            child: Text(
                              'Classification',
                              style: kIsWeb
                                  ? theme.textTheme.titleLarge
                                  : theme.textTheme.titleMedium?.copyWith(
                                      color: blackColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: height * 0.02),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: formBackgroundColor,
                            ),
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                              ),
                              isExpanded: true,
                              icon: const Icon(
                                  Icons.keyboard_arrow_down_outlined),
                              hint: const Text('Select Type of Leave'),
                              elevation: 2,
                              borderRadius: BorderRadius.circular(10),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Fields cannot be empty.';
                                }
                                return null;
                              },
                              dropdownColor: Colors.white,
                              onChanged: (String? value) {
                                setState(() {
                                  leaveType = value;
                                });
                              },
                              value: leaveType,
                              items: leaveTypes.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 5.0,
                            ),
                            child: Text(
                              'Reason',
                              style: kIsWeb
                                  ? theme.textTheme.titleLarge
                                  : theme.textTheme.titleMedium?.copyWith(
                                      color: blackColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                            ),
                          ),
                          TextFormField(
                            controller: reasonTextController,
                            maxLines: 8,
                            minLines: 8,
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
                              hintText:
                                  'Write reason (e.g. Process personal documents)',
                              hintStyle: theme.textTheme.bodySmall,
                              filled: true,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: width,
                        margin: EdgeInsets.only(
                          bottom: height * 0.02,
                          top: height * 0.02,
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    save();
                                  }
                                },
                          child: isLoading
                              ? const LoadingIndicator()
                              : const Text('Request'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
