import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

// Event saat aplikasi pertama kali dijalankan (cek sesi login)
class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

// Event saat tombol login ditekan
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

// Event saat tombol register ditekan
class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword; 

  const RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

    @override
  List<Object?> get props => [name, email, password, confirmPassword];
}

// Event saat logout
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}



