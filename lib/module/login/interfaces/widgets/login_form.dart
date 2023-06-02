import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/interfaces/widgets/loading_indicator.dart';
import 'package:octopus/module/login/service/cubit/authentication_cubit.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment:
            kIsWeb ? MainAxisAlignment.center : MainAxisAlignment.end,
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
                  /// INFO: Temporarily disabled forgot password feature
                  // onTap: () {
                  //   Navigator.of(context).push(
                  //     MaterialPageRoute<dynamic>(
                  //       builder: (_) => const TempRegisterScreen(),
                  //     ),
                  //   );
                  // },
                  child: Text(
                    'Forgot password?',
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
                onTap: () => setState(() => showPassword = !showPassword),
                child: Icon(
                  Icons.remove_red_eye_outlined,
                  color: showPassword ? theme.primaryColor : Colors.grey,
                ),
              ),
            ),
            obscureText: !showPassword,
          ),
          Container(
            width: width,
            margin: EdgeInsets.only(top: height * 0.03),
            child: ElevatedButton(
              style: primaryButtonStyle,
              onPressed: () {
                if (formKey.currentState!.validate()) {
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
              child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
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
    );
  }
}
