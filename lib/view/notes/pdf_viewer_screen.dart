import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:notester/model/model.dart';
import 'package:notester/widgets/no_data_widget.dart';
import 'package:notester/widgets/simple_circular_loader.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewerScreen extends StatefulWidget {
  final Args arguments;
  const PdfViewerScreen({super.key, required this.arguments});

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PdfControllerPinch? _pdfController;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final file =
          await DefaultCacheManager().getSingleFile(widget.arguments.fileUrl);
      _pdfController = PdfControllerPinch(
        document: PdfDocument.openFile(file.path),
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        shadowColor: Theme.of(context).colorScheme.shadow,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 2,
        title: Text(
          widget.arguments.fileName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: _isLoading
          ? const Center(child: SimpleCircularLoader())
          : _hasError
              ? const NoDataWidget(
                  title: "Error opening PDF. Please try again.")
              : PdfViewPinch(
                  controller: _pdfController!,
                  padding: 10,
                  backgroundDecoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
    );
  }
}
