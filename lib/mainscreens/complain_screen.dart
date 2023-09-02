import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:uuid/uuid.dart';

class ComplainScreen extends StatefulWidget {
  const ComplainScreen({super.key});

  @override
  State<ComplainScreen> createState() => _ComplainScreenState();
}

class _ComplainScreenState extends State<ComplainScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text('Complain Portial',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          reverse: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 50),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // compaintion rull and Instruction
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "* Complain should be in formal Tone",
                      ),
                      const Text("* Complain should be in English"),
                      const Text("* Complain should be in 100 words"),
                      const Text("* Complain should be explain in detail"),
                      const Text("* Complain should be in formal Tone"),
                    ],
                  ),
                  // text box for title of Complain(),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _title = value!;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Title',
                      ),
                    ),
                  ),
                  // text box for description of Complain(),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _description = value!;
                      },
                      maxLines: 10,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          height: 50,
          width: double.infinity,
          color: Colors.blue,
          child: ElevatedButton(
            onPressed: () async {
              print('pressed');
              print('pressed');
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                setState(() {
                  _isLoading = true;
                });

                try {
                  CollectionReference complain =
                      FirebaseFirestore.instance.collection('complain');
                  String uid = const Uuid().v4();
                  await complain.doc(uid).set({
                    'sid': FirebaseAuth.instance.currentUser!.uid,
                    'time': DateTime.now(),
                    'title': _title,
                    'description': _description,
                    'uid': uid,
                    'status': 'pending',
                  }).then((value) {
                    _formKey.currentState!.reset();
                    setState(() {
                      _isLoading = false;
                    });
                  });
                } catch (e) {
                  setState(() {
                    _isLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                }
              }
            },
            child: _isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ));
  }
}
