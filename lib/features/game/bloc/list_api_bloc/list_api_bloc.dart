import 'package:bloc/bloc.dart';
import 'package:bloc_tutorial/features/game/domain/game_repository_impl.dart';
import 'package:bloc_tutorial/features/game/model/game_response.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'list_api_event.dart';
part 'list_api_state.dart';

class ListAPIBloc extends Bloc<ListAPIEvent, ListAPIState> {
  List<Result> myList = [];
  int pageSize = 10;
  int page = 1;
  String lastSearchQuery = "";

  ListAPIBloc() : super(ListAPIInitial()) {
    final GameRepository _gamerepo = GameRepositoryImpl();
    on<ListAPIEvent>((event, emit) async {
      try {
        print("event: $event");
        if (event is FetchedListAPISearch) {
          if (lastSearchQuery != event._search) {
            lastSearchQuery = event._search;
            myList = List.empty();
            page = 1;
          }

          print("state: $state");
          if (state is ListAPIInitial) {
            List<Result> results =
                await _gamerepo.fetchDataImpl(event._search, page, pageSize);
            print("load first time: $myList");
            page++;
            myList = results;
            print("list size initial: ${myList.length}");

            emit(ListAPILoaded(results: myList));
          } else {
            List<Result> results =
                await _gamerepo.fetchDataImpl(event._search, page, pageSize);
            print("load $page time: $myList");
            page++;

            myList += results;
            print("list size loaded: ${myList.length}");

            emit(ListAPILoaded(results: myList));
          }
        } else if (event is FetchedListAPISearchLoadMore) {
          if (lastSearchQuery != event._search) {
            lastSearchQuery = event._search;
            myList = List.empty();
            page = 1;
          }

          print("state: $state");
          if (state is ListAPIInitial) {
            List<Result> results =
                await _gamerepo.fetchDataImpl(event._search, page, pageSize);
            print("load first time: $myList");
            page++;
            myList = results;
            print("list size load more initial: ${myList.length}");
            emit(ListAPILoaded(results: myList));
          } else {
            List<Result> results =
                await _gamerepo.fetchDataImpl(event._search, page, pageSize);
            print("load $page time: $myList");
            page++;

            myList += results;
            print("list size load more loaded: ${myList.length}");
            emit(ListAPILoaded(results: myList));
          }
        }
      } on Exception {
        emit(ListAPIError(
            message: "Couldn't fetch the list, please try again later!"));
      }
    });
  }
}
