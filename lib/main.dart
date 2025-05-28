import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'home_page.dart';
import 'video_uploader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('videos');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mo Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.dark(
          primary: Colors.deepPurpleAccent,
          secondary: Colors.deepPurpleAccent,
        ),
        appBarTheme: AppBarTheme(backgroundColor: Colors.black),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => LoginPage(),
        '/home': (_) => HomePage(),
        '/upload': (_) => VideoUploader(),
      },
    );
  }
}

/// Simple Login / Signup page included here.
/// You can split this into login_page.dart if you prefer.
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _isLogin = true;

  Future<void> _login() async {
    final prefs = await Hive.openBox('prefs');
    final savedEmail = prefs.get('email') as String? ?? '';
    final savedPass = prefs.get('password') as String? ?? '';
    if (_email.text == savedEmail && _pass.text == savedPass) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed.')),
      );
    }
  }

  Future<void> _signup() async {
    final prefs = await Hive.openBox('prefs');
    await prefs.put('email', _email.text);
    await prefs.put('password', _pass.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Signup successful!')),
    );
    setState(() => _isLogin = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  _isLogin ? 'Login to Mo Hub' : 'Sign Up for Mo Hub',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                SizedBox(height: 24),
                TextField(
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _pass,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLogin ? _login : _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white10,
                  ),
                  child: Text(_isLogin ? 'Login' : 'Sign Up'),
                ),
                TextButton(
                  onPressed: () => setState(() => _isLogin = !_isLogin),
                  child: Text(
                    _isLogin
                        ? "Don't have an account? Sign Up"
                        : "Already have an account? Login",
                    style: TextStyle(color: Colors.greenAccent),
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
