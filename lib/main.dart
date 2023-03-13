import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'bloc_observer/list_api_bloc_observer.dart';

void main() async {
  BlocOverrides.runZoned(
    () => runApp(const App()),
    blocObserver: ListAPIBlocObserver(),
  );
}
