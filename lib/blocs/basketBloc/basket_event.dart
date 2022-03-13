
import 'package:equatable/equatable.dart';

abstract class BasketEvent extends Equatable {}

// ignore: must_be_immutable
class PageStartedEvent extends BasketEvent{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class HomePageStartedEvent extends BasketEvent{
  String uname;

  HomePageStartedEvent({required this.uname});
  @override
  // TODO: implement props
  List<Object?> get props => [];
}


class RemoveButtonPressedEvent extends BasketEvent{

  String id;
  int index;

  RemoveButtonPressedEvent({required this.id, required this.index});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

