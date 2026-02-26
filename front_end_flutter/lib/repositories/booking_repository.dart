import '../models/booking.dart';
import 'database_helper.dart';

class BookingRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> insertBooking(Booking booking) async {
    final db = await _dbHelper.database;
    await db.insert(
      DatabaseHelper.tableBookings,
      booking.toMap(),
    );
  }

  Future<List<Booking>> getAllBookings() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableBookings,
      orderBy: 'id DESC'
    );
    return maps.map((map) => Booking.fromMap(map)).toList();
  }

 // 1. Delete berdasarkan ID 
  Future<void> deleteBooking(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableBookings,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 2. Delete semua bookings
  Future<void> deleteAllBookings() async {
    final db = await _dbHelper.database;
    await db.delete(DatabaseHelper.tableBookings);
  }

  // 3. Delete berdasarkan ticketId
  Future<void> deleteBookingsByTicketId(String ticketId) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableBookings,
      where: 'ticketId = ?',
      whereArgs: [ticketId],
    );
  }

  // 4. Delete berdasarkan status (misalnya hapus semua yang statusnya 'cancelled')
  Future<void> deleteBookingsByStatus(String status) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableBookings,
      where: 'status = ?',
      whereArgs: [status],
    );
  }

  // 5. Delete bookings sebelum tanggal tertentu (misalnya hapus history lama)
  Future<void> deleteBookingsBeforeDate(DateTime date) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableBookings,
      where: 'bookingDate < ?',
      whereArgs: [date.toIso8601String()],
    );
  }

  // 6. Delete multiple bookings berdasarkan list ID
  Future<void> deleteMultipleBookings(List<int> ids) async {
    if (ids.isEmpty) return;
    
    final db = await _dbHelper.database;
    final placeholders = ids.map((_) => '?').join(',');
    await db.delete(
      DatabaseHelper.tableBookings,
      where: 'id IN ($placeholders)',
      whereArgs: ids,
    );
  }

  // 7. Delete expired bookings (bookingDate sudah lewat)
  Future<void> deleteExpiredBookings() async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();
    await db.delete(
      DatabaseHelper.tableBookings,
      where: 'bookingDate < ?',
      whereArgs: [now],
    );
  }
}

