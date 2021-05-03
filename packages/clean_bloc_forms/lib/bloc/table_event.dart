part of 'table_bloc.dart';

@immutable
abstract class TableEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TableUpdatedEvent extends TableEvent {
  TableUpdatedEvent(this.formModel, this.docId);

  final String docId;
  final Map<String, dynamic> formModel;

  @override
  List<Object> get props => [formModel, docId];

  @override
  String toString() => 'Form Updated { Form: $formModel }';
}

class TableDeletedEvent extends TableEvent {
  final String id;
  final String venue;

  TableDeletedEvent(this.id, this.venue);

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'Table Id { Table: $id, $venue }';
}

class TableRequestedEvent extends TableEvent {}
