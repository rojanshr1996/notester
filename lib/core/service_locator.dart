import 'package:get_it/get_it.dart';
import 'package:notester/services/notester_remote_config_service.dart';

final getIt = GetIt.instance;

void initServiceLocator() {
  getIt.registerLazySingleton(() => NotesterPackageInfo());
}
