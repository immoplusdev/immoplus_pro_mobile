// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:immoplus_pro/features/certification/cubits/certification_cubit.dart'
    as _i922;
import 'package:immoplus_pro/features/messaging/logic/conversation_thread_cubit.dart'
    as _i135;
import 'package:immoplus_pro/features/messaging/logic/inbox_cubit.dart' as _i14;
import 'package:immoplus_pro/features/pin_code/data/repositories/pin_code_repository.dart'
    as _i177;
import 'package:immoplus_pro/features/pin_code/logic/cubit/pin_code_cubit.dart'
    as _i581;
import 'package:immoplus_pro/features/pin_code/views/services/biometry_service.dart'
    as _i521;
import 'package:immoplus_pro/services/analytics_service.dart' as _i1047;
import 'package:immoplus_pro/services/deep_link_services.dart' as _i178;
import 'package:immoplus_pro/services/messaging_socket_service.dart' as _i185;
import 'package:immoplus_pro/services/notification_service.dart' as _i873;
import 'package:immoplus_pro/services/pending_reservation_overlay_service.dart'
    as _i579;
import 'package:immoplus_pro/services/remote_config_service.dart' as _i215;
import 'package:immoplus_pro/services/reservation_socket_service.dart' as _i908;
import 'package:immoplus_pro/utils/easy_loading_handler.dart' as _i166;
import 'package:immoplus_pro/utils/session_manager.dart' as _i165;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i177.PinCodeRepository>(() => _i177.PinCodeRepository());
    gh.factory<_i521.BiometryService>(() => _i521.BiometryService());
    gh.factory<_i922.CertificationCubit>(() => _i922.CertificationCubit());
    gh.singleton<_i165.SessionManager>(() => _i165.SessionManager());
    gh.lazySingleton<_i166.EasyLoadingHandler>(
        () => _i166.EasyLoadingHandler());
    gh.lazySingleton<_i178.DeepLinkServices>(() => _i178.DeepLinkServices());
    gh.lazySingleton<_i908.ReservationSocketService>(
        () => _i908.ReservationSocketService());
    gh.lazySingleton<_i579.PendingReservationOverlayService>(
        () => _i579.PendingReservationOverlayService());
    gh.lazySingleton<_i215.RemoteConfigService>(
        () => _i215.RemoteConfigService());
    gh.lazySingleton<_i873.NotificationService>(
        () => _i873.NotificationService());
    gh.lazySingleton<_i185.MessagingSocketService>(
        () => _i185.MessagingSocketService());
    gh.lazySingleton<_i1047.AnalyticsService>(
        () => _i1047.FirebaseAnalyticsService());
    gh.factory<_i135.ConversationThreadCubit>(() =>
        _i135.ConversationThreadCubit(gh<_i185.MessagingSocketService>()));
    gh.factory<_i581.PinCodeCubit>(() => _i581.PinCodeCubit(
          gh<_i177.PinCodeRepository>(),
          gh<_i521.BiometryService>(),
        ));
    gh.factory<_i14.InboxCubit>(() => _i14.InboxCubit(
          gh<_i185.MessagingSocketService>(),
          gh<_i165.SessionManager>(),
        ));
    return this;
  }
}
