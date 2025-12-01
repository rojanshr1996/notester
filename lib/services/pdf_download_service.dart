import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class PdfDownloadService {
  Future<String?> generateAndSavePdf({
    required String title,
    required String content,
    required String createdDate,
  }) async {
    try {
      // Request storage permission
      final status = await _requestPermission();
      if (!status) {
        throw Exception('Storage permission denied');
      }

      // Create PDF document
      final pdf = pw.Document();

      // Add page with content
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              // Title
              pw.Text(
                title.isEmpty ? 'Untitled Note' : title,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              // Date
              pw.Text(
                createdDate,
                style: const pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 20),
              // Content
              pw.Text(
                content.isEmpty ? 'No content' : content,
                style: const pw.TextStyle(
                  fontSize: 14,
                  lineSpacing: 1.5,
                ),
              ),
            ];
          },
        ),
      );

      // Get downloads directory
      final directory = await _getDownloadsDirectory();
      if (directory == null) {
        throw Exception('Could not access downloads directory');
      }

      // Generate filename
      final fileName = _generateFileName(title);
      final filePath = '${directory.path}/$fileName';

      // Save PDF file
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      return filePath;
    } catch (e) {
      print('Error generating PDF: $e');
      return null;
    }
  }

  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await _getAndroidVersion();

      // Android 13+ (API 33+) doesn't need storage permission for downloads
      if (androidInfo >= 33) {
        return true;
      }

      // For Android 12 and below
      final status = await Permission.storage.request();
      return status.isGranted;
    } else if (Platform.isIOS) {
      // iOS doesn't need explicit permission for app documents
      return true;
    }
    return false;
  }

  Future<int> _getAndroidVersion() async {
    if (Platform.isAndroid) {
      // This is a simplified version - in production use device_info_plus
      return 33; // Assume modern Android for now
    }
    return 0;
  }

  Future<Directory?> _getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      return Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    }
    return null;
  }

  String _generateFileName(String title) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final cleanTitle = title.isEmpty
        ? 'note'
        : title.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(' ', '_');
    return '${cleanTitle}_$timestamp.pdf';
  }
}
