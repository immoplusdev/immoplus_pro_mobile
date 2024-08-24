import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/views/home_page/widgets/booking_loading_card.dart';
import 'package:immoplus_pro/views/visits/logic/booking_cubit.dart';
import 'package:immoplus_pro/views/visits/logic/visit_request_state.dart';

class VisitPage extends StatefulWidget {
  const VisitPage({super.key});
  static String name = 'VISIT_PAGE';
  @override
  State<VisitPage> createState() => _VisitPageState();
}

class _VisitPageState extends State<VisitPage> {
  @override
  void initState() {
    context.read<VisitCubit>().getVisits();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scafold,
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              context.read<VisitCubit>().getVisits();
            },
          ),
          BlocBuilder<VisitCubit, VisitRequestState>(
            builder: (context, state) {
              // if (state is RECEIVE_BOOKINGS) {
              //   return SliverList.list(
              //     children: state.reservationModel.data!
              //         .map(
              //           (item) => BookingCard(
              //             reservationModel: item,
              //           ),
              //         )
              //         .toList(),
              //   );
              // }
              return SliverList.builder(
                itemBuilder: (context, index) => const BookingLoadingCard(),
                itemCount: 20,
              );
            },
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(onPressed: () {
        //inspect(UserModel.singleton);
      }),
    );
  }
}
