library clean_forms;

import 'package:clean_bloc_forms/bloc/table_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/form_bloc.dart';
import 'locator.dart';
import 'ui/display_screen.dart';
import 'ui/form_screen.dart';
import 'ui/loading_screen.dart';

class CleanFormPage extends StatefulWidget {
  const CleanFormPage({
    Key? key,
  }) : super(key: key);

  @override
  _CleanFormPageState createState() => _CleanFormPageState();
}

class _CleanFormPageState extends State<CleanFormPage> {
  @override
  void initState() {
    setUpServiceLocator();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late final TableBloc _tableBloc;
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Builder(builder: (context) {
          return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (BuildContext context) {
                    return BlocProvider(
                      create: (context) => FormBloc(),
                      child: BlocProvider.value(
                        value: _tableBloc,
                        child: FormScreen(
                          formModel: null,
                          title: 'Upload',
                        ),
                      ),
                    );
                  },
                ),
              ).then((value) => _tableBloc.add(TableRequestedEvent()));
            },
          );
        }),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorWidget("Check your internet connection");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            _tableBloc = TableBloc();
            return BlocProvider(
              create: (context) => _tableBloc,
              child: DisplayScreen(),
            );
          }
          return ProgressBarWidget();
        },
      ),
    );
  }
}
