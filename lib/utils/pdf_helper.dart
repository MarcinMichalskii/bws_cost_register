import 'dart:typed_data';
import 'package:bws_agreement_creator/form_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfHelper {
  Future<Uint8List> generatePdfPage(CostFormState form) async {
    final document = pw.Document();

    final pages = form.photos.map((e) => pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(pw.MemoryImage(e)),
          );
        }));

    pages.forEach((element) {
      document.addPage(element);
    });
    return document.save();
  }
}
