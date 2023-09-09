import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messapp/models/attendec_model.dart';
import 'package:messapp/pdf_service.dart';

// void main() {
//   runApp(MaterialApp(
//     home: AttendanceScreen(),
//   ));
// }

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
  @override
  void initState() {
    super.initState();
    generateAttendanceData();
  }

  void generateAttendanceData() {
    attendanceDataList.clear();

    // Determine the number of days in the selected month.
    final daysInMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0).day;

    // Initialize attendance data for the selected month.
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
        title: Text('Attendance'),
        actions: [
          IconButton(
            onPressed: () {
              if (attendanceModelz == null) return;
              PdfInvoiceService.createInvoice(
                attendanceModel: attendanceModelz!,
              ).then((value) {
                PdfInvoiceService.savePdfFile(
                    "file${DateTime.now().millisecond}.pdf", value);
              });
            },
            icon: Icon(Icons.print),
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // get the list of attendance data from firebase
            FutureBuilder(
              // get the list of attendance data from firebase
              future: attendanceCollection
                  .where('current_month', isEqualTo: selectedDate.month)
                  .where('current_year', isEqualTo: selectedDate.year)
                  .where('uid',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data == null) {
                  return Center(child: Text('No data found!!!!'));
                } else if (snapshot.data!.docs.length == 0) {
                  return Center(child: Text('No data found!!!'));
                } else {
                  final AttendanceModel attendanceModel =
                      AttendanceModel.fromJson(snapshot.data!.docs.first.data()
                          as Map<String, dynamic>);
                          attendanceModelz = attendanceModel;
                  final List<DayData> dayDataList = attendanceModel.data;
                  // check how many days  can in current month
                  final daysInMonth =
                      DateTime(DateTime.now().year, DateTime.now().month + 1, 0)
                          .day;
                  // romove the extra days from the list
                  dayDataList
                      .removeWhere((element) => element.day > daysInMonth);
                  return DataTable(
                    columns: [
                      DataColumn(
                        label: Text(
                          'Date',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Breakfast',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
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
                // DataTable(
                //   columns: [
                //     DataColumn(
                //       label: Text(
                //         'Date',
                //         style: TextStyle(fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //     DataColumn(
                //       label: Text(
                //         'Breakfast',
                //         style: TextStyle(fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //     DataColumn(
                //       label: Text(
                //         'Dinner',
                //         style: TextStyle(fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //   ],
                //   columnSpacing: 20.0, // Adjust column spacing
                //   dataRowHeight: 60.0, // Adjust row height
                //   rows: attendanceDataList.map((data) {
                //     return DataRow(
                //       cells: [
                //         DataCell(Text(data.date)),
                //         DataCell(
                //           Checkbox(
                //             value: data.breakfast,
                //             onChanged: (value) {
                //               setState(() {
                //                 data.breakfast = value ?? false;
                //               });
                //             },
                //           ),
                //         ),
                //         DataCell(
                //           Checkbox(
                //             value: data.dinner,
                //             onChanged: (value) {
                //               setState(() {
                //                 data.dinner = value ?? false;
                //               });
                //             },
                //           ),
                //         ),
                //       ],
                //     );
                //   }).toList(),
                // );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pickMonth(context);
        },
        child: Icon(Icons.calendar_today),
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
