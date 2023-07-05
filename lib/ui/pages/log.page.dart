import 'package:appfres/db/DatabaseHelper.dart';
import 'package:appfres/ui/pages/home.page.dart';
import 'package:appfres/widgets/loading.indicator.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final isAuthenticated = await _databaseHelper.authenticateUser(
      username,
      password,
    );

    if (isAuthenticated) {
      LoadingIndicatorDialog().show(context);
      LoadingIndicatorDialog().dismiss();
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const HomePage()));
      // L'utilisateur est authentifié, faites quelque chose ici (par exemple, naviguer vers une autre page)
    } else {
      // L'authentification a échoué, affichez un message d'erreur ou effectuez une autre action
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
