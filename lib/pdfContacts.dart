import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'examples/document2.dart';

class PdfContact extends StatelessWidget {
  final List<Map<String, dynamic>> itemsList;

  const PdfContact({super.key, required this.itemsList});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('On-site Inventory List'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: PdfPreview(
          maxPageWidth: 700,
          build: (format) => generateDocument(format,itemsList),
          actions: <PdfPreviewAction>[
            if (!kIsWeb) // This ensures that saving is only offered on platforms that support file IO
              PdfPreviewAction(
                icon: const Icon(Icons.save),
                onPressed: (context, build, format) => _saveAsFile(context, build, format),
              ),
          ],
          onPrinted: _showPrintedToast,
          onShared: _showSharedToast,
        ),
      ),
    );
  }

  Future<void> _saveAsFile(
      BuildContext context,
      LayoutCallback build,
      PdfPageFormat pageFormat,
      ) async {
    final bytes = await build(pageFormat);
    final appDocDir = await getApplicationDocumentsDirectory();
    final file = File('${appDocDir.path}/Data.pdf');
    await file.writeAsBytes(bytes);
    OpenFile.open(file.path);
  }

  void _showPrintedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document processed successfully')),
    );
  }

  void _showSharedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document shared successfully')),
    );
  }
}
