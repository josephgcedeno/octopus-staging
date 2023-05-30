import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/infrastructures/models/hr/hr_response.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';
import 'package:octopus/module/hr_files/interfaces/widgets/credentials_card.dart';
import 'package:octopus/module/hr_files/services/cubit/hr_cubit.dart';

class CredentialListScreen extends StatefulWidget {
  const CredentialListScreen({Key? key}) : super(key: key);

  @override
  State<CredentialListScreen> createState() => _CredentialListScreenState();
}

class _CredentialListScreenState extends State<CredentialListScreen> {
  Widget wrapItems({required List<Widget> children}) => Align(
        child: Wrap(
          children: children,
        ),
      );
  @override
  void initState() {
    super.initState();
    context.read<HrCubit>().fetchAllCredentials();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const GlobalAppBar(leading: LeadingButton.back),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          width: width,
          child: Container(
            width: width,
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.055,
              vertical: height * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(Icons.note_alt_outlined),
                    Padding(
                      padding: EdgeInsets.only(left: width * 0.03),
                      child: Text(
                        'Credentials List',
                        textAlign: TextAlign.left,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                BlocBuilder<HrCubit, HrState>(
                  buildWhen: (HrState previous, HrState current) =>
                      current is FetchAllCredentialsLoading ||
                      current is FetchAllCredentialsSuccess,
                  builder: (BuildContext context, HrState state) {
                    if (state is FetchAllCredentialsSuccess) {
                      return wrapItems(
                        children: <Widget>[
                          for (final Credential credential in state.credential)
                            SizedBox(
                              width: kIsWeb && width > smWebMinWidth
                                  ? width * 0.38
                                  : width,
                              child: CredentialsCard(
                                appTitle: credential.accountType,
                                email: credential.username,
                                password: credential.password,
                              ),
                            ),
                        ],
                      );
                    }
                    return wrapItems(
                      children: <Widget>[
                        for (int i = 0; i < 4; i++)
                          Container(
                            margin: EdgeInsets.only(
                              left: width * 0.03,
                              right: width * 0.03,
                              bottom: height * 0.02,
                              top: height * 0.035,
                            ),
                            child: lineLoader(
                              height:
                                  height >= smMinHeight && height <= smMaxHeight
                                      ? height * 0.28
                                      : 200.01,
                              width: kIsWeb && width > smWebMinWidth
                                  ? width * 0.30
                                  : width,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
