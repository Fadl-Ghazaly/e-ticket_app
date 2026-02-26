import 'package:equatable/equatable.dart';
// import '../../models/ticket.dart';
import '../../models/booking.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}
class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final String message;

  const BookingSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class BookingLoaded extends BookingState {
  final List<Booking> bookings;

  const BookingLoaded({required this.bookings});

  @override
  List<Object?> get props => [bookings];
}

class BookingError extends BookingState {
  final String message;

  const BookingError({required this.message});

  @override
  List<Object?> get props => [message];
}