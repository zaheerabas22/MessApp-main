import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messapp/auth/login.dart';

class UserSignupScreen extends StatefulWidget {
  const UserSignupScreen({super.key});

  @override
  State<UserSignupScreen> createState() => _UserSignupScreenState();
}

class _UserSignupScreenState extends State<UserSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _rollno = '';
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  bool _passwordVisible = false;

  // Custom validator for email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.endsWith('@uog.edu.pk')) {
      return 'Email must end with @uog.edu.pk';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Background color
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        reverse: true,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 100),
              const Text(
                'Welcome to Mess App',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Sign Up as Student',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 100),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white, // Background color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your roll no.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _rollno = value!;
                  },
                  decoration: InputDecoration(
                    labelText: 'Roll No.',
                    prefixIcon: Icon(Icons.school),
                    filled: true,
                    fillColor: Colors.white, // Background color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  validator: validateEmail, // Use custom email validator
                  onSaved: (value) {
                    _email = value!;
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    filled: true,
                    fillColor: Colors.white, // Background color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    filled: true,
                    fillColor: Colors.white, // Background color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    suffixIcon: Transform.translate(
                      offset: const Offset(0, -5),
                      child: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() {
                        _isLoading = true;
                      });

                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: _email, password: _password)
                            .then((value) async {
                          CollectionReference users =
                              FirebaseFirestore.instance.collection('users');
                          return await users
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .set({
                            'uid': FirebaseAuth.instance.currentUser!.uid,
                            'name': _name,
                            'rollno': _rollno,
                            'email': _email,
                            'password': _password,
                            'role': 'student',
                          });
                        }).then((value) {
                          // create doc to store attendance for current month for current user
                          CollectionReference attendance = FirebaseFirestore
                              .instance
                              .collection('attendance');
                          attendance.doc().set({
                            'uid': FirebaseAuth.instance.currentUser!.uid,
                            'current_month': DateTime.now().month,
                            'current_year': DateTime.now().year,
                            'data': {
                              '1': {'breakfast': false, 'lunch': false},
                              '2': {'breakfast': false, 'lunch': false},
                              '3': {'breakfast': false, 'lunch': false},
                              '4': {'breakfast': false, 'lunch': false},
                              '5': {'breakfast': false, 'lunch': false},
                              '6': {'breakfast': false, 'lunch': false},
                              '7': {'breakfast': false, 'lunch': false},
                              '8': {'breakfast': false, 'lunch': false},
                              '9': {'breakfast': false, 'lunch': false},
                              '10': {'breakfast': false, 'lunch': false},
                              '11': {'breakfast': false, 'lunch': false},
                              '12': {'breakfast': false, 'lunch': false},
                              '13': {'breakfast': false, 'lunch': false},
                              '14': {'breakfast': false, 'lunch': false},
                              '15': {'breakfast': false, 'lunch': false},
                              '16': {'breakfast': false, 'lunch': false},
                              '17': {'breakfast': false, 'lunch': false},
                              '18': {'breakfast': false, 'lunch': false},
                              '19': {'breakfast': false, 'lunch': false},
                              '20': {'breakfast': false, 'lunch': false},
                              '21': {'breakfast': false, 'lunch': false},
                              '22': {'breakfast': false, 'lunch': false},
                              '23': {'breakfast': false, 'lunch': false},
                              '24': {'breakfast': false, 'lunch': false},
                              '25': {'breakfast': false, 'lunch': false},
                              '26': {'breakfast': false, 'lunch': false},
                              '27': {'breakfast': false, 'lunch': false},
                              '28': {'breakfast': false, 'lunch': false},
                              '29': {'breakfast': false, 'lunch': false},
                              '30': {'breakfast': false, 'lunch': false},
                              '31': {'breakfast': false, 'lunch': false},
                            }
                          }).then((value) {
                            setState(() {
                              _isLoading = false;
                            });

                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const LoginScreen();
                            }));
                          });
                        });
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          _isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.message!),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 55),
                    primary: Colors.blue, // Button color
                    onPrimary: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Sign Up'),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const LoginScreen();
                      }));
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
