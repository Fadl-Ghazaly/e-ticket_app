import 'package:flutter/material.dart';
import '../../../models/ticket.dart';

class EventCard extends StatelessWidget {
  final Ticket ticket;
  const EventCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman detail dengan membawa data ticket
        Navigator.pushNamed(
          context,
          '/ticket-detail',
          arguments: ticket,
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TAMBAHKAN Hero di sini
            Hero(
              tag: 'image-${ticket.id}', // Tag unik berdasarkan ID tiket
              child: Container(
                height: 150,
                width: double.infinity,
                color: Colors.blueGrey,
                child: Image.network(
                  ticket.imageUrl, 
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.title, 
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(ticket.date.toString()),
                  Text('Rp ${ticket.price}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}