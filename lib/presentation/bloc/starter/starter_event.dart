
import 'package:equatable/equatable.dart';

abstract class StarterEvent extends Equatable {
  const StarterEvent();
}

class StarterVideoEvent extends StarterEvent {

  @override
  List<Object?> get props => [];
}