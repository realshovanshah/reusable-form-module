part of 'form_bloc.dart';

abstract class CleanFormState extends Equatable {
  const CleanFormState();

  @override
  List<Object> get props => [];
}

class FormInitialState extends CleanFormState {}

class FormSubmitSuccessState extends CleanFormState {}

class FormFileUploadSuccessState extends CleanFormState {
  final String fileUrl;
  final String fileName;

  FormFileUploadSuccessState(this.fileUrl, this.fileName);
}

class FormSubmitFailureState extends CleanFormState {
  final String errorMessage;

  FormSubmitFailureState(this.errorMessage);
}

class FormSubmitLoadingState extends CleanFormState {}
