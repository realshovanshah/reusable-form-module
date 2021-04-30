part of 'form_bloc.dart';

abstract class FormEvent extends Equatable {
  const FormEvent();

  @override
  List<Object> get props => [];
}

class FormReloadedEvent extends FormEvent {}

class FormSubmittedEvent extends FormEvent {
  final FormModel formModel;

  FormSubmittedEvent(this.formModel);

  @override
  List<Object> get props => [formModel];

  @override
  String toString() => 'Form Submitted { Form: $formModel }';
}

class FormFileUploadedEvent extends FormEvent {
  final File file;
  final String fileName;

  FormFileUploadedEvent(this.file, this.fileName);

  @override
  List<Object> get props => [file];

  @override
  String toString() => 'File Added { File: $file }';
}
