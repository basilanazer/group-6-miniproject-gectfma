import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class PDFManager {
  Future<void> generateAndDownloadPDF(
      String fileName, String content, String imageURL) async {
    try {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      // Add heading "Complaint Details"
      page.graphics.drawString("COMPLAINT DETAILS",
          PdfStandardFont(PdfFontFamily.courier, 24),
          bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, 50),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)));
      // Add text content to the PDF
       PdfTextElement(
        text: content,
        font: PdfStandardFont(PdfFontFamily.courier, 18),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)))
    .draw(
        page: page,
        bounds: Rect.fromLTWH(
            0, 60, page.getClientSize().width, page.getClientSize().height),
        format: PdfLayoutFormat(
          layoutType: PdfLayoutType.paginate,
        ));
      // page.graphics.drawString(content,
      //     PdfStandardFont(PdfFontFamily.helvetica, 18),
      //     bounds: Rect.fromLTWH(0, 60, page.getClientSize().width, double.infinity),
      //     brush: PdfSolidBrush(PdfColor(0, 0, 0)));
      
      final page2 = document.pages.add();
      page2.graphics.drawString("IMAGE :",
          PdfStandardFont(PdfFontFamily.helvetica, 20));

      // Fetch image data from URL and add it to the PDF
      final Uint8List imageData = await _readImageDataFromUrl(imageURL);
      page2.graphics.drawImage(
          PdfBitmap(imageData), 
          const Rect.fromLTWH(0, 100, 360, 450));

      // Save the PDF
      final List<int> bytes = await document.save();
      document.dispose();

      // Save the PDF file to device storage
      final Directory? directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('Failed to get external storage directory');
      }
      final String path = directory.path;
      final File file = File('$path/$fileName');
      await file.writeAsBytes(bytes, flush: true);

      // Open the saved PDF file using open_file plugin
      OpenFile.open('$path/$fileName');
    } catch (e) {
      //print('Error generating or saving PDF: $e');
    }
  }

  Future<Uint8List> _readImageDataFromUrl(String imageUrl) async {
    final http.Response response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image from URL: $imageUrl');
    }
  }
}
