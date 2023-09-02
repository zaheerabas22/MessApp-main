import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MessMenuUserScreen extends StatefulWidget {
  const MessMenuUserScreen({super.key});

  @override
  State<MessMenuUserScreen> createState() => _MessMenuUserScreenState();
}

class _MessMenuUserScreenState extends State<MessMenuUserScreen> {
  final heading = "Mess Menu";
  Future<String> getDocumentId() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('menu').get();

    return snapshot.docs.first.id;
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference menu = FirebaseFirestore.instance.collection('menu');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Mess Menu'),
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
              return Table(
                columnWidths: const <int, TableColumnWidth>{
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  TableRow(
                    children: <Widget>[
                      ColumnHeading(heading: 'Day'),
                      ColumnHeading(heading: 'First Time menu'),
                      ColumnHeading(heading: 'Second Time menu'),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      ColumnData(data: 'Monday', value: 1),
                      ColumnData(data: data['monday'][0], value: 1),
                      ColumnData(data: data['monday'][1], value: 1),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      ColumnData(data: 'Tuesday', value: 0),
                      ColumnData(data: data['tuesday'][0], value: 0),
                      ColumnData(data: data['tuesday'][1], value: 0),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      ColumnData(data: 'Wednesday', value: 1),
                      ColumnData(data: data['wednesday'][0], value: 1),
                      ColumnData(data: data['wednesday'][1], value: 1),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      ColumnData(data: 'Thursday', value: 0),
                      ColumnData(data: data['thursday'][0], value: 0),
                      ColumnData(data: data['thursday'][1], value: 0),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      ColumnData(data: 'Friday', value: 1),
                      ColumnData(data: data['friday'][0], value: 1),
                      ColumnData(data: data['friday'][1], value: 1),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      ColumnData(data: 'Saturday', value: 0),
                      ColumnData(data: data['saturday'][0], value: 0),
                      ColumnData(data: data['saturday'][1], value: 0),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      ColumnData(data: 'Sunday', value: 1),
                      ColumnData(data: data['sunday'][0], value: 1),
                      ColumnData(data: data['sunday'][1], value: 1),
                    ],
                  ),
                ],
              );
            }

            return Text("loading");
          },
        ));
  }
}

class ColumnHeading extends StatelessWidget {
  const ColumnHeading({
    Key? key,
    required this.heading,
  }) : super(key: key);

  final String heading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: 50,
      color: Colors.grey[300],
      child: Center(
        child: Text(
          heading,
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ColumnData extends StatelessWidget {
  const ColumnData({
    Key? key,
    required this.data,
    required this.value,
  }) : super(key: key);

  final String data;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      color: value == 0 ? Colors.grey[300] : Colors.white,
      height: MediaQuery.of(context).size.height * 0.11,
      child: Text(
        data,
        textAlign: TextAlign.center,
      ),
    );
  }
}
