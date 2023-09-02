import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:messapp/mainscreens/inventory.dart';

import '../auth/login.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({super.key});

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                YNDialog(
                    context,
                    'Logout',
                    'Are you sure you want to logout?',
                    () {
                      Navigator.pop(context);
                    },
                    'No',
                    () async {
                      await FirebaseAuth.instance.signOut();

                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    'Yes');
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
            ),
          ],
          backgroundColor: Colors.white,
          title: const Text(
            'Account Info',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: FutureBuilder<DocumentSnapshot>(
            future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return Text("Document does not exist");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['role'].toString().toUpperCase(),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      data['role'].toString() == "student"
                          ? Text(
                              data['rollno'].toString().toUpperCase(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            )
                          : Container(),
                      Text(
                        data['name'].toString().toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        data['email'],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Visibility(
                        visible: data['role'] ==
                            'admin', // Show the button only if the user is an Admin
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const InventoryManagementScreen(),
                              ),
                            );
                          },
                          child: const Text('Manage Inventory'),
                        ),
                      )
                    ],
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator());
            }));
  }
}

Future<dynamic> YNDialog(
    BuildContext context,
    String heading1,
    String subheading,
    Function() onPressedN,
    String noptionLable,
    Function() onPressedY,
    String yoptionLable) {
  return showDialog(
      context: context,
      builder: (contextx) {
        return AlertDialog(
          title: Text(heading1),
          content: Text(subheading),
          actions: [
            TextButton(onPressed: onPressedN, child: Text(noptionLable)),
            TextButton(onPressed: onPressedY, child: Text(yoptionLable)),
          ],
        );
      });
}
