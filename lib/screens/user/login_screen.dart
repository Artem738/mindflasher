import 'package:flutter/material.dart';
import 'package:mindflasher/providers/user_provider.dart';
import 'package:mindflasher/system/validation_exception.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Map<String, dynamic>? _validationErrors;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Provider.of<UserProvider>(context, listen: false).login(
          _emailController.text,
          _passwordController.text,
        );
        Navigator.of(context).pushReplacementNamed('/deck');
      } catch (error) {
        if (error is ValidationException) {
          setState(() {
            _validationErrors = error.errors;
          });
        } else {
          print(error.toString());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: _validationErrors != null ? _validationErrors!['email']?.join(', ') : null,
                ),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: _validationErrors != null ? _validationErrors!['password']?.join(', ') : null,
                ),
                obscureText: true,
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/register');
                },
                child: Text('Don\'t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
