import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end_flutter/blocs/auth_bloc.dart';
import 'package:front_end_flutter/blocs/auth_event.dart';
import 'package:front_end_flutter/blocs/auth_state.dart';
import '../blocs/ticket/ticket_bloc.dart';
import '../blocs/ticket/ticket_event.dart';
import '../blocs/ticket/ticket_state.dart';
import 'dashboard/widgets/event_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Panggil LoadTickets ketika screen pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // CEK dulu apakah TicketBloc tersedia
      if (context.read<TicketBloc>() != null) {
        context.read<TicketBloc>().add(const LoadTickets());
      }
    });

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushNamedAndRemoveUntil(
            context, 
            '/login',
            (route) => false,
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          automaticallyImplyLeading: false, // Hilangkan tombol back
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Cari tiket...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  context.read<TicketBloc>().add(SearchTickets(value));
                },
              ),
            ),
            // Ticket List
            Expanded(
              child: BlocBuilder<TicketBloc, TicketState>(
                builder: (context, state) {
                  if (state is TicketLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TicketError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.message),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<TicketBloc>().add(const LoadTickets());
                            },
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is TicketLoaded) {
                    if (state.tickets.isEmpty) {
                      return const Center(
                        child: Text('Tidak ada tiket tersedia'),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<TicketBloc>().add(const LoadTickets());
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.tickets.length,
                        itemBuilder: (context, index) {
                          final ticket = state.tickets[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context, 
                                '/ticket-detail',
                                arguments: ticket,
                              );
                            },
                            child: EventCard(ticket: ticket),
                          );
                        },
                      ),
                    );
                  }
                  return const Center(child: Text('No tickets found.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}