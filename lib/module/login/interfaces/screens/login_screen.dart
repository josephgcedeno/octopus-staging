import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/interfaces/widgets/loading_indicator.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/module/dashboard/interfaces/screens/controller_screen.dart';
import 'package:octopus/module/login/interfaces/screens/temp_register_screen.dart';
import 'package:octopus/module/login/service/cubit/authentication_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
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
            child: Column(
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
                RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Hi there!',
                        style: theme.textTheme.displayLarge
                            ?.copyWith(fontSize: height * 0.05),
                      ),
                      TextSpan(
                        text: "\nLet's get you ",
                        style: theme.textTheme.displayLarge
                            ?.copyWith(fontSize: height * 0.05),
                      ),
                      TextSpan(
                        text: 'prepared',
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: theme.primaryColor,
                          fontSize: height * 0.05,
                        ),
                      ),
                      TextSpan(
                        text: '.',
                        style: theme.textTheme.displayLarge
                            ?.copyWith(fontSize: height * 0.05),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.02),
                        child: const Text('Email'),
                      ),
                      TextFormField(
                        controller: emailController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email.';
                          }
                          if (!_emailRegex.hasMatch(value)) {
                            return 'Invalid email format.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFf5f7f9),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text('Password'),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<dynamic>(
                                    builder: (_) => const TempRegisterScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgotten?',
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(color: theme.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                        controller: passwordController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFf5f7f9),
                          suffixIcon: GestureDetector(
                            onTap: () =>
                                setState(() => showPassword = !showPassword),
                            child: Icon(
                              Icons.remove_red_eye_outlined,
                              color: showPassword
                                  ? theme.primaryColor
                                  : Colors.grey,
                            ),
                          ),
                        ),
                        obscureText: !showPassword,
                      ),
                      Container(
                        width: width,
                        margin: EdgeInsets.only(top: height * 0.03),
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
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthenticationCubit>().login(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                            }
                            if (emailController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              return;
                            }
                          },
                          child: BlocBuilder<AuthenticationCubit,
                              AuthenticationState>(
                            buildWhen: (
                              AuthenticationState previous,
                              AuthenticationState current,
                            ) =>
                                current is LoginLoading ||
                                current is LoginFailed ||
                                current is LoginSuccess,
                            builder: (
                              BuildContext context,
                              AuthenticationState state,
                            ) {
                              if (state is LoginLoading) {
                                return const LoadingIndicator();
                              }
                              return const Text('Sign In');
                            },
                          ),
                        ),
                      ),
                    ],
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
