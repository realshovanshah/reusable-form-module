library clean_forms;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/form_bloc.dart';
import 'locator.dart';
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
    return Scaffold(
      body: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorWidget("Check your internet connection");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return BlocProvider(
              create: (context) => FormBloc(),
              child: FormScreen(),
            );
          }
          return ProgressBarWidget();
        },
      ),
    );
  }
}
