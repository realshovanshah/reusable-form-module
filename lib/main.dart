import 'package:clean_forms/locator.dart';
import 'package:clean_forms/ui/form_screen.dart';
import 'package:clean_forms/ui/loading_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/form_bloc.dart';

void main() async {
  setUpServiceLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
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
      ),
    );
  }
}
