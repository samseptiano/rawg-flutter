part of 'user_click_bloc.dart';

@immutable
abstract class UserClickState extends Equatable {
    @override
  List<Object> get props => [];
}

class UserClickNotActive extends UserClickState {
}

class UserClickActive extends UserClickState {
  final Result result;
  UserClickActive({required this.result});

   @override
  List<Object> get props => [result];
}
