import 'package:bloc/bloc.dart';
import 'package:bloc_tutorial/features/game/domain/game_repository_impl.dart';
import 'package:bloc_tutorial/features/game/model/game_response.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
    final GameRepository _gamerepo;

  TodoCubit(this._gamerepo) : super(TodoInitial());

  Future<void> getData() async {
    try {
      List<Result> results = await _gamerepo.fetchDataImpl("", 1, 10);
      emit(TodoLoaded(results: results));
    } on Exception {
      emit(TodoError(message: "Could not fetch the list, please try again later!"));
    }
  }
}
