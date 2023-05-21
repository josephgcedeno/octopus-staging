import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/module/dashboard/interfaces/screens/controller_screen.dart';
import 'package:octopus/module/login/interfaces/widgets/greeting_text.dart';
import 'package:octopus/module/login/interfaces/widgets/login_form.dart';
import 'package:octopus/module/login/service/cubit/authentication_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listenWhen: (AuthenticationState previous, AuthenticationState current) =>
          current is LoginSuccess || current is LoginFailed,
      listener: (BuildContext context, AuthenticationState state) {
        if (state is LoginSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<dynamic>(
              builder: (_) => const ControllerScreen(),
            ),
            (Route<dynamic> route) => false,
          );
        } else if (state is LoginFailed) {
          showSnackBar(
            message: state.message,
            snackBartState: SnackBartState.error,
          );
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: height,
            margin: EdgeInsets.symmetric(
              horizontal: width * 0.1,
            ),
            child: kIsWeb
                ? Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: height * 0.05),
                              width: width * 0.35,
                              height: height * 0.20,
                              child: SvgPicture.asset(logoSvg),
                            ),
                            const GreetingText(),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: height * 0.45,
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          margin:
                              EdgeInsets.symmetric(horizontal: width * 0.04),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.blueGrey.withOpacity(0.05),
                                spreadRadius: 8,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: LoginForm(formKey: formKey),
                        ),
                      )
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: height * 0.05),
                          width: width * 0.35,
                          height: height * 0.20,
                          child: SvgPicture.asset(logoSvg),
                        ),
                      ),
                      const GreetingText(),
                      LoginForm(formKey: formKey)
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
