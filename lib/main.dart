import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/repository/auth_repository.dart';
import 'package:octopus/module/login/interfaces/screens/login_screen.dart';
import 'package:octopus/module/login/service/cubit/login_cubit.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Load env file
  await dotenv.load();

  final String appId = dotenv.get('APP_ID');
  final String serverUrl = dotenv.get('SERVER_URL');
  final String masterKey = dotenv.get('MASTER_KEY');

  await Parse().initialize(
    appId,
    serverUrl,
    masterKey: masterKey,
  );

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();

    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<LoginCubit>(
          create: (BuildContext context) =>
              LoginCubit(authRepository: authRepository),
        ),
      ],
      child: MaterialApp(
        title: dotenv.get('TITLE'),
        home: _HomePageState(),
        theme: defaultTheme,
        supportedLocales: const <Locale>[
          Locale('en'),
        ],
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class _HomePageState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const LoginScreen();
  }
}
