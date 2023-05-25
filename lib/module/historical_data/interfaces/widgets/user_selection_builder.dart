import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';
import 'package:octopus/module/historical_data/services/cubit/historical_cubit.dart';

class UserSelectionBuilder extends StatefulWidget {
  const UserSelectionBuilder({required this.users, Key? key}) : super(key: key);
  final List<User> users;

  @override
  State<UserSelectionBuilder> createState() => _UserSelectionBuilderState();
}

class _UserSelectionBuilderState extends State<UserSelectionBuilder> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      height: height * 0.30,
      padding: EdgeInsets.all(
        kIsWeb && width > smWebMinWidth ? 25 : 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 2, // Spread radius
            blurRadius: 4, // Blur radius
            offset: const Offset(0, 3), // Offset
          ),
        ],
      ),
      child: widget.users.isEmpty
          ? ListView(
              children: <Widget>[
                for (int i = 0; i < 5; i++)
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: lineLoader(height: height * 0.055, width: width),
                    ),
                  )
              ],
            )
          : ListView.builder(
              itemCount: widget.users.length,
              itemBuilder: (BuildContext context, int index) {
                final User user = widget.users[index];

                return GestureDetector(
                  onTap: () {
                    context.read<HistoricalCubit>().toggleUser(user);
                    setState(() {});
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: context
                                  .read<HistoricalCubit>()
                                  .state
                                  .selectedUser
                                  ?.contains(user) ??
                              false
                          ? kBlue.withOpacity(0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: Image.network(
                            user.profileImageSource,
                            width: 25,
                            height: 25,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        Text('${user.firstName} ${user.lastName}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
