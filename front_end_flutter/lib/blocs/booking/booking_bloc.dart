import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/booking.dart';
import '../../repositories/booking_repository.dart';
import './booking_event.dart';
import './booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository bookingRepository;

  BookingBloc({required this.bookingRepository}) : super(BookingInitial()) {
    on<CreateBooking>(_onCreateBooking);
    on<LoadBooking>(_onLoadBooking);
    on<DeleteBooking>(_onDeleteBooking);
  }

  Future<void> _onCreateBooking(
    CreateBooking event, 
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
     final booking = Booking(
      ticketId: event.ticket.id,
      ticketTitle: event.ticket.title,
      price: event.ticket.price,
      imageUrl: event.ticket.imageUrl,
      bookingDate: DateTime.now().toIso8601String(),
      status: 'Booked',
     );
     await bookingRepository.insertBooking(booking);
     emit(const BookingSuccess(message: 'Booking berhasil dibuat'));
    } catch (e) {
      emit(BookingError(message: 'Gagal membuat booking: ${e.toString()}'));
    }
  }

  Future<void> _onLoadBooking(
    LoadBooking event, 
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final bookings = await bookingRepository.getAllBookings();
      emit(BookingLoaded(bookings: bookings));
    } catch (e) {
      emit(BookingError(message: 'Gagal memuat booking: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteBooking(
    DeleteBooking event, 
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      await bookingRepository.deleteBooking(event.id);
      final bookings = await bookingRepository.getAllBookings();
      emit(BookingLoaded(bookings: bookings));
    } catch (e) {
      emit(BookingError(message: 'Gagal menghapus booking: ${e.toString()}'));
    }
}
}