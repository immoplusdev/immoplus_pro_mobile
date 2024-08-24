// import 'package:bloc/bloc.dart';
// import 'package:flutter/widgets.dart';
// import '../../views/detail_ticket/logic/events/detail_tickets_event.dart';
// import '../../views/detail_ticket/logic/states/detail_ticket_state.dart';

// class DetailTicketBloc
//     extends Bloc<DetailTicketEvent, DetailTicketScreenState> {
//   BuildContext context;
//   DetailTicketBloc({required this.context})
//       : super(DetailTicketInitialScreenState()) {
//     on<GetProductsEvent>(onGetProduct);
//     on<GetMapProductEvent>(onGetMapProduct);
//   }

//   void onGetProduct(
//       GetProductsEvent event, Emitter<DetailTicketScreenState> emit) async {
//     emit(DetailTicketPendingScreenState());

//     ProductModel data =
//         await ProductRepository(context: context).getOnce(id: event.idProduct);
//     emit(ReadyScreenProduct(data: data));
//   }

//   void onGetMapProduct(
//       GetMapProductEvent event, Emitter<DetailTicketScreenState> emit) async {
//     emit(DetailTicketPendingScreenState());
//     Constantes.configApp ??=
//         await ItemsRepository(context: context).getConfig();
//     List<ProductModel> data = await ProductRepository(context: context)
//         .getList(params: "meta=*&filter[position][_nnull]=true&limit=-1");
//     emit(ReadyScreenListProduct(data: data));
//   }
// }

// class SimilarProductCubit extends Cubit<DetailTicketScreenState> {
//   BuildContext context;

//   SimilarProductCubit({required this.context})
//       : super(DetailTicketInitialScreenState());

//   getSimilar({required int id}) async {
//     emit(DetailTicketPendingScreenState());
//     Constantes.configApp ??=
//         await ItemsRepository(context: context).getConfig();
//     List<ProductModel> data = await ProductRepository(context: context)
//         .getList(path: "product/similar/$id", params: "page=1");
//     emit(DetailTicketReadyScreenState(data: data));
//   }
// }
