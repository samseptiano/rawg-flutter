import 'package:bloc_tutorial/assets/app_color.dart';
import 'package:bloc_tutorial/features/game/bloc/list_api_bloc/list_api_bloc.dart';
import 'package:bloc_tutorial/features/game/bloc/user_click_bloc/user_click_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_tutorial/assets/app_string.dart';

import 'features/game/presentation/game_list_view.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: AppColors.primaryTheme,
          foregroundColor: AppColors.white,
        )
      ),
      debugShowCheckedModeBanner: false,
      title: AppString().AppName,
      home: MultiBlocProvider(providers: [
        BlocProvider(
          create: (context) => ListAPIBloc(),
        ),
        BlocProvider(
          create: (context) => UserClickBloc(),
        )
      ], child: const GameListView()),
    );
  }
}
