import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'dart:convert';

class PdfInvoiceService {
  // createInvoice();
  static Future<Uint8List> createInvoice() async {
    final pdf = pw.Document();
    // final image =
    //     (await rootBundle.load("assets/images/logo.png")).buffer.asUint8List();
    // final arabicTax =
    //     (await rootBundle.load("assets/images/tax.png")).buffer.asUint8List();

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.only(
          left: 20.0, right: 20.0, top: 0, bottom: 26.0),
      build: (pw.Context context) {
        return pw.Column(children: [
          pw.SizedBox(height: 20.0),
          pw.SizedBox(height: 10.0),
          pw.Container(
            alignment: pw.Alignment.center,
            child: pw.Text(
              'Smart Mess App',
              style: pw.TextStyle(
                fontSize: 18.0,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 20.0),
          pw.Container(
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(
                        color: PdfColors.black,
                      ),
                    ),
                    height: 30,
                    width: 500,
                    child: pw.Text(
                      'Roll Number: 19011519-122',
                      style: const pw.TextStyle(
                        fontSize: 18.0,
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
                    child: pw.Text(
                      'Father Name: Muhammad Iqbal',
                      style: const pw.TextStyle(
                        fontSize: 18.0,
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
                    child: pw.Text(
                      'Roll Number: 19011519-122',
                      style: const pw.TextStyle(
                        fontSize: 18.0,
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
                    child: pw.Text(
                      'Attendance Report: 30%',
                      style: const pw.TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
