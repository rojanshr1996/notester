import 'dart:io';

import 'package:notester/model/model.dart';
import 'package:notester/widgets/no_data_widget.dart';
import 'package:notester/widgets/simple_circular_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class PdfViewerScreen extends StatefulWidget {
  final Args arguments;
  const PdfViewerScreen({Key? key, required this.arguments}) : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  @override
  void initState() {
    super.initState();
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
      body: FutureBuilder<File>(
          future: DefaultCacheManager().getSingleFile(widget.arguments.fileUrl),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: SimpleCircularLoader())
                  : snapshot.hasData
                      ? PdfViewer.openFile(
                          snapshot.data!.path,
                        )
                      : const NoDataWidget(
                          title: "Error opening PDF. Please try again.")),
    );
  }
}
