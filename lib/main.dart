import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geminiclone/presentation/bloc/starter/starter_bloc.dart';
import 'package:geminiclone/presentation/pages/home_page.dart';
import 'package:geminiclone/presentation/pages/starter_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => StarterBloc(),
        child: StarterPage(),
      ),
      routes: {
        HomePage.id: (context) => HomePage(),
      },
    );
  }
}
