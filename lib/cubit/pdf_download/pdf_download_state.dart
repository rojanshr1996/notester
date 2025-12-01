import 'package:equatable/equatable.dart';

abstract class PdfDownloadState extends Equatable {
  const PdfDownloadState();

  @override
  List<Object?> get props => [];
}

class PdfDownloadInitial extends PdfDownloadState {
  const PdfDownloadInitial();
}

class PdfDownloadLoading extends PdfDownloadState {
  const PdfDownloadLoading();
}

class PdfDownloadSuccess extends PdfDownloadState {
  final String filePath;

  const PdfDownloadSuccess({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}

class PdfDownloadError extends PdfDownloadState {
  final String message;

  const PdfDownloadError({required this.message});

  @override
  List<Object?> get props => [message];
}
