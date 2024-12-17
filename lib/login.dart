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
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    // Email validation
    String email = _emailController.text;
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email format')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    var url = Uri.parse("http://192.168.1.5/smartstock_app/backend/login.php");

    try {
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
        // If login failed, show the error message in the snack bar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Login Failed')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle network error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo image
                Image.asset(
                  'assets/smart_log.png', 
                  height: 150, 
                  width: 150,
                ),
                SizedBox(height: 40),

                // Email field with rounded corners and shadow
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.blueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    prefixIcon: Icon(Icons.email, color: Colors.blueAccent),
                    filled: true,
                    fillColor: Colors.blueGrey[50],
                  ),
                ),
                SizedBox(height: 16),

                // Password field with rounded corners and shadow
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.blueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.blueAccent),
                    filled: true,
                    fillColor: Colors.blueGrey[50],
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 32),

                // Login button with modern design
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _login,
                        child: Text('Login', style: TextStyle(fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                      ),
                SizedBox(height: 20),

                // "Forgot password" link styled with subtle underlining
                TextButton(
                  onPressed: () {
                    // Placeholder for forgot password functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Forgot password feature')),
                    );
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
