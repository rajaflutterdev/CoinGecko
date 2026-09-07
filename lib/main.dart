import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stu/features/homeScreen/bloc/userBloc.dart';
import 'package:stu/features/homeScreen/presentation/homeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
          providers: getAllProviders(),
          child: HomeScreen())
    );
  }

  ///getAll Provider Class
 List<BlocProvider> getAllProviders(){
    return [
      BlocProvider<UserBloc>(create: (context) => UserBloc(),)
    ];
 }
}


