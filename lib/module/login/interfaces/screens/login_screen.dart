import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:octopus/interfaces/widgets/loading_indicator.dart';
import 'package:octopus/module/dashboard/interfaces/screens/controller_screen.dart';
import 'package:octopus/module/login/interfaces/screens/temp_register_screen.dart';
import 'package:octopus/module/login/service/cubit/login_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (LoginState previous, LoginState current) =>
          current is LoginSuccess || current is LoginFailed,
      listener: (BuildContext context, LoginState state) {
        if (state is LoginSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<dynamic>(
              builder: (_) => const ControllerScreen(),
            ),
            (Route<dynamic> route) => false,
          );
        } else if (state is LoginFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.errorColor,
            ),
          );
        }
      },
      child: Scaffold(
        body: Container(
          // padding: EdgeInsets.symmetric(horizontal: width * 0.1),
          margin: EdgeInsets.symmetric(
            vertical: height * 0.06,
            horizontal: width * 0.1,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text('Email'),
              ),
              TextField(
                controller: emailController,
                onTap: () {},
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
                padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                        style: theme.textTheme.bodyText2
                            ?.copyWith(color: theme.primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              TextField(
                controller: passwordController,
                onTap: () {},
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
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  onPressed: () {
                    context.read<LoginCubit>().login(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                  },
                  child: BlocBuilder<LoginCubit, LoginState>(
                    buildWhen: (LoginState previous, LoginState current) =>
                        current is LoginLoading ||
                        current is LoginFailed ||
                        current is LoginSuccess,
                    builder: (BuildContext context, LoginState state) {
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
      ),
    );
  }
}
