import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/module/leaves/interfaces/screens/leaves_details_screen.dart';
import 'package:octopus/module/leaves/interfaces/widgets/leave_duaration.dart';
import 'package:octopus/module/leaves/interfaces/widgets/number_of_leaves.dart';

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

  Color formBackgroundColor = const Color(0xFFf5f7f9);
  final Color blackColor = const Color(0xff1B252F).withOpacity(70 / 100);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const GlobalAppBar(leading: LeadingButton.back),
      body: Container(
        height: height * 0.87,
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: height * 0.03, top: 20),
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
                    padding: EdgeInsets.only(bottom: height * 0.03, top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const <Widget>[
                        NumberOfLeaves(
                          type: 'Consumed',
                          count: 2,
                        ),
                        NumberOfLeaves(
                          type: 'Left',
                          count: 8,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: height * 0.01, top: 20),
                    child: const Text("I'll be taking a leave..."),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: height * 0.01,
                      bottom: height * 0.02,
                    ),
                    child: const LeaveDuration(),
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
                        child: DropdownButton<Placeholder>(
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down_outlined),
                          hint: const Text('Select Type of Leave'),
                          elevation: 2,
                          borderRadius: BorderRadius.circular(10),
                          underline: const SizedBox.shrink(),
                          dropdownColor: Colors.white,
                          onChanged: null,
                          items: null,
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
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<dynamic>(
                            builder: (_) => const LeavesDetailsScreen(),
                          ),
                        );
                      },
                      child: const Text('Request'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
