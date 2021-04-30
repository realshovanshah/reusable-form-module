import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'form_event.dart';
part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormState> {
  FormBloc() : super(FormInitial());

  @override
  Stream<FormState> mapEventToState(
    FormEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
