
import 'package:flutter/material.dart';
import 'package:minhas_series/interface_usuario/login_screen.dart'; 

void main() {
  
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minhas Séries',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
       
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
        ),
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}