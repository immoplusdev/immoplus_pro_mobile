// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:mon_immo_ci/features/detail_ticket/logic/events/detail_tickets_event.dart';
// import 'package:mon_immo_ci/features/home_page/logic/events/data_event.dart';
// import 'package:mon_immo_ci/features/home_page/logic/states/screen_state.dart';
// import 'package:mon_immo_ci/models/product_model.dart';
// import 'package:mon_immo_ci/provider/product_provider/items_repository.dart';
// import 'package:mon_immo_ci/repository/repository.dart';

// import '../../views/models/image_product_model.dart';
// import '../../views/models/service_model.dart';
// import '../../views/models/slide_item_model.dart';
// import '../../views/detail_ticket/logic/states/detail_ticket_state.dart';

// class ImagesTicketBloc
//     extends Bloc<DetailTicketEvent, DetailTicketScreenState> {
//   BuildContext context;
//   ImagesTicketBloc({required this.context})
//       : super(DetailTicketInitialScreenState()) {
//     on<GetImagesEvent>(ongGetImages);
//   }

//   void ongGetImages(
//       GetImagesEvent event, Emitter<DetailTicketScreenState> emit) async {
//     emit(DetailTicketPendingScreenState());
//     List<ImageProductModel> data = await ItemsRepository(context: context)
//         .getImageProductList(idProduct: event.idProduct);

//     emit(DetailTicketReadyScreenState(data: data));
//   }
// }
