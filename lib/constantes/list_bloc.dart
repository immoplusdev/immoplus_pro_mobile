import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/cubits/authentification/login_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit.dart';
import 'package:immoplus_pro/cubits/detail_product_cubit/carousel_cubit.dart';
import 'package:immoplus_pro/cubits/refresh_cubit.dart';
import 'package:immoplus_pro/views/booking/logic/booking_cubit.dart';
import 'package:immoplus_pro/views/estate_detail/cubit/estate_cubit.dart';
import 'package:immoplus_pro/views/residence_detail/cubit/logment_cubit.dart';
import 'package:immoplus_pro/views/visits/logic/booking_cubit.dart';

class BlocsManager {
  static List<BlocProvider> listBlocProviders = [
    BlocProvider<RefreshCubit>(
      create: (context) => RefreshCubit(),
    ),
    BlocProvider<CarouselCubit>(
      create: (context) => CarouselCubit(),
    ),
    BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(),
    ),
    BlocProvider<LogmentCubit>(
      create: (context) => LogmentCubit(),
    ),
    BlocProvider<BookingCubit>(
      create: (context) => BookingCubit(),
    ),
    BlocProvider<VisitCubit>(
      create: (context) => VisitCubit(),
    ),
    BlocProvider<RgistrationCubitCubit>(
      create: (context) => RgistrationCubitCubit(),
    ),
    BlocProvider<EstateCubit>(
      create: (context) => EstateCubit(),
    ),
  ];
}
