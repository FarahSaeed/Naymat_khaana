
import 'package:equatable/equatable.dart';

abstract class ExploreFoodItemsEvent extends Equatable {}

// ignore: must_be_immutable
class PageStartedEvent extends ExploreFoodItemsEvent{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddButtonPressedEvent extends ExploreFoodItemsEvent{

  String id, recieveruname;

  AddButtonPressedEvent({required this.id, required this.recieveruname});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

