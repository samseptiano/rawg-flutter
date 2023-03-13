part of 'user_click_bloc.dart';

@immutable
abstract class UserClickEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UserClickListEvent extends UserClickEvent {
  Result _resultClicked;
  UserClickListEvent(this._resultClicked);
  @override
  List<Object> get props => [_resultClicked];
}
