import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messapp/mainscreens/SignUpSelectionScreem.dart';
import 'package:messapp/mainscreens/adminhome.dart';
import 'package:messapp/mainscreens/userhome.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _passwordVisible = false; // Track password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Background color
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Transform.translate(
                  offset: const Offset(0, -50),
                  child: const Text(
                    'Welcome to Mess App',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/logo.png', // Replace with the actual path to your logo image
                  width: 150, // Set the width of the logo as needed
                  height: 150, // Set the height of the logo as needed
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!value.contains('@uog.edu.pk')) {
                      return 'Invalid email format';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white, // Background color
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(height: 20),
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
                  obscureText: !_passwordVisible, // Toggle password visibility
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    filled: true,
                    fillColor: Colors.white, // Background color
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.blue),
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
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')),
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
                            if (documentSnapshot.exists) {
                              Map<String, dynamic> data = documentSnapshot
                                  .data() as Map<String, dynamic>;

                              if (data['role'] == 'student') {
                                //check if user is student have attendance of current month
                                CollectionReference attendance =
                                    FirebaseFirestore.instance
                                        .collection('attendance');
                                // where user id is equal to current user id and month is equal to current month
                                attendance
                                    .where('uid',
                                        isEqualTo: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .where('current_month',
                                        isEqualTo: DateTime.now().month)
                                    .where('current_year',
                                        isEqualTo: DateTime.now().year)
                                    .get()
                                    .then((value) {
                                  if (value.docs.isEmpty) {
                                    // create attendance for current month
                                    CollectionReference attendance =
                                        FirebaseFirestore.instance
                                            .collection('attendance');
                                    attendance.doc().set({
                                      'uid': FirebaseAuth
                                          .instance.currentUser!.uid,
                                      'current_month': DateTime.now().month,
                                      'current_year': DateTime.now().year,
                                      'data': {
                                        '1': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '2': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '3': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '4': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '5': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '6': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '7': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '8': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '9': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '10': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '11': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '12': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '13': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '14': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '15': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '16': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '17': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '18': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '19': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '20': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '21': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '22': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '23': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '24': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '25': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '26': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '27': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '28': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '29': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '30': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                        '31': {
                                          'breakfast': false,
                                          'lunch': false
                                        },
                                      }
                                    });
                                  }
                                });

                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return UserHomeScreen();
                                }));
                              } else
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return AdminHomeScreen();
                                }));
                            } else {
                              print('Document does not exist in the database');
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
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Center(
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    primary: Colors.blue, // Button color
                    onPrimary: Colors.white, // Text color
                    minimumSize: Size(150, 50),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SignUpSelectionScreen();
                        }));
                      },
                      child: Text(
                        'Sign Up',
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
      ),
    );
  }
}
