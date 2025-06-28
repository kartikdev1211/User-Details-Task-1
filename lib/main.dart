import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_details/bloc/user_bloc.dart';
import 'package:user_details/bloc/user_event.dart';
import 'package:user_details/repo/user_repo.dart';
import 'package:user_details/screens/user_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MyApp(repository: UserRepo(),));
}

class MyApp extends StatelessWidget {
  final UserRepo repository;
  const MyApp({super.key, required this.repository});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Details App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: RepositoryProvider.value(value: repository,child: BlocProvider(create: (_)=>UserBloc(repository)..add( LoadUser()),child: UserScreen(),),),
    );
  }
}
