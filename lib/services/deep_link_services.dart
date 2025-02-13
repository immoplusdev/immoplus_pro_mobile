import 'dart:async';
import 'dart:developer';

import 'package:immoplus_pro/app_router.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeepLinkServices {
  static StreamSubscription? _sub;

  Future<void> initUniLinks() async {
    // ... check initialUri

    // Attach a listener to the stream
    // _sub = uriLinkStream.listen((Uri? uri) {
    //   // Use the uri and warn the user, if it is not correct
    //   log('DEEPLINK');
    //   inspect(uri);
    //   AppRouter.router.pushReplacement(uri!.path);
    // }, onError: (err) {
    //   // Handle exception by warning the user their action did not succeed
    // });

    // NOTE: Don't forget to call _sub.cancel() in dispose()
  }

  stop() {
    _sub?.cancel();
  }
}
