// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:immoplus_pro/services/deep_link_services.dart' as _i178;
import 'package:immoplus_pro/utils/easy_loading_handler.dart' as _i166;
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
    gh.lazySingleton<_i166.EasyLoadingHandler>(
        () => _i166.EasyLoadingHandler());
    gh.lazySingleton<_i178.DeepLinkServices>(() => _i178.DeepLinkServices());
    return this;
  }
}
