// lib/screen/login/login_form.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the_cafeteria_app/screen/student_and_lecturer/food_stall_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginStudent extends StatefulWidget {
  const LoginStudent({super.key});

  @override
  State<LoginStudent> createState() => _LoginStudentState();
}

class _LoginStudentState extends State<LoginStudent> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _error;

  void _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      final userDoc = await FirebaseFirestore.instance
          .collection('student')
          .doc(email)
          .get();

      if (!userDoc.exists) {
        await _auth.signOut();
        throw FirebaseAuthException(
          code: 'unauthorized',
          message: 'This account is not a student account.',
        );
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => FoodStallList()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (_error != null) ...[
              SizedBox(height: 10),
              Text(_error!, style: TextStyle(color: Colors.red)),
            ],
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}

class LoginLecturer extends StatefulWidget {
  const LoginLecturer({super.key});

  @override
  State<LoginLecturer> createState() => _LoginLecturerState();
}

class _LoginLecturerState extends State<LoginLecturer> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _error;

  void _login() async {
  setState(() {
    _isLoading = true;
    _error = null;
  });

  try {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userDoc = await FirebaseFirestore.instance
        .collection('lecturer')
        .doc(email)
        .get();

    if (!userDoc.exists) {
      await _auth.signOut();
      throw FirebaseAuthException(
        code: 'unauthorized',
        message: 'This account is not a lecturer account.',
      );
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => FoodStallList()),
    );
  } on FirebaseAuthException catch (e) {
    setState(() {
      _error = e.message;
    });
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lecturer Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (_error != null) ...[
              SizedBox(height: 10),
              Text(_error!, style: TextStyle(color: Colors.red)),
            ],
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}

class LoginStaff extends StatefulWidget {
  const LoginStaff({super.key});

  @override
  State<LoginStaff> createState() => _LoginStaffState();
}


class _LoginStaffState extends State<LoginStaff> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _error;

  void _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final email = _emailController.text.trim();
      DocumentSnapshot staffDoc = await FirebaseFirestore.instance
          .collection('staff')
          .doc(email)
          .get();

      if (!staffDoc.exists) {
        throw FirebaseAuthException(
          code: 'not-found',
          message: 'Staff record not found in Firestore.',
        );
      }

      String stallId = staffDoc.get('stall');

      Navigator.pushReplacementNamed(
        context,
        '/staff-orders',
        arguments: stallId,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Staff Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (_error != null) ...[
              SizedBox(height: 10),
              Text(_error!, style: TextStyle(color: Colors.red)),
            ],
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}
