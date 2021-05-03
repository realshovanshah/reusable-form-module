part of 'table_bloc.dart';

@immutable
abstract class TableState {}

class TableInitialState extends TableState {}

class TableLoadingSuccessState extends TableState {
  final List<FormModel> forms;

  TableLoadingSuccessState({required this.forms});
}

class TableLoadingState extends TableState {}

class TableLoadingFailureState extends TableState {
  final String errorMessage;

  TableLoadingFailureState(this.errorMessage);
}
