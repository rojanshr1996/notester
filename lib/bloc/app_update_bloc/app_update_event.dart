import 'package:equatable/equatable.dart';

abstract class AppUpdateEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateAppUpdateDialogEvent extends AppUpdateEvent {
  final String key;
  final bool showUpdateDialog;

  UpdateAppUpdateDialogEvent(
      {required this.showUpdateDialog, required this.key});

  @override
  List<Object> get props => [showUpdateDialog, key];
}
