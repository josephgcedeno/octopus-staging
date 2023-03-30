import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:octopus/module/login/service/cubit/authentication_cubit.dart';

class TempRegisterScreen extends StatefulWidget {
  const TempRegisterScreen({Key? key}) : super(key: key);

  static const String routeName = '/reg';

  @override
  State<TempRegisterScreen> createState() => _TempRegisterScreenState();
}

class _TempRegisterScreenState extends State<TempRegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
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
            const Center(child: Text('REGISTER SCREEN')),
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
                      Navigator.pop(context);
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
                  context.read<AuthenticationCubit>().register(
                        email: emailController.text,
                        password: '123123123',
                        position: 'COO',
                      );
                },
                child: const Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
