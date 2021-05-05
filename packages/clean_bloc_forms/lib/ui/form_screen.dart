import 'dart:io';
import 'dart:typed_data';

import 'package:clean_bloc_forms/bloc/form_bloc.dart';
import 'package:clean_bloc_forms/bloc/table_bloc.dart';
import 'package:clean_bloc_forms/constants/enums.dart';
import 'package:clean_bloc_forms/models/local/form_model.dart';
import 'package:clean_bloc_forms/utils/file_selector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../locator.dart';
import 'loading_screen.dart';

class FormScreen extends StatefulWidget {
  FormScreen({
    Key? key,
    required this.title,
    required this.formModel,
  }) : super(key: key);
  final String title;
  final FormModel? formModel;
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  var fileNotifier = ValueNotifier<FileModel?>(null);
  late Map<String, dynamic> formData;
  late final TableBloc _tableBloc;

  @override
  Widget build(BuildContext context) {
    final _bloc = BlocProvider.of<FormBloc>(context);
    _tableBloc = BlocProvider.of<TableBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 500,
          ),
          child: BlocBuilder(
            bloc: _bloc,
            builder: (BuildContext context, state) {
              if (state is FormFileUploadSuccessState) {
                formData['fileUrl'] = state.fileUrl;
                formData['title'] = state.fileName;
                formData['updatedAt'] = Timestamp.now();
                print(formData);
                print(FormModel.fromMap(formData));
                (widget.formModel == null)
                    ? _bloc.add(FormSubmittedEvent(FormModel.fromMap(formData)))
                    : _tableBloc.add(
                        TableUpdatedEvent(formData, widget.formModel!.docId!));
                // print(formData);

                // return ProgressBarWidget();
              }
              if (state is FormSubmitSuccessState) {
                print('eta xa, will pop ma');
                return WillPopScope(
                    onWillPop: _willPopCallback,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Upload Complete!'),
                        CupertinoButton(
                            child: Text('Go Back'),
                            onPressed: () {
                              _bloc.add(FormReloadedEvent());
                              _tableBloc.add(TableRequestedEvent());
                            }),
                      ],
                    ));
              }
              if (state is FormInitialState) {
                fileNotifier.value = null;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: FormBuilder(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              "Upload to cloud.",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 30),
                            ),
                          ),
                          SizedBox(height: 20),
                          FormBuilderTextField(
                            name: 'title',
                            initialValue: widget.formModel?.title ?? '',
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              labelText: 'Title',
                            ),
                            // onChanged: (value) {},
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                              FormBuilderValidators.max(context, 20),
                            ]),
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(height: 20),
                          FormBuilderDropdown(
                            initialValue: widget.formModel?.screenType ?? null,
                            name: 'screenType',
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              labelText: 'Screen Type',
                            ),
                            allowClear: true,
                            hint: Text('Screen Type'),
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required(context)]),
                            items: (ScreenType.values)
                                .map((screenOption) => DropdownMenuItem(
                                      value: screenOption.index,
                                      child: Text(
                                          '${screenOption.getEnumValue()}'),
                                    ))
                                .toList(),
                          ),
                          SizedBox(height: 20),
                          FormBuilderDropdown(
                            initialValue: widget.formModel?.category ?? null,
                            name: 'category',
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              labelText: 'Category',
                            ),
                            allowClear: true,
                            hint: Text('Category'),
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required(context)]),
                            items: (CategoryType.values)
                                .map((formOption) => DropdownMenuItem(
                                      value: formOption.index,
                                      child:
                                          Text('${formOption.getEnumValue()}'),
                                    ))
                                .toList(),
                          ),
                          FormBuilderChoiceChip(
                            initialValue: widget.formModel?.status ?? null,
                            name: 'status',
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Status',
                            ),
                            options: [
                              FormBuilderFieldOption(
                                value: false,
                                child: Text('True'),
                              ),
                              FormBuilderFieldOption(
                                value: true,
                                child: Container(
                                  child: Text('False'),
                                ),
                              ),
                            ],
                            spacing: 8,
                            onChanged: (value) => {print(value)},
                          ),
                          FormBuilderField(
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required(context)]),
                            name: 'fileUrl',
                            initialValue: widget.formModel?.title ?? null,
                            builder: (FormFieldState<dynamic> field) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  labelText: 'File',
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    fileNotifier.value =
                                        await serviceLocator<FileSelector>()
                                            .selectFile();
                                    field.didChange(fileNotifier.value);
                                  },
                                  child: Container(
                                    height: 100,
                                    padding: EdgeInsets.all(16),
                                    child: ValueListenableBuilder(
                                        valueListenable: fileNotifier,
                                        builder: (context, value, child) {
                                          var file = _formKey.currentState
                                              ?.fields.values.first.value;
                                          print('ahahhaha' + file.toString());
                                          if (file != '') {
                                            fileNotifier.value =
                                                FileModel(Uint8List(0), file);
                                          }
                                          return Center(
                                            child: (fileNotifier.value == null)
                                                ? Text(
                                                    "Click here to select a file.")
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(fileNotifier
                                                            .value!.title),
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons.close,
                                                          ),
                                                          onPressed: () {
                                                            fileNotifier.value =
                                                                null;
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                          );
                                        }),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: CupertinoButton(
                                  color: Theme.of(context).accentColor,
                                  child: Text(
                                    "Reset",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    fileNotifier.value = null;
                                    _formKey.currentState?.reset();
                                    if (widget.formModel != null) {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'This is the initial data of your form.')));
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: CupertinoButton(
                                  color: Theme.of(context).accentColor,
                                  child: Text(
                                    "Done",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    var currentState = _formKey.currentState;
                                    currentState?.save();
                                    formData = Map.from(currentState!.value);
                                    if (currentState.validate() == true) {
                                      print(currentState.value);
                                      _bloc.add(
                                        FormFileUploadedEvent(
                                          fileNotifier.value!.byteData,
                                          fileNotifier.value!.title,
                                        ),
                                      );
                                    } else {
                                      print(currentState.value);
                                      (!currentState.fields['fileUrl']!
                                              .validate())
                                          ? ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content:
                                                      Text('Select a file!')))
                                          : print("validation success");
                                    }
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Builder(builder: (context) {
                  print('eta xa, tala ko builder ma');

                  return (context.watch<TableBloc>().state
                              is TableLoadingState) ||
                          (context.watch<FormBloc>().state
                              is FormSubmitLoadingState)
                      ? ProgressBarWidget()
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Upload Complete!'),
                              CupertinoButton(
                                  child: Text('Go Back'),
                                  onPressed: () {
                                    _bloc.add(FormReloadedEvent());
                                    _tableBloc.add(TableRequestedEvent());
                                    Navigator.of(context).pop();
                                  }),
                            ],
                          ),
                        );
                });
              }
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _willPopCallback() async {
    _tableBloc.add(TableRequestedEvent());
    return true;
  }
}
