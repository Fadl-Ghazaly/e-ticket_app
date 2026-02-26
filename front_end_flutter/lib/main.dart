import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end_flutter/screens/auth/login_screen.dart';
import 'package:front_end_flutter/screens/auth/register_screen.dart';
import 'package:front_end_flutter/screens/dashboard_screen.dart';
import 'package:front_end_flutter/blocs/auth_bloc.dart';
import 'package:front_end_flutter/blocs/auth_event.dart';
import 'package:front_end_flutter/blocs/auth_state.dart';
import 'package:front_end_flutter/blocs/ticket/ticket_bloc.dart';
import 'package:front_end_flutter/repositories/ticket_repository.dart';
import 'package:front_end_flutter/screens/dashboard/ticket_detail_screen.dart'; // TAMBAHKAN INI

void main() {
  runApp(const ETicketingApp());
}

class ETicketingApp extends StatelessWidget {
  const ETicketingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(CheckAuthStatus()),
        ),
        BlocProvider<TicketBloc>(
          // PERBAIKAN: Tambahkan ticketRepository
          create: (context) => TicketBloc(
            ticketRepository: TicketRepository(), // Gunakan default constructor
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Ticketing App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthWrapper(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/ticket-detail': (context) => const TicketDetailScreen(), 
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/dashboard');
          });
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is AuthUnauthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/login');
          });
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}