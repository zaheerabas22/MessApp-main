import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AdminComplain extends StatefulWidget {
  const AdminComplain({super.key});

  @override
  State<AdminComplain> createState() => _AdminComplainState();
}

class _AdminComplainState extends State<AdminComplain> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('complain').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No Products Found\n\n in this Category',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    leading:
                        Text("$index", style: const TextStyle(fontSize: 20)),
                    title: Text(snapshot.data!.docs[index]['title']),
                    subtitle: Text(snapshot.data!.docs[index]['description']),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),
                    )
                    // subtitle: Text(data[index]),
                    ),
              );
            },
          );
        });
  }
}
