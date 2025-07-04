import 'package:flutter/material.dart';
import 'package:minhas_series/bd/database_helper.dart';
import 'package:minhas_series/interface_usuario/home_screen.dart';
import 'package:minhas_series/interface_usuario/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final dbHelper = DatabaseHelper();

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, preencha todos os campos.')));
      return;
    }

    final user = await dbHelper.getUser(username, password);

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Usuário ou senha inválidos.'),
          backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.movie_filter_sharp, size: 100),
              const SizedBox(height: 20),
              const Text('Minhas Séries',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              TextField(
                  controller: _usernameController,
                  decoration:
                      const InputDecoration(labelText: 'Usuário', border: OutlineInputBorder())),
              const SizedBox(height: 20),
              TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Senha', border: OutlineInputBorder())),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                  child: const Text('Login'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text('Não tem uma conta? Registre-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}