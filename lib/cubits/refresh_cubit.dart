import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefreshState {}

class PendingRefreshState extends RefreshState {}

class ReadyRefreshState extends RefreshState {
  bool data;
  ReadyRefreshState({required this.data});
}

class RefreshCubit extends Cubit<RefreshState> {
  RefreshCubit() : super(RefreshState());
  onRefresh(BuildContext context) async {
    emit(PendingRefreshState());
    // Constantes.configApp ??=
    //     await ItemsRepository(context: context).getConfig();
    //bool data = await DataProvider().refreshToken();
    emit(ReadyRefreshState(data: true));
  }

  onGetCurrent(BuildContext context) async {
    // print('pending');
    // emit(PendingRefreshState());

    // Constantes.configApp ??=
    //     await ItemsRepository(context: context).getConfig();
    // InscriptionResponseModel data = await Repository().getCurrentData();
    //–emit(ReadyRefreshState(data: data.status));
  }
}
