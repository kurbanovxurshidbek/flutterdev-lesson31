
import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class HomeSendEvent extends HomeEvent {
  final String message;
  final String? base64Image;

  const HomeSendEvent({ required this.message, this.base64Image});

  @override
  List<Object?> get props => [message];
}