import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class EditMenuScreen extends StatefulWidget {
  const EditMenuScreen({super.key});

  @override
  State<EditMenuScreen> createState() => _EditMenuScreenState();
}

class _EditMenuScreenState extends State<EditMenuScreen> {
  List days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  List Monday = ["", ""];
  List Tuesday = ["", ""];
  List Wednesday = ["", ""];
  List Thursday = ["", ""];
  List Friday = ["", ""];
  List Saturday = ["", ""];
  List Sunday = ["", ""];
  final Function(String) valuez = (value) {
    print(value);
  };

  final heading = "Mess Menu";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    CollectionReference menu = FirebaseFirestore.instance.collection('menu');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Menu'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: menu.limit(1).get().then((querySnapshot) {
          return menu.doc(querySnapshot.docs.first.id).get();
        }),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    EditMenuWidget(
                      heading: days[0],
                      child1: FieldWidget1(
                        valuez: (value) {
                          Monday[0] = value;
                        },
                        preData: data[days[0].toString().toLowerCase()][0],
                      ),
                      child2: FieldWidget2(
                        valuez: (value) {
                          Monday[1] = value;
                        },
                        preData: data[days[0].toString().toLowerCase()][1],
                      ),
                    ),
                    EditMenuWidget(
                      heading: days[1],
                      child1: FieldWidget1(
                        valuez: (value) {
                          Tuesday[0] = value;
                        },
                        preData: data[days[1].toString().toLowerCase()][0],
                      ),
                      child2: FieldWidget2(
                        valuez: (value) {
                          Tuesday[1] = value;
                        },
                        preData: data[days[1].toString().toLowerCase()][1],
                      ),
                    ),
                    EditMenuWidget(
                      heading: days[2],
                      child1: FieldWidget1(
                        valuez: (value) {
                          Wednesday[0] = value;
                        },
                        preData: data[days[2].toString().toLowerCase()][0],
                      ),
                      child2: FieldWidget2(
                        valuez: (value) {
                          Wednesday[1] = value;
                        },
                        preData: data[days[2].toString().toLowerCase()][1],
                      ),
                    ),
                    EditMenuWidget(
                      heading: days[3],
                      child1: FieldWidget1(
                        valuez: (value) {
                          Thursday[0] = value;
                        },
                        preData: data[days[3].toString().toLowerCase()][0],
                      ),
                      child2: FieldWidget2(
                        valuez: (value) {
                          Thursday[1] = value;
                        },
                        preData: data[days[3].toString().toLowerCase()][1],
                      ),
                    ),
                    EditMenuWidget(
                      heading: days[4],
                      child1: FieldWidget1(
                        valuez: (value) {
                          Friday[0] = value;
                        },
                        preData: data[days[4].toString().toLowerCase()][0],
                      ),
                      child2: FieldWidget2(
                        valuez: (value) {
                          Friday[1] = value;
                        },
                        preData: data[days[4].toString().toLowerCase()][1],
                      ),
                    ),
                    EditMenuWidget(
                      heading: days[5],
                      child1: FieldWidget1(
                        valuez: (value) {
                          Saturday[0] = value;
                        },
                        preData: data[days[5].toString().toLowerCase()][0],
                      ),
                      child2: FieldWidget2(
                        valuez: (value) {
                          Saturday[1] = value;
                        },
                        preData: data[days[5].toString().toLowerCase()][1],
                      ),
                    ),
                    EditMenuWidget(
                      heading: days[6],
                      child1: FieldWidget1(
                        valuez: (value) {
                          Sunday[0] = value;
                        },
                        preData: data[days[6].toString().toLowerCase()][0],
                      ),
                      child2: FieldWidget2(
                        valuez: (value) {
                          Sunday[1] = value;
                        },
                        preData: data[days[6].toString().toLowerCase()][1],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Processing Data'),
                            ),
                          );
                          await menu.doc(snapshot.data!.id).update({
                            "monday": Monday,
                            "tuesday": Tuesday,
                            "wednesday": Wednesday,
                            "thursday": Thursday,
                            "friday": Friday,
                            "saturday": Saturday,
                            "sunday": Sunday,
                          }).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Data Saved'),
                              ),
                            );
                          });
                          // Process data.
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Text("loading");
        },
      ),
    );
  }
}

class FieldWidget2 extends StatelessWidget {
  const FieldWidget2({
    Key? key,
    required this.valuez,
    required this.preData,
  }) : super(key: key);

  final Function(String? p1) valuez;
  final String preData;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: preData,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      onSaved: valuez,
      decoration: const InputDecoration(
        hintText: 'Second Time Menu',
        labelText: 'Second Time Menu',
      ),
    );
  }
}

class FieldWidget1 extends StatelessWidget {
  const FieldWidget1({
    Key? key,
    required this.valuez,
    required this.preData,
  }) : super(key: key);

  final Function(String? p1) valuez;
  final String preData;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: preData,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      onSaved: valuez,
      decoration: const InputDecoration(
        hintText: 'First Time Menu',
        labelText: 'First Time Menu',
      ),
    );
  }
}

class EditMenuWidget extends StatelessWidget {
  const EditMenuWidget({
    Key? key,
    required this.heading,
    required this.child1,
    required this.child2,
  }) : super(key: key);

  final String heading;
  final Widget child1;
  final Widget child2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(heading,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              child1,
              child2
            ],
          ),
        ),
      ),
    );
  }
}
