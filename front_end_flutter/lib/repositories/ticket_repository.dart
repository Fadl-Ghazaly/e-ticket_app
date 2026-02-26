import '../models/ticket.dart';

class TicketRepository {
  final List<Ticket> _mocktickets = [
    Ticket(
      id: '1',
      title: 'Avatar Fire and Ash',
      description: 'Trilogy of Avatars',
      price: 50000,
      date: DateTime.now().add(const Duration(days: 30)), 
      imageUrl: 'https://example.com/concert_a.jpg',
    ),
    Ticket(
      id: '2',
      title: 'Theater B',
      description: 'An amazing theater performance.',
      price: 50000,
      date: DateTime.now().add(const Duration(days: 15)), 
      imageUrl: 'https://example.com/theater_b.jpg',
    ),
    Ticket(
      id: '3',
      title: 'Sports C',
      description: 'Exciting sports event with top teams.',
      price: 50000,
      date: DateTime.now().add(const Duration(days: 10)), 
      imageUrl: 'https://example.com/sports_c.jpg',
    ),
  ];

  Future<List<Ticket>> fetchTickets() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mocktickets;
  }

  Future<Ticket?> getTicketById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try{
      return _mocktickets.firstWhere((ticket) => ticket.id == id);
    }catch(e){
      return null;
    }
  }

  Future<List<Ticket>> searchTickets(String query) async {
    await Future.delayed(const Duration(seconds: 1));
    return _mocktickets.where((ticket) {
      return ticket.title.toLowerCase().contains(query.toLowerCase());
}).toList();
  }

  // Ubah method ini menjadi async juga
  Future<List<Ticket>> getTickets() async {  // <-- Tambahkan Future dan async
    return _mocktickets;  // Langsung return (otomatis jadi Future)
  }
  
  // Atau jika ingin tetap sync, buat method sync terpisah
  List<Ticket> getMockTicketsSync() => _mocktickets;  // Untuk keperluan lain
}