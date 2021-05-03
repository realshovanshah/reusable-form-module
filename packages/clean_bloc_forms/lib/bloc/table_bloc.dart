import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_bloc_forms/models/local/form_model.dart';
import 'package:clean_bloc_forms/services/cloud_storage_service.dart';
import 'package:clean_bloc_forms/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../locator.dart';

part 'table_event.dart';
part 'table_state.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  TableBloc() : super(TableInitialState());

  final _cloudStorageService = serviceLocator<CloudStorageService>();
  final _firestoreService = serviceLocator<FirestoreService>();

  @override
  Stream<TableState> mapEventToState(
    TableEvent event,
  ) async* {
    if (event is TableDeletedEvent) {
      yield* _mapTableDeletedToState(event);
    }
    if (event is TableUpdatedEvent) {
      yield* _mapTableUpdatedToState(event);
    }
    if (event is TableRequestedEvent) {
      yield* _mapTableRequestedToState(event);
    }
  }

  Stream<TableState> _mapTableUpdatedToState(TableUpdatedEvent event) async* {
    print(event.formModel);
    try {
      yield TableLoadingState();
      await _firestoreService.updateForm(
          formModel: event.formModel, docId: event.docId);
      yield TableLoadingSuccessState(forms: await _firestoreService.getForms());
    } on FirebaseException catch (e) {
      yield TableLoadingFailureState(e.toString());
    }
  }

  Stream<TableState> _mapTableRequestedToState(
      TableRequestedEvent event) async* {
    try {
      yield TableLoadingState();
      final forms = await _firestoreService.getForms();
      yield TableLoadingSuccessState(forms: forms);
    } on FirebaseException catch (e) {
      yield TableLoadingFailureState(e.toString());
    }
  }

  Stream<TableState> _mapTableDeletedToState(TableDeletedEvent event) async* {
    try {
      yield TableLoadingState();
      _firestoreService.deleteForm(event.id);
      _cloudStorageService.deleteForm(event.venue);
      yield TableInitialState();
    } on FirebaseException catch (e) {
      yield TableLoadingFailureState(e.toString());
    }
  }
}
