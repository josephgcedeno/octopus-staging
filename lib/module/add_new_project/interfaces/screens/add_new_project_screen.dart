import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/interfaces/widgets/loading_indicator.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';
import 'package:octopus/module/add_new_project/service/cubit/add_new_project_cubit.dart';
import 'package:octopus/module/admin_registration/interfaces/widgets/full_width_reg_textfield.dart';

class AddNewProjectScreen extends StatefulWidget {
  const AddNewProjectScreen({Key? key}) : super(key: key);

  @override
  State<AddNewProjectScreen> createState() => _AddNewProjectScreenState();
}

class _AddNewProjectScreenState extends State<AddNewProjectScreen> {
  final TextEditingController projectNameController = TextEditingController();
  Color selectedColor = Colors.purple;

  void openColorPickerDialog() {
    showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          actionsPadding: EdgeInsets.zero,
          title: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close),
                ),
              ),
              const Text("Set the project's primary color"),
            ],
          ),
          titleTextStyle: const TextStyle(fontWeight: FontWeight.w600),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ColorPicker(
                hexInputBar: true,
                pickerColor: selectedColor,
                onColorChanged: (Color newColor) =>
                    setState(() => selectedColor = newColor),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return BlocListener<AddNewProjectCubit, AddNewProjectState>(
      listenWhen: (AddNewProjectState previous, AddNewProjectState current) =>
          current is AddNewProjectFailed || current is AddNewProjectSuccess,
      listener: (BuildContext context, AddNewProjectState state) {
        // TODO: implement listener
        if (state is AddNewProjectSuccess) {
          showSnackBar(message: 'Successfully added new project!');
          Navigator.pop(context);
        } else if (state is AddNewProjectFailed) {
          showSnackBar(
            message: state.message,
            snackBartState: SnackBartState.error,
          );
        }
      },
      child: Scaffold(
        appBar: const GlobalAppBar(leading: LeadingButton.back),
        body: Padding(
          padding: EdgeInsets.only(
            bottom: height * 0.03,
            top: 20,
            left: 25,
            right: 25,
          ),
          child: Center(
            child: SizedBox(
              width: kIsWeb && width > smWebMinWidth ? 500 : width,
              child: Column(
                crossAxisAlignment: kIsWeb && width > smWebMinWidth
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Add New Project',
                    style: kIsWeb
                        ? textTheme.titleLarge
                        : textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: FullWidthTextField(
                      tapFunction: () {},
                      textEditingController: projectNameController,
                      hint: 'Project Name',
                      type: Type.normal,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => openColorPickerDialog(),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CircleAvatar(backgroundColor: selectedColor),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor:
                                MaterialStateProperty.all(selectedColor),
                          ),
                          onPressed: () => openColorPickerDialog(),
                          child: Text(
                            'Set Project Primary Color',
                            style: textTheme.bodyMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: width,
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
                            if (projectNameController.text.isEmpty) {
                              showSnackBar(
                                message: 'Please fill out the project name.',
                                snackBartState: SnackBartState.error,
                              );
                            } else {
                              final String stringHex =
                                  '0x${colorToHex(selectedColor)}';
                              context.read<AddNewProjectCubit>().addNewProject(
                                    projectName: projectNameController.text,
                                    projectColor: stringHex,
                                    logoImage: '',
                                  );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 13.0),
                            child: BlocBuilder<AddNewProjectCubit,
                                AddNewProjectState>(
                              buildWhen: (
                                AddNewProjectState previous,
                                AddNewProjectState current,
                              ) =>
                                  current is AddNewProjectLoading ||
                                  current is AddNewProjectFailed ||
                                  current is AddNewProjectSuccess,
                              builder: (
                                BuildContext context,
                                AddNewProjectState state,
                              ) {
                                if (state is AddNewProjectLoading) {
                                  return const LoadingIndicator();
                                }
                                return const Text('Add New Project');
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
