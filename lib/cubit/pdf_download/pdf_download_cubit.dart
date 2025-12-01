import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notester/cubit/pdf_download/pdf_download_state.dart';
import 'package:notester/services/pdf_download_service.dart';

class PdfDownloadCubit extends Cubit<PdfDownloadState> {
  final PdfDownloadService _pdfDownloadService;

  PdfDownloadCubit({PdfDownloadService? pdfDownloadService})
      : _pdfDownloadService = pdfDownloadService ?? PdfDownloadService(),
        super(const PdfDownloadInitial());

  Future<void> downloadNoteAsPdf({
    required String title,
    required String content,
    required String createdDate,
  }) async {
    try {
      emit(const PdfDownloadLoading());

      final filePath = await _pdfDownloadService.generateAndSavePdf(
        title: title,
        content: content,
        createdDate: createdDate,
      );

      if (filePath != null) {
        emit(PdfDownloadSuccess(filePath: filePath));
      } else {
        emit(const PdfDownloadError(
            message: 'Failed to generate PDF. Please try again.'));
      }
    } catch (e) {
      emit(PdfDownloadError(message: 'Error: ${e.toString()}'));
    }
  }

  void reset() {
    emit(const PdfDownloadInitial());
  }
}
