import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


Future<Uint8List> generateDocument(PdfPageFormat format, List<Map<String, dynamic>> items) async {
  DateTime date = DateTime.now();
  items.sort((a, b) => (a['Company'] ?? "").compareTo(b['Company'] ?? ""));  // Ensure sorting

  final doc = pw.Document();
  final image = pw.MemoryImage(
    (await rootBundle.load('lib/examples/assets/company_logo.png')).buffer.asUint8List(),
  );
  final fontRegular = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Roboto-Regular.ttf"));
  final fontBold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Roboto-Bold.ttf"));
  final fontBoldItalic = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Roboto-BoldItalic.ttf"));
  final fontItalic = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Roboto-Italic.ttf"));

  // Separate cameras and down nvrs into different lists
  final cameras = items.where((item) => item['down nvrs'] == null).toList();
  final downNvrs = items.where((item) => item['down nvrs'] != null).toList();

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

          pw.Paragraph(text: "Camera Outage Listed By Company:"),
          pw.Paragraph(text: "Date Updated: ${date.month}/${date.day}/${date.year}"),
          // Table for Cameras
          if (cameras.isNotEmpty) ...[
            pw.Paragraph(text: "Cameras:"),
            pw.TableHelper.fromTextArray(
              cellAlignment: pw.Alignment.centerLeft,
              cellStyle: const pw.TextStyle(fontSize: 10),
              headerAlignment: pw.Alignment.center,
              cellHeight: 30,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.centerLeft
              },
              border: const pw.TableBorder(
                top: pw.BorderSide(color: PdfColors.black,width: .5),
                bottom: pw.BorderSide(color: PdfColors.black,width: .5),
                left: pw.BorderSide(color: PdfColors.black,width: .5),
                right: pw.BorderSide(color: PdfColors.black,width: .5),
                horizontalInside: pw.BorderSide(color: PdfColors.black,width: .5),
                verticalInside: pw.BorderSide(color: PdfColors.black,width: .5),
              ),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headers: ['Company', 'Camera', 'Description', 'IP', "Warranty"],
              columnWidths: const {
                0: pw.FixedColumnWidth(75),
                1: pw.FixedColumnWidth(150),
                2: pw.FlexColumnWidth(1),
              },
              data: cameras.map((item) => [
                item['Company'] ?? "N/A",
                item['Camera'] ?? "N/A",
                item['Camera Description'] ?? "N/A",
                item['ip'] ?? "N/A",
                item['Warranty'] ?? "N/A"
              ]).toList(),
            ),
          ],

          // Add a page break before the Down NVRs section
          pw.NewPage(),

          // Table for Down NVRs on a new page
          if (downNvrs.isNotEmpty) ...[
            pw.Paragraph(text: "Down NVRs:"),
            pw.TableHelper.fromTextArray(
              cellAlignment: pw.Alignment.centerLeft,
              cellStyle: const pw.TextStyle(fontSize: 10),
              headerAlignment: pw.Alignment.center,
              cellHeight: 30,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
              },
              border: const pw.TableBorder(
                top: pw.BorderSide(color: PdfColors.black, width: .5),
                bottom: pw.BorderSide(color: PdfColors.black, width: .5),
                left: pw.BorderSide(color: PdfColors.black, width: .5),
                right: pw.BorderSide(color: PdfColors.black, width: .5),
                horizontalInside: pw.BorderSide(color: PdfColors.black, width: .5),
                verticalInside: pw.BorderSide(color: PdfColors.black, width: .5),
              ),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headers: ['Company', 'Description'],
              columnWidths: const {
                0: pw.FixedColumnWidth(75),
                1: pw.FlexColumnWidth(1),
              },
              data: downNvrs.map((item) => [
                item['down nvrs'] ?? "N/A",
                "The NVR is down."
              ]).toList(),
            ),
          ],
        ],
      )
  );

  return doc.save();
}

