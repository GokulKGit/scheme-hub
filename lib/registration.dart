import 'package:flutter/material.dart';
import 'package:schemes/loginscreen.dart';
import 'package:schemes/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkLoginStatus(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return snapshot.data == true
            ? SchemesScreen(
                category: "students_schemes",
              )
            : RegistrationForm();
      },
    );
  }
}

class RegistrationForm extends StatefulWidget {
  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _query = TextEditingController();
  final TextEditingController _aadhar = TextEditingController();
  final TextEditingController _pan = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _password = TextEditingController();

  String selectedCategory = "students_schemes"; // Default category
  final List<String> categories = [
    "students_schemes",
    "farmers_schemes",
    "unemployment_schemes",
    "girls_schemes",
    "boys_schemes",
    "sports_schemes"
  ];

  bool _obscurePassword = true;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', _name.text);
      await prefs.setString('email', _email.text);
      await prefs.setString('mobile', _mobile.text);
      await prefs.setString('age', _age.text);
      await prefs.setString('category',
          selectedCategory.replaceAll("_schemes", "").toUpperCase());
      await prefs.setString('aadhar', _aadhar.text);
      await prefs.setString('pan', _pan.text);
      await prefs.setString('password', _password.text);
      await prefs.setBool('loggedIn', true); // maintain session

      // Navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => SchemesScreen(
                  category: selectedCategory,
                )),
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
                Text("Hi, Welcome Back! 👋",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text("Hello again, you’ve been missed!",
                    style: TextStyle(color: Colors.grey)),
                SizedBox(height: 24),
                _label("Name"),
                _field(_name, "Please Enter Your Name"),
                _label("Email"),
                _field(_email, "Please Enter Your Email"),
                _label("Password"),
                TextFormField(
                  controller: _password,
                  obscureText: _obscurePassword,
                  decoration: _inputDecoration(
                    "Enter Your Password",
                    IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) =>
                      value!.length < 6 ? "Password too short" : null,
                ),
                SizedBox(
                  height: 2,
                ),
                _label("Selcet Your Category"),
                InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      isExpanded: true,
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(
                            category.replaceAll("_schemes", "").toUpperCase(),
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedCategory = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          _label("Age"),
                          _field(_age, "Enter Age", type: TextInputType.number),
                        ])),
                    SizedBox(width: 16),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          _label("Mobile Number"),
                          _field(_mobile, "Enter Number",
                              type: TextInputType.phone),
                        ])),
                  ],
                ),
                _label("Search Query"),
                _field(_query, "Please enter query", lines: 3),
                _label("Aadhar Card"),
                _field(_aadhar, "Enter Aadhar"),
                Row(
                  children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          _label("PAN Card"),
                          _field(_pan, "Enter PAN"),
                        ])),
                  ],
                ),
                _label("Address"),
                _field(_address, "Enter Address", lines: 2),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text("Register",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Already have a account? ",
                        style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                      ),
                      GestureDetector(
                        child: Text(
                          "Login",
                          style:
                              TextStyle(color: Colors.deepPurple, fontSize: 18),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 4),
        child: Text(text),
      );

  Widget _field(TextEditingController controller, String hint,
      {int lines = 1, TextInputType type = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      maxLines: lines,
      keyboardType: type,
      decoration: _inputDecoration(hint),
      validator: (value) => value!.isEmpty ? 'Required' : null,
    );
  }
}
