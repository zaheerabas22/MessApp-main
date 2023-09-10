import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:messapp/models/attendec_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'dart:convert';

class PdfInvoiceService {
  // createInvoice();
  static Future<Uint8List> createInvoice({
    required AttendanceModel attendanceModel,
    required String name,
    required String rollNo,
    required String dueDate,
    required String billNo,
  }) async {
    List<DayData> data = attendanceModel.data;
    // get month name from month number
    String monthNameFromMonthNumber = attendanceModel.currentMonth == 1
        ? 'January'
        : attendanceModel.currentMonth == 2
            ? 'February'
            : attendanceModel.currentMonth == 3
                ? 'March'
                : attendanceModel.currentMonth == 4
                    ? 'April'
                    : attendanceModel.currentMonth == 5
                        ? 'May'
                        : attendanceModel.currentMonth == 6
                            ? 'June'
                            : attendanceModel.currentMonth == 7
                                ? 'July'
                                : attendanceModel.currentMonth == 8
                                    ? 'August'
                                    : attendanceModel.currentMonth == 9
                                        ? 'September'
                                        : attendanceModel.currentMonth == 10
                                            ? 'October'
                                            : attendanceModel.currentMonth == 11
                                                ? 'November'
                                                : 'December';
    int totalBreakfast = 0;
    int totalLunch = 0;

    for (int i = 0; i < data.length; i++) {
      if (data[i].breakfast == true) {
        totalBreakfast++;
      }
      if (data[i].lunch == true) {
        totalLunch++;
      }
    }

    int totalBill = ((totalBreakfast) + (totalLunch)) * 300;

    // total count of true in
    final pdf = pw.Document();
    final image =
        (await rootBundle.load("assets/images/logo.png")).buffer.asUint8List();

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.only(
          left: 20.0, right: 20.0, top: 0, bottom: 26.0),
      build: (pw.Context context) {
        return pw.Column(children: [
          pw.SizedBox(height: 50.0),
          pw.Container(
            alignment: pw.Alignment.center,
            child: pw.Text(
              'Smart Mess App',
              style: pw.TextStyle(
                fontSize: 24.0,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 20.0),
          pw.Container(
            alignment: pw.Alignment.center,
            child: pw.Image(
              pw.MemoryImage(image),
            ),
            height: 150,
            width: 150,
          ),
          pw.SizedBox(height: 50.0),
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: PdfColors.black,
              ),
            ),
            height: 50,
            width: 500,
            alignment: pw.Alignment.center,
            child: pw.Text(
              'MESS SERVICE INVOICE',
              style: pw.TextStyle(
                fontSize: 20.0,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: PdfColors.black,
              ),
            ),
            height: 30,
            width: 500,
            alignment: pw.Alignment.center,
            child: pw.Text(
              '$monthNameFromMonthNumber/${attendanceModel.currentYear}',
              style: pw.TextStyle(
                fontSize: 20.0,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Column(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.black,
                    ),
                  ),
                  height: 30,
                  width: 250,
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    'Name',
                    style: const pw.TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            color: PdfColors.black,
                          ),
                        ),
                        padding: const pw.EdgeInsets.all(8.0),
                        height: 30,
                        width: 250,
                        child: pw.Text(
                          name,
                          style: const pw.TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ]),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.black,
                    ),
                  ),
                  height: 30,
                  width: 250,
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    'Rolnmbr',
                    style: const pw.TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColors.black,
                        ),
                      ),
                      padding: const pw.EdgeInsets.all(8.0),
                      height: 30,
                      width: 250,
                      child: pw.Text(
                        rollNo,
                        style: const pw.TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.black,
                    ),
                  ),
                  height: 30,
                  width: 250,
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    'Mess Bill No.',
                    style: const pw.TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColors.black,
                        ),
                      ),
                      padding: const pw.EdgeInsets.all(8.0),
                      height: 30,
                      width: 250,
                      child: pw.Text(
                        billNo,
                        style: const pw.TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.black,
                    ),
                  ),
                  height: 30,
                  width: 250,
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    'Due Date',
                    style: const pw.TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColors.black,
                        ),
                      ),
                      padding: const pw.EdgeInsets.all(8.0),
                      height: 30,
                      width: 250,
                      child: pw.Text(
                        dueDate,
                        style: const pw.TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.black,
                    ),
                  ),
                  height: 30,
                  width: 250,
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    'Fine per Day',
                    style: const pw.TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColors.black,
                        ),
                      ),
                      padding: const pw.EdgeInsets.all(8.0),
                      height: 30,
                      width: 250,
                      child: pw.Text(
                        'Rs.10/-',
                        style: const pw.TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.black,
                    ),
                  ),
                  height: 30,
                  width: 250,
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    'Max Fine/Month',
                    style: const pw.TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColors.black,
                        ),
                      ),
                      padding: const pw.EdgeInsets.all(8.0),
                      height: 30,
                      width: 250,
                      child: pw.Text(
                        'Rs.200/-',
                        style: const pw.TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.black,
                    ),
                  ),
                  height: 30,
                  width: 250,
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    'UNITS CONSUMED',
                    style: const pw.TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColors.black,
                        ),
                      ),
                      padding: const pw.EdgeInsets.all(8.0),
                      height: 30,
                      width: 250,
                      child: pw.Text(
                        (totalBreakfast + totalLunch).toString(),
                        style: const pw.TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.black,
                    ),
                  ),
                  height: 30,
                  width: 250,
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    'Unit Cost',
                    style: const pw.TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColors.black,
                        ),
                      ),
                      padding: const pw.EdgeInsets.all(8.0),
                      height: 30,
                      width: 250,
                      child: pw.Text(
                        '1 unit cost 300',
                        style: const pw.TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.black,
                    ),
                  ),
                  height: 30,
                  width: 250,
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    'Total Bill',
                    style: pw.TextStyle(
                      fontSize: 18.0,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColors.black,
                        ),
                      ),
                      padding: const pw.EdgeInsets.all(8.0),
                      height: 30,
                      width: 250,
                      child: pw.Text(
                        totalBill.toString(),
                        style: const pw.TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ]),
        ]);
      },
    ));

    return pdf.save();
  }

  static Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = html.window.localStorage;
    final dirName = "pdfs";

    if (!output.containsKey(dirName)) {
      output[dirName] = jsonEncode([]);
    }

    final dir = jsonDecode(output[dirName]!);
    final filePath = "$dir/$fileName.pdf";

    final blob = html.Blob([byteList]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..target = 'webbrowser'
      ..download = fileName;

    anchor.click();

    html.Url.revokeObjectUrl(url);
    dir.add(filePath);
    output[dirName] = jsonEncode(dir);
  }
}
