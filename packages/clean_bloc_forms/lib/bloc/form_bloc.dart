import 'dart:async';
import 'dart:io';

import 'package:clean_bloc_forms/models/local/form_model.dart';
import 'package:clean_bloc_forms/services/cloud_storage_service.dart';
import 'package:clean_bloc_forms/services/firestore_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../locator.dart';

part 'form_event.dart';
part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, CleanFormState> {
  FormBloc() : super(FormInitialState());

  final _cloudStorageService = serviceLocator<CloudStorageService>();
  final _firestoreService = serviceLocator<FirestoreService>();

  @override
  void onChange(Change<CleanFormState> change) {
    print("${change.currentState} is the current state!");
    super.onChange(change);
  }

  @override
  Stream<CleanFormState> mapEventToState(
    FormEvent event,
  ) async* {
    if (event is FormReloadedEvent) {
      yield FormInitialState();
    }
    if (event is FormSubmittedEvent) {
      try {
        yield FormSubmitLoadingState();
        await _firestoreService.addForm(formModel: event.formModel);
        yield FormSubmitSuccessState();
      } on NullThrownError catch (e) {
        yield FormSubmitFailureState(e.toString());
      }
    }

    if (event is FormFileUploadedEvent) {
      yield FormSubmitLoadingState();

      try {
        final value = await _cloudStorageService.uploadFile(
            file: event.file, title: event.fileName);
        print("corona" + value.toString());
        yield FormFileUploadSuccessState(value!.fileUrl, value.fileName);
      } catch (e) {
        yield FormSubmitFailureState(e.toString());
      }
    }
  }
}
