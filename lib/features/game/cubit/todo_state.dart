part of 'todo_cubit.dart';

@immutable
abstract class TodoState extends Equatable {
    @override
  List<Object> get props => [];
}

class TodoInitial extends TodoState {
}

class TodoLoaded extends TodoState {
  final List<Result> results;
  TodoLoaded({required this.results});
}

class TodoError extends TodoState {
  final String message;
  TodoError({required this.message});
}

