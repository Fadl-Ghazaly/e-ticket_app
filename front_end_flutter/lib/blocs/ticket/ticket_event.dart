import 'package:equatable/equatable.dart';

abstract class TicketEvent extends Equatable { 
  const TicketEvent();
  @override
  List<Object?> get props => [];
}

class SearchTickets extends TicketEvent {
  final String query;

  const SearchTickets(this.query);
  @override
  List<Object?> get props => [query];
}

class LoadTickets extends TicketEvent {
  const LoadTickets();
}

class RefreshTickets extends TicketEvent {
  const RefreshTickets();
}