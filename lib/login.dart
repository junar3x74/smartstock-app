import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Login function that sends HTTP POST request to the server
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    var url = Uri.parse(
        "http://192.168.1.2/smartstock_app/backend/login.php"); // Update with your server IP

    var response = await http.post(url, body: {
      'email': _emailController.text,
      'password': _passwordController.text,
    });

    setState(() {
      _isLoading = false;
    });

    var result = json.decode(response.body);

    if (result['success']) {
      // If login is successful, navigate to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // If login failed, show a snack bar with error message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login Failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo image
              Image.asset(
                'assets/smart_log.png', // Ensure the logo image is in the 'assets' folder
                height: 150, // Adjust as per your logo size
                width: 150,
              ),
              SizedBox(height: 40),

              // Email field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 16),

              // Password field
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 32),

              // Login button
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        backgroundColor: Colors.blue, // Replaces 'primary'
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
