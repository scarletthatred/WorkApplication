import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generateDocument(PdfPageFormat format, List<Map<String, dynamic>> items) async {
  final doc = pw.Document();
  final image = pw.MemoryImage(
    (await rootBundle.load('lib/examples/assets/company_logo.png')).buffer
        .asUint8List(),
  );


  final fontRegular = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Roboto-Regular.ttf"));
  final fontBold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Roboto-Bold.ttf"));
  final fontBoldItalic = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Roboto-BoldItalic.ttf"));
  final fontItalic = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Roboto-Italic.ttf"));


  if (items.isEmpty){
    doc.addPage(
        pw.Page(
            theme: pw.ThemeData.withFont(
              base: fontRegular,
              bold: fontBold,
              boldItalic: fontBoldItalic,
              italic: fontItalic,
            ),
            build: (context) =>
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [pw.Text("There are no notes on this day.")]
                )
        )
    );

}
  else{
    for (var item in items) {
      doc.addPage(
        pw.Page(
          theme: pw.ThemeData.withFont(
            base: fontRegular,
            bold: fontBold,
            boldItalic: fontBoldItalic,
            italic: fontItalic,
          ),
          build: (context) =>
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Caller notes: ${item['date']}",
                          style: pw.TextStyle(font: fontBold, fontSize: 16)),
                      pw.Image(image, width: 100, height: 100),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  if(item["callerName"] != "")
                    pw.Text("Caller Name: ${item['callerName'] ?? 'N/A'}",
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  if(item["callerName"] != "")
                    pw.SizedBox(height: 10),
                  if(item["companyName"] != "")
                    pw.Text("Company Name: ${item['companyName'] ?? 'N/A'}",
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  if(item["companyName"] != "")
                    pw.SizedBox(height: 10),
                  if(item["email"] != "")
                    pw.Text("Email: ${item['email'] ?? 'N/A'}",
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  if(item["email"] != "")
                    pw.SizedBox(height: 10),
                  if(item["phoneNumber"] != "")
                    pw.Text("Phone Number: ${item['phoneNumber'] ?? 'N/A'}",
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  if(item["phoneNumber"] != "")
                    pw.SizedBox(height: 10),
                  if(item["date"] != "")
                    pw.Text("Date: ${item['date'] ?? 'N/A'}",
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  if(item["date"] != "")
                    pw.SizedBox(height: 10),
                  pw.Text("Request Or Problem:", style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Text("${item['requestOrProblem'] ?? 'N/A'}",
                      style: const pw.TextStyle(fontSize: 12), softWrap: true),
                ],
              ),
        ),
      );
    }
  }
  return doc.save();
}
