import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:vitaflowplus/models/sugar_model.dart';
import 'package:vitaflowplus/services/firebaseFunctions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';

class ReportService {
  static Future<void> generateReport(String userId) async {
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 4);
    grid.headers.add(1);
    grid.headers[0].cells[0].value = 'Date';
    grid.headers[0].cells[1].value = 'Blood Sugar';
    grid.headers[0].cells[2].value = 'Insulin Dose';
    grid.headers[0].cells[3].value = 'Mood';

    try {
      List<Sugar> sugarData = await FirebaseFunctions.fetchSugarLevels(userId);

      for (int i = 0; i < sugarData.length; i++) {
        grid.rows.add();
        grid.rows[i].cells[0].value = sugarData[i].date.toString();
        grid.rows[i].cells[1].value = sugarData[i].bloodSugar.toString();
        grid.rows[i].cells[2].value = sugarData[i].insulinDose.toString();
        grid.rows[i].cells[3].value = sugarData[i].mood;
      }
    } catch (error) {
      print('Error fetching sugar data: $error');
    }

    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, page.getClientSize().height),
    );

    Directory? directory = await getExternalStorageDirectory();
    if (directory != null) {
      String path = directory.path;
      final File file = File('$path/report.pdf');
      final List<int> bytes = await document.save();
      await file.writeAsBytes(bytes, flush: true);

      print('PDF file saved to: $path');

      // Save the file using document_file_save_plus package
      await DocumentFileSavePlus().saveMultipleFiles(
        dataList: [Uint8List.fromList(bytes)],
        fileNameList: ['report.pdf'],
        mimeTypeList: ['application/pdf'],
      );
    } else {
      print('External storage directory is null.');
    }

    document.dispose();
  }
}