import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notester/bloc/app_update_bloc/app_update_event.dart';
import 'package:notester/bloc/app_update_bloc/app_update_state.dart';

class AppUpdateBloc extends Bloc<AppUpdateEvent, AppUpdateState> {
  AppUpdateBloc() : super(AppUpdateState.initial()) {
    on<UpdateAppUpdateDialogEvent>(_showAppUpdateDialog);
  }

  void _showAppUpdateDialog(
      UpdateAppUpdateDialogEvent event, Emitter<AppUpdateState> emit) {
    emit(
      state.copyWith(
          commonAppStatus: CommonAppStatus.loading, screenKey: event.key),
    );
    emit(
      state.copyWith(
          commonAppStatus: CommonAppStatus.success,
          showUpdateDialog: event.showUpdateDialog),
    );
  }
}
