
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


Future<Uint8List> generateDocument(PdfPageFormat format, List<Map<String, dynamic>> items) async {
  items.sort((a, b) => (a['Company'] ?? "").compareTo(b['Company'] ?? ""));  // Ensure sorting

  final doc = pw.Document();
  final image = pw.MemoryImage(
    (await rootBundle.load('lib/images/turnkeyLogo.png')).buffer.asUint8List(),
  );
  final fontRegular = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Roboto-Regular.ttf"));
  final fontBold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Roboto-Bold.ttf"));
  final fontBoldItalic = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Roboto-BoldItalic.ttf"));
  final fontItalic = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Roboto-Italic.ttf"));


  doc.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(
          base: fontRegular,
          bold: fontBold,
          boldItalic: fontBoldItalic,
          italic: fontItalic,
        ),
        build: (context) => [
          pw.Container(
            alignment: pw.Alignment.topLeft,
            child: pw.Image(image, width: 100, height: 100),
          ),


          pw.Paragraph(text: "Contacts Listed By Company:"),
          pw.Table.fromTextArray(

            cellAlignment: pw.Alignment.centerLeft,
            cellStyle: const pw.TextStyle(fontSize: 10),
            headerAlignment: pw.Alignment.center,
            cellHeight: 30,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.centerLeft,
              3: pw.Alignment.centerLeft,
            },
            border: const pw.TableBorder(
              top: pw.BorderSide(color: PdfColors.black,width: .5),
              bottom: pw.BorderSide(color: PdfColors.black,width: .5),
              left: pw.BorderSide(color: PdfColors.black,width: .5),
              right: pw.BorderSide(color: PdfColors.black,width: .5),
              horizontalInside: pw.BorderSide(color: PdfColors.black,width: .5), // Horizontal borders inside the table
              verticalInside: pw.BorderSide(color: PdfColors.black,width: .5), // Vertical borders inside the table
            ),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headers: ['Company', 'Contact Name', 'Phone Number','Email'],
            columnWidths: const {
              0: pw.FixedColumnWidth(150),
              1: pw.FixedColumnWidth(100),
              2: pw.FlexColumnWidth(100),
              3: pw.FlexColumnWidth(150),
            },
            data: items.map((item) => [
              item['Company'] ?? "N/A",
              item['ContactName']?? "N/A",
              item['phoneNumber'] ?? "N/A",
              item['Email']?? "N/A"
            ]).toList(),
          ),
        ],
      )

  );

  return doc.save();
}
