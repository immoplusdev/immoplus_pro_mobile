import 'package:bloc/bloc.dart';

class CarouselCubit extends Cubit<CarouselState> {
  CarouselCubit() : super(CarouselCurrentState(index: 0));

  changeState(int index) {
    emit(CarouselCurrentState(index: index));
  }
}

abstract class CarouselState {
  int index;
  CarouselState({required this.index});
}

class CarouselCurrentState extends CarouselState {
  CarouselCurrentState({required int index}) : super(index: index);
}
