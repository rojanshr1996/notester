// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

enum CommonAppStatus {
  initial,
  loading,
  failure,
  loadRequest,
  validated,
  success,
}

class AppUpdateState extends Equatable {
  final CommonAppStatus commonAppStatus;
  final String screenKey;
  final String errorMessage;
  final String errorKey;
  final bool showUpdateDialog;

  const AppUpdateState({
    this.commonAppStatus = CommonAppStatus.initial,
    this.screenKey = '',
    this.errorMessage = '',
    this.errorKey = '',
    this.showUpdateDialog = true,
  });

  factory AppUpdateState.initial({
    String errorMessage = '',
    String errorKey = '',
    String screenKey = '',
    bool showUpdateDialog = true,
  }) {
    return AppUpdateState(
      commonAppStatus: CommonAppStatus.initial,
      errorMessage: errorMessage,
      errorKey: errorKey,
      screenKey: screenKey,
      showUpdateDialog: showUpdateDialog,
    );
  }

  AppUpdateState copyWith({
    CommonAppStatus? commonAppStatus,
    String? screenKey,
    String? errorMessage,
    String? errorKey,
    bool? showUpdateDialog,
  }) {
    return AppUpdateState(
      commonAppStatus: commonAppStatus ?? this.commonAppStatus,
      screenKey: screenKey ?? this.screenKey,
      errorMessage: errorMessage ?? this.errorMessage,
      errorKey: errorKey ?? this.errorKey,
      showUpdateDialog: showUpdateDialog ?? this.showUpdateDialog,
    );
  }

  @override
  List<Object?> get props {
    return [
      commonAppStatus,
      screenKey,
      errorMessage,
      errorKey,
      showUpdateDialog
    ];
  }

  @override
  bool get stringify => true;
}
