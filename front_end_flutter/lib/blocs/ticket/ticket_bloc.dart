import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/ticket_repository.dart';
import './ticket_event.dart';
import './ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketRepository ticketRepository;
  
  TicketBloc({required this.ticketRepository}) : super(TicketInitial()) {
    on<LoadTickets>(_onLoadTickets);
    on<RefreshTickets>(_onRefreshTickets);
    on<SearchTickets>(_onSearchTickets);
  }

  Future<void> _onLoadTickets(
    LoadTickets event, 
    Emitter<TicketState> emit,
  ) async {
    emit(TicketLoading());
    try {
      final tickets = await ticketRepository.getTickets();
      emit(TicketLoaded(tickets: tickets));
    } catch (e) {
      emit(TicketError(message: 'Gagal memuat tiket: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshTickets(
    RefreshTickets event, 
    Emitter<TicketState> emit,
  ) async {
    emit(TicketLoading());
    try {
      final tickets = await ticketRepository.getTickets();
      emit(TicketLoaded(tickets: tickets));
    } catch (e) {
      emit(TicketError(message: 'Gagal menyegarkan tiket: ${e.toString()}'));
    }
  }

  Future<void> _onSearchTickets(
    SearchTickets event, 
    Emitter<TicketState> emit,
  ) async {
    emit(TicketLoading());
    try {
      final tickets = await ticketRepository.searchTickets(event.query);
      emit(TicketLoaded(tickets: tickets));
    } catch (e) {
      emit(TicketError(message: 'Gagal mencari tiket: ${e.toString()}'));
    }
  }
}