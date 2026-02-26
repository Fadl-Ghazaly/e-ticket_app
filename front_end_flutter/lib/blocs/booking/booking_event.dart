import 'package:equatable/equatable.dart';
// import '../../models/booking.dart';
import '../../models/ticket.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent(); 
  @override
  List<Object> get props => [];
}

class CreateBooking extends BookingEvent {
  final Ticket ticket;
  const CreateBooking({required this.ticket});
  @override
  List<Object> get props => [ticket];
}

class LoadBooking extends BookingEvent {
  const LoadBooking();
  
}

class DeleteBooking extends BookingEvent {
  final int id;
  const DeleteBooking({required this.id});
  @override
  List<Object> get props => [id];
}