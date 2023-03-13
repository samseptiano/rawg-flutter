part of 'list_api_bloc.dart';

@immutable
abstract class ListAPIEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchedListAPISearch extends ListAPIEvent {
  String _search;
  FetchedListAPISearch(this._search);
  @override
  List<Object> get props => [_search];
}

class FetchedListAPISearchLoadMore extends ListAPIEvent {
  String _search;
  FetchedListAPISearchLoadMore(this._search);
  @override
  List<Object> get props => [_search];
}
