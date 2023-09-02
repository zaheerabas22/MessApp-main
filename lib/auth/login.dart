import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:messapp/mainscreens/SignUpSelectionScreem.dart';
import 'package:messapp/mainscreens/adminhome.dart';
import 'package:messapp/mainscreens/userhome.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      reverse: true,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            const Text(
              'Welcome to Mess App',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Login ',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              onSaved: (value) {
                _email = value!;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              onSaved: (value) {
                _password = value!;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            Row(
              children: [
                const Text("Don't have an account?"),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SignUpSelectionScreen();
                    }));
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                  try {
                    await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _email, password: _password)
                        .then((value) {
                      CollectionReference users =
                          FirebaseFirestore.instance.collection('users');
                      users
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get()
                          .then((DocumentSnapshot documentSnapshot) {
                        print(documentSnapshot.data());
                        if (documentSnapshot.exists) {
                          Map<String, dynamic> data =
                              documentSnapshot.data() as Map<String, dynamic>;
                          print(data['role']);
                          data['role'] == 'student'
                              ? Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                  return const UserHomeScreen();
                                }))
                              : Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                  return const AdminHomeScreen();
                                }));
                        } else {
                          print('Document does not exist on the database');
                        }
                      });
                    });
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.message!)),
                    );
                  }
                }
              },
              child: const Text('Login'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 35),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
