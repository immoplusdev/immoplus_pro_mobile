import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/cubits/authentification/delete_account_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/login_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/reset_password_cubit.dart';
import 'package:immoplus_pro/cubits/detail_product_cubit/carousel_cubit.dart';
import 'package:immoplus_pro/cubits/refresh_cubit.dart';
import 'package:immoplus_pro/features/booking/logic/booking_cubit.dart';
import 'package:immoplus_pro/features/estate_detail/cubit/estate_cubit.dart';
import 'package:immoplus_pro/features/furniture_detail/cubit/furniture_cubit.dart';
import 'package:immoplus_pro/features/payment_module/bloc/payment_cubit.dart';
import 'package:immoplus_pro/features/payments/logic/wallet_cubit.dart';
import 'package:immoplus_pro/features/residence_detail/cubit/logment_cubit.dart';
import 'package:immoplus_pro/features/visits/logic/booking_cubit.dart';

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
    BlocProvider<DeleteAccountCubit>(
      create: (context) => DeleteAccountCubit(),
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
    BlocProvider<FurnitureCubit>(
      create: (context) => FurnitureCubit(),
    ),
    BlocProvider<PaymentCubit>(
      create: (context) => PaymentCubit(),
    ),
    BlocProvider<WalletCubit>(
      create: (context) => WalletCubit(),
    ),
    BlocProvider<ResetPasswordCubit>(
      create: (context) => ResetPasswordCubit(),
    ),
  ];
}
