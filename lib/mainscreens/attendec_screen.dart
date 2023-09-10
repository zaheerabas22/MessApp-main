import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messapp/models/attendec_model.dart';
import 'package:messapp/pdf_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime selectedDate = DateTime.now();
  List<AttendanceData> attendanceDataList = [];
  AttendanceModel? attendanceModelz;
  CollectionReference attendanceCollection =
      FirebaseFirestore.instance.collection('attendance');
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  dynamic user;
  @override
  void initState() {
    super.initState();
    generateAttendanceData();
  }

  void generateAttendanceData() {
    attendanceDataList.clear();

    final daysInMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0).day;

    for (int day = 1; day <= daysInMonth; day++) {
      final formattedDate = DateFormat('dd/MMMM/yyyy')
          .format(DateTime(selectedDate.year, selectedDate.month, day));
      attendanceDataList.add(
          AttendanceData(date: formattedDate, breakfast: false, dinner: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        actions: [
          IconButton(
            onPressed: () async {
              if (attendanceModelz == null) return;

              await userCollection
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .get()
                  .then((value) async {
                user = value.data() as Map<dynamic, dynamic>;
                print(user['name']);
                await PdfInvoiceService.createInvoice(
                  attendanceModel: attendanceModelz!,
                  name: user['name'],
                  rollNo: user['rollno'],
                  dueDate: // DateFormat('dd/MMMM/yyyy').format(DateTime.now()+),
                      DateFormat('dd/MMMM/yyyy')
                          .format(DateTime.now().add(const Duration(days: 7))),
                  billNo: "ZWRRS${DateTime.now().millisecond}",
                ).then((value) {
                  PdfInvoiceService.savePdfFile(
                      "file${DateTime.now().millisecond}.pdf", value);
                });
              });
            },
            icon: const Icon(Icons.print),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                DateFormat('MMMM yyyy').format(selectedDate),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            FutureBuilder(
              future: attendanceCollection
                  .where('current_month', isEqualTo: selectedDate.month)
                  .where('current_year', isEqualTo: selectedDate.year)
                  .where('uid',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data == null) {
                  return const Center(child: Text('No data found!!!!'));
                } else if (snapshot.data!.docs.length == 0) {
                  return const Center(child: Text('No data found!!!'));
                } else {
                  final AttendanceModel attendanceModel =
                      AttendanceModel.fromJson(snapshot.data!.docs.first.data()
                          as Map<String, dynamic>);
                  attendanceModelz = attendanceModel;
                  final List<DayData> dayDataList = attendanceModel.data;
                  final daysInMonth =
                      DateTime(DateTime.now().year, DateTime.now().month + 1, 0)
                          .day;
                  dayDataList
                      .removeWhere((element) => element.day > daysInMonth);
                  return DataTable(
                    columns: [
                      const DataColumn(
                        label: Text(
                          'Date',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          'Breakfast',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          'Dinner',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    columnSpacing: 20.0, // Adjust column spacing
                    dataRowHeight: 60.0, // Adjust row height
                    rows: dayDataList.map((data) {
                      return DataRow(
                        cells: [
                          DataCell(Text(
                              "${data.day}/${attendanceModel.currentMonth}/${attendanceModel.currentYear}")),
                          DataCell(
                            Checkbox(
                              fillColor: MaterialStateProperty.all(
                                data.day < DateTime.now().day
                                    ? Colors.grey
                                    : Colors.blue,
                              ),
                              value: data.breakfast,
                              onChanged: (value) {
                                //Update the value of breakfast in firebase
                                if (data.day < DateTime.now().day) return;
                                attendanceCollection
                                    .doc(snapshot.data!.docs.first.id)
                                    .update({
                                  'data.${data.day}.breakfast': value ?? false,
                                });
                                setState(() {});
                              },
                            ),
                          ),
                          DataCell(
                            Checkbox(
                              fillColor: MaterialStateProperty.all(
                                data.day < DateTime.now().day
                                    ? Colors.grey
                                    : Colors.blue,
                              ),
                              value: data.lunch,
                              onChanged: (value) {
                                //Update the value of lunch in firebase
                                if (data.day < DateTime.now().day) return;
                                attendanceCollection
                                    .doc(snapshot.data!.docs.first.id)
                                    .update({
                                  'data.${data.day}.lunch': value ?? false,
                                });
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pickMonth(context);
        },
        child: const Icon(Icons.calendar_today),
      ),
    );
  }

  Future<void> pickMonth(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        generateAttendanceData();
      });
    }
  }
}

class AttendanceData {
  final String date;
  bool breakfast;
  bool dinner;

  AttendanceData(
      {required this.date, this.breakfast = false, this.dinner = false});
}
