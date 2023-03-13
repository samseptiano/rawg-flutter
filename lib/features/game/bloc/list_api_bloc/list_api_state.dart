part of 'list_api_bloc.dart';

@immutable
abstract class ListAPIState extends Equatable {
    @override
  List<Object> get props => [];
}

class ListAPIInitial extends ListAPIState {
}

class ListAPILoaded extends ListAPIState {
  final List<Result> results;
  ListAPILoaded({required this.results});

   @override
  List<Object> get props => [results];
}

class ListAPIError extends ListAPIState {
  final String message;
  ListAPIError({required this.message});
}