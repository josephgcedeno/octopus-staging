import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';
import 'package:octopus/module/historical_data/interfaces/widgets/add_user.dart';
import 'package:octopus/module/historical_data/interfaces/widgets/pick_date.dart';
import 'package:octopus/module/historical_data/interfaces/widgets/user_icon.dart';
import 'package:octopus/module/historical_data/interfaces/widgets/user_selection_builder.dart';
import 'package:octopus/module/historical_data/services/cubit/historical_cubit.dart';

enum DropdownType { dsr, leave }

class DropDownValue {
  DropDownValue({
    required this.options,
    required this.hintText,
    required this.dropdownType,
  });

  final List<String> options;
  final String hintText;
  final DropdownType dropdownType;
}

class CallbackReturnData {
  CallbackReturnData({
    required this.users,
    required this.pickTypeSelected,
    this.today,
    this.from,
    this.to,
    this.dropdownValueSelected,
  });

  final List<User> users;
  final PickTypeSelected pickTypeSelected;
  final DateTime? today;
  final DateTime? from;
  final DateTime? to;
  final String? dropdownValueSelected;
}

class HistoricalScreenTemplate extends StatefulWidget {
  const HistoricalScreenTemplate({
    required this.title,
    required this.generateBtnText,
    required this.callback,
    this.dropDownValue,
    this.isDropdownLoading = false,
    Key? key,
  }) : super(key: key);
  final String title;
  final String generateBtnText;
  final DropDownValue? dropDownValue;
  final bool isDropdownLoading;
  final void Function(CallbackReturnData) callback;

  @override
  State<HistoricalScreenTemplate> createState() =>
      _HistoricalScreenTemplateState();
}

class _HistoricalScreenTemplateState extends State<HistoricalScreenTemplate> {
  final List<User> users = <User>[];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isShowOptions = false;
  late String? dropdownValue =
      widget.dropDownValue?.dropdownType == DropdownType.leave
          ? null
          : widget.dropDownValue?.options[0];

  // For picking date info, if selected is type today, expected today is not null.
  PickTypeSelected? selected;
  DateTime? today;
  DateTime? from;
  DateTime? to;

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
          body: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  bottom: height * 0.03,
                  top: 20,
                  left: 25,
                  right: 25,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Align(
                    alignment: kIsWeb && width > smWebMinWidth
                        ? Alignment.centerLeft
                        : Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (kIsWeb && width > smWebMinWidth)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Text(
                              'Historical Data',
                              style: kIsWeb
                                  ? theme.textTheme.titleLarge
                                  : theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                            ),
                          ),
                        Text(
                          widget.title,
                          style: kIsWeb && width > smWebMinWidth
                              ? theme.textTheme.titleMedium
                              : theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  child: SizedBox(
                    width:
                        kIsWeb && width > smWebMinWidth ? width * 0.45 : width,
                    child: Form(
                      key: _formKey,
                      child: SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 9.0),
                                        child: Row(
                                          children: <Widget>[
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 4.0),
                                              child: Text(
                                                'Select members',
                                              ),
                                            ),
                                            Tooltip(
                                              padding: const EdgeInsets.all(10),
                                              triggerMode:
                                                  TooltipTriggerMode.tap,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                    color:
                                                        Colors.grey.withOpacity(
                                                      0.5,
                                                    ), // Shadow color
                                                    spreadRadius:
                                                        2, // Spread radius
                                                    blurRadius:
                                                        4, // Blur radius
                                                    offset: const Offset(
                                                      0,
                                                      3,
                                                    ), // Offset
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
                                      BlocBuilder<HistoricalCubit,
                                          HistoricalState>(
                                        builder: (
                                          BuildContext context,
                                          HistoricalState state,
                                        ) {
                                          final List<User> users =
                                              state.selectedUser ?? <User>[];
                                          return Wrap(
                                            spacing: 6,
                                            runSpacing: 5,
                                            children: <Widget>[
                                              for (final User user in users)
                                                FadeIn(
                                                  duration: const Duration(
                                                    milliseconds: 500,
                                                  ),
                                                  child: SizedBox(
                                                    width: 90,
                                                    height: 30,
                                                    child: UserIcon(
                                                      imageUrl: user
                                                          .profileImageSource,
                                                      userName: user.firstName,
                                                    ),
                                                  ),
                                                ),
                                              AddUser(
                                                callback: () => setState(
                                                  () => isShowOptions =
                                                      !isShowOptions,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 9.0),
                                        child: Stack(
                                          alignment: Alignment.centerLeft,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 18.0,
                                              ),
                                              child: PickDate(
                                                callBack: ({
                                                  required PickTypeSelected
                                                      pickTypeSelected,
                                                  DateTime? today,
                                                  DateTime? from,
                                                  DateTime? to,
                                                }) {
                                                  selected = pickTypeSelected;
                                                  this.today = today;
                                                  this.from = from;
                                                  this.to = to;
                                                },
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
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: const Color(0xFFf5f7f9),
                                          ),
                                          child:
                                              DropdownButtonFormField<String>(
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                            value: dropdownValue,
                                            icon: const Icon(
                                              Icons
                                                  .keyboard_arrow_down_outlined,
                                            ),
                                            hint: Text(
                                              widget.dropDownValue!.hintText,
                                            ),
                                            elevation: 2,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            validator: (String? value) {
                                              if (value == null ||
                                                  value.isEmpty) {
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 30.0,
                                horizontal: 20,
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final List<User> selectedUsers = context
                                            .read<HistoricalCubit>()
                                            .state
                                            .selectedUser ??
                                        <User>[];

                                    // If there is no selected user, then simply add all users.
                                    if (selectedUsers.isEmpty) {
                                      selectedUsers.addAll(users);
                                    }

                                    widget.callback.call(
                                      CallbackReturnData(
                                        pickTypeSelected: selected!,
                                        users: selectedUsers,
                                        today: today,
                                        from: from,
                                        to: to,
                                        dropdownValueSelected: dropdownValue,
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 17,
                                    horizontal: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor.withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
