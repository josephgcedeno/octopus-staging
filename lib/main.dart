import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/repository/quote_repository.dart';
import 'package:octopus/module/home/interfaces/screens/home_screen.dart';
import 'package:octopus/module/home/service/cubit/quote_cubit.dart';

void main() async {
  /// Load env file
  await dotenv.load();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        // ================ quote module ================
        BlocProvider<QuoteCubit>(
          create: (BuildContext context) => QuoteCubit(
            quoteRepository: QuoteRepository(),
          ),
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
    return const HomeScreen();
  }
}
