import 'package:bloc/bloc.dart';
import 'package:bloc_tutorial/features/game/model/game_response.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'user_click_event.dart';
part 'user_click_state.dart';

class UserClickBloc extends Bloc<UserClickEvent, UserClickState> {
  UserClickBloc() : super(UserClickNotActive()) {
    late Result _resultActive;
    on<UserClickEvent>((event, emit) async {
      try {
        if (event is UserClickListEvent) {
          _resultActive = event._resultClicked;
          emit(UserClickActive(result: _resultActive));
        } else {
          emit(UserClickNotActive());
        }
      } on Exception {
        emit(UserClickNotActive());
      }
    });
  }
}
