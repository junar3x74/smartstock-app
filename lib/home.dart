import 'package:flutter/material.dart';
import 'products.dart';
import 'login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variables to hold user data
  String userName = '';
  String userEmail = '';
  bool isActive = false;
  bool isLoading = true; // Track loading state

  // Fetch user profile data
  Future<void> fetchUserProfile() async {
    var url = Uri.parse('http://192.168.1.5/smartstock_app/backend/login.php'); // Update with your correct API URL

    try {
      var response = await http.post(url, body: {
        'email': 'user@example.com', // Example email, replace with actual login flow
        'password': 'password', // Example password, replace with actual login flow
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['success']) {
          setState(() {
            userName = data['user']['name'];  // Fetch name from the user object
            userEmail = data['user']['email']; // Fetch email from the user object
            isActive = data['user']['is_active'] == 1;
            isLoading = false;
          });
        } else {
          // Handle error returned by the backend
          showErrorSnackBar('Error: ${data['message']}');
        }
      } else {
        // Handle non-200 status code
        showErrorSnackBar('Failed to load profile. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions (e.g., network issues)
      showErrorSnackBar('Network error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Helper function to show error messages as a snackbar
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUserProfile(); // Fetch user profile data on page load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient AppBar
      appBar: AppBar(
        title: Text('SmartStock Home'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      // Drawer for Sidebar Navigation
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(userName.isEmpty ? "Loading..." : userName),
                accountEmail: Text(userEmail.isEmpty ? "Loading..." : userEmail),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.account_circle, color: Colors.blueAccent, size: 50),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.lightBlueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              _buildDrawerItem(Icons.home, 'Home', () {
                Navigator.pop(context);
              }),
              _buildDrawerItem(Icons.shop, 'View Products', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProductPage()));
              }),
              _buildDrawerItem(Icons.exit_to_app, 'Logout', () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }),
            ],
          ),
        ),
      ),

      // Main Content with Loading State and Gradient Background
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[50]!, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo
                      Image.asset(
                        'assets/smart_log.png',
                        height: 150,
                      ),
                      SizedBox(height: 30),

                      // Welcome Text
                      Text(
                        'Welcome to SmartStock',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),

                      // Description Text
                      Text(
                        'Manage your inventory efficiently and keep track of your products with ease.',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 40),

                      // View Products Button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProductPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                          shadowColor: Colors.blueAccent,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shopping_cart, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              'View Products',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // Helper function to build Drawer items
  ListTile _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
      onTap: onTap,
    );
  }
}
