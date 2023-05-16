import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/module/historical_data/interfaces/widgets/add_user.dart';
import 'package:octopus/module/historical_data/interfaces/widgets/pick_date.dart';
import 'package:octopus/module/historical_data/interfaces/widgets/user_icon.dart';
import 'package:octopus/module/historical_data/interfaces/widgets/user_selection_builder.dart';
import 'package:octopus/module/historical_data/services/cubit/historical_cubit.dart';

class DropDownValue {
  DropDownValue({
    required this.options,
    required this.hintText,
  });

  final List<String> options;
  final String hintText;
}

class HistoricalScreenTemplate extends StatefulWidget {
  const HistoricalScreenTemplate({
    required this.title,
    required this.generateBtnText,
    this.dropDownValue,
    this.isDropdownLoading = false,
    Key? key,
  }) : super(key: key);
  final String title;
  final String generateBtnText;
  final DropDownValue? dropDownValue;
  final bool isDropdownLoading;

  @override
  State<HistoricalScreenTemplate> createState() =>
      _HistoricalScreenTemplateState();
}

class _HistoricalScreenTemplateState extends State<HistoricalScreenTemplate> {
  final List<User> users = <User>[];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isShowOptions = false;
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    context.read<HistoricalCubit>().fetchAllUser();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return BlocListener<HistoricalCubit, HistoricalState>(
      listenWhen: (HistoricalState previous, HistoricalState current) =>
          current is FetchAllUserSuccess,
      listener: (BuildContext context, HistoricalState state) {
        if (state is FetchAllUserSuccess) {
          setState(() {
            users.addAll(state.users);
          });
        }
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            isShowOptions = false;
          });
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: const GlobalAppBar(leading: LeadingButton.back),
          body: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: height * 0.03, top: 20),
                      child: Center(
                        child: Text(
                          widget.title,
                          style: kIsWeb
                              ? theme.textTheme.titleLarge
                              : theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 9.0),
                            child: Row(
                              children: <Widget>[
                                const Padding(
                                  padding: EdgeInsets.only(right: 4.0),
                                  child: Text(
                                    'Select members',
                                  ),
                                ),
                                Tooltip(
                                  padding: const EdgeInsets.all(10),
                                  triggerMode: TooltipTriggerMode.tap,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Colors.grey
                                            .withOpacity(0.5), // Shadow color
                                        spreadRadius: 2, // Spread radius
                                        blurRadius: 4, // Blur radius
                                        offset: const Offset(0, 3), // Offset
                                      ),
                                    ],
                                  ),
                                  message:
                                      'If you did not select any user, all members will be automatically added to in PDF file.',
                                  textStyle: const TextStyle(
                                    color: kDarkGrey,
                                  ),
                                  textAlign: TextAlign.center,
                                  child: const Icon(
                                    Icons.info,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                          ),
                          BlocBuilder<HistoricalCubit, HistoricalState>(
                            builder:
                                (BuildContext context, HistoricalState state) {
                              final List<User> users =
                                  state.selectedUser ?? <User>[];
                              return Wrap(
                                spacing: 6,
                                runSpacing: 5,
                                children: <Widget>[
                                  for (final User user in users)
                                    FadeIn(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      child: SizedBox(
                                        width: 90,
                                        height: 30,
                                        child: UserIcon(
                                          imageUrl: user.profileImageSource,
                                          userName: user.firstName,
                                        ),
                                      ),
                                    ),
                                  AddUser(
                                    callback: () => setState(
                                      () => isShowOptions = !isShowOptions,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 9.0),
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 18.0),
                                  child: PickDate(
                                    callBack: (
                                      PickTypeSelected selected,
                                      DateTime? today,
                                      DateTime? to,
                                    ) {},
                                  ),
                                ),
                                if (isShowOptions)
                                  GestureDetector(
                                    onTap: () {},
                                    child: UserSelectionBuilder(
                                      users: users,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (widget.dropDownValue != null)
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: const Color(0xFFf5f7f9),
                              ),
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                ),
                                hint: Text(widget.dropDownValue!.hintText),
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
                                  dropdownValue = value;
                                },
                                items: widget.dropDownValue!.options
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            )
                          else if (widget.isDropdownLoading)
                            lineLoader(
                              height: height * 0.07,
                              width: width,
                            )
                        ],
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {}
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.06,
                      vertical: height * 0.02,
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: width * 0.06,
                      horizontal: 25,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          widget.generateBtnText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.primaryColor,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: theme.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
