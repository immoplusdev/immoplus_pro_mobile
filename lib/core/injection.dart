import 'package:get_it/get_it.dart';
import 'package:immoplus_pro/services/deep_link_services.dart';
import 'package:immoplus_pro/utils/easy_loading_handler.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  getIt.init();
  await getIt<DeepLinkServices>().initUniLinks();
  await getIt<EasyLoadingHandler>().init();
}
