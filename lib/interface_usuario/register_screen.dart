import 'package:flutter/material.dart';
import 'package:minhas_series/bd/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final dbHelper = DatabaseHelper();

  void _register() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, preencha todos os campos.')));
      return;
    }

    try {
      await dbHelper.createUser(username, password);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Usuário registrado com sucesso!'),
          backgroundColor: Colors.green));
      Navigator.pop(context); 
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Este nome de usuário já existe.'),
            backgroundColor: Colors.red));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao registrar: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Novo Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                    labelText: 'Escolha um nome de usuário', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            TextField(
                controller: _passwordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Crie uma senha', border: OutlineInputBorder())),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                child: const Text('Registrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}