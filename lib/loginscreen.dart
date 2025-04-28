import 'package:flutter/material.dart';
import 'package:schemes/registration.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart'; // Assuming SchemesScreen is here

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obscurePassword = true;

  void _login() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');
    final category = prefs.getString('category');

    final inputEmail = _email.text.trim();
    final inputPassword = _password.text.trim();

    if (inputEmail == savedEmail && inputPassword == savedPassword) {
      await prefs.setBool('loggedIn', true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SchemesScreen(
                  category: category,
                )),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid email or password")),
      );
    }
  }

  InputDecoration _inputDecoration(String hint, [Widget? suffix]) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      suffixIcon: suffix,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome Back! 👋",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text("Login to continue",
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
                SizedBox(height: 24),

                // Email Field
                Text("Email"),
                SizedBox(height: 4),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration("Enter your email"),
                  validator: (value) =>
                      value!.isEmpty ? "Email is required" : null,
                ),

                SizedBox(height: 16),

                // Password Field
                Text("Password"),
                SizedBox(height: 4),
                TextFormField(
                  controller: _password,
                  obscureText: _obscurePassword,
                  decoration: _inputDecoration(
                    "Enter your password",
                    IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () => setState(() {
                        _obscurePassword = !_obscurePassword;
                      }),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Password is required" : null,
                ),

                SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _login();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("Login",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => RegistrationForm()));
                    },
                    child: Text("Don't have an account? Register"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
