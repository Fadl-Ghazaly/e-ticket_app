class Booking {
  final int? id;
  final String ticketId;
  final String ticketTitle;
  final String price;
  final String imageUrl;
  final String bookingDate;
  final String status;

  const Booking({
    this.id,
    required this.ticketId,
    required this.ticketTitle,
    required this.price,
    required this.imageUrl,
    required this.bookingDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ticketId': ticketId,
      'ticketTitle': ticketTitle,
      'price': price,
      'imageUrl': imageUrl,
      'bookingDate': bookingDate,
      'status': status,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      ticketId: map['ticketId'],
      ticketTitle: map['ticketTitle'],
      price: map['price'],
      imageUrl: map['imageUrl'],
      bookingDate: map['bookingDate'],
      status: map['status'],
    );
  }
}