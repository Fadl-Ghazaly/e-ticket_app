import 'package:flutter/material.dart';
import '../../models/ticket.dart';

class TicketDetailScreen extends StatelessWidget {
  const TicketDetailScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final ticket = ModalRoute.of(context)!.settings.arguments as Ticket;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(ticket.title, style: const TextStyle(fontSize: 16)),
              // TAMBAHKAN Hero di sini dengan tag yang SAMA
              background: Hero(
                tag: 'image-${ticket.id}', // Tag harus SAMA dengan di event_card
                child: Image.network(
                  ticket.imageUrl, 
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deskripsi',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(ticket.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Book now - Rp ${ticket.price}'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SizedBox(
          height:50,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking berhasil!')),
              );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Book Now', style: TextStyle(fontSize: 16, 
            fontWeight: FontWeight.bold)),
        )
              
            ),
        
        ),
      );
  
  }
}