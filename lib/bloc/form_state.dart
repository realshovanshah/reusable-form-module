part of 'form_bloc.dart';

abstract class FormState extends Equatable {
  const FormState();

  @override
  List<Object> get props => [];
}

class FormInitial extends FormState {}

class FormSubmitSuccessState extends FormState {
  final String successMessage;

  FormSubmitSuccessState(this.successMessage);
}

class FormSubmitFailureState extends FormState {
  final String errorMessage;

  FormSubmitFailureState(this.errorMessage);
}

class FormSubmitLoadingState extends FormState {}
