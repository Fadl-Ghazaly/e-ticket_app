import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../core/validators.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../models/user.dart';

/// Bloc for handling authentication logic
class AuthBloc extends Bloc<AuthEvent, AuthState> {  // <-- Perbaiki: AuthBloc (B besar) dan Bloc (B besar)

  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  AuthBloc() : super(AuthInitial()) {  // <-- Hapus 'const' jika AuthInitial() bukan const constructor
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      
      if (isLoggedIn) {
        final userJson = prefs.getString(_userKey);
        if (userJson != null) {
          final user = User.fromJson(jsonDecode(userJson));
          emit(AuthAuthenticated(user: user));
        } else {
          emit(const AuthUnauthenticated());
        }
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: 'Gagal memeriksa status autentikasi: ${e.toString()}'));
    }
  }

  /// Handler untuk proses login
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      // Validasi input
      final emailError = Validators.validateEmail(event.email);
      final passwordError = Validators.validatePassword(event.password);
      
      if (emailError != null || passwordError != null) {
        emit(AuthError(message: emailError ?? passwordError!));
        return;
      }

      // Simulasi API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Buat user dan simpan ke SharedPreferences
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: event.email,
        name: 'User Demo',
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
      await prefs.setBool(_isLoggedInKey, true);
      
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: 'Login gagal: ${e.toString()}'));
    }
  }

  /// Handler untuk proses registrasi
  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      // Validasi semua input
      final nameError = Validators.validateName(event.name);
      if (nameError != null) {
        emit(AuthError(message: nameError));
        return;
      }
      
      final emailError = Validators.validateEmail(event.email);
      if (emailError != null) {
        emit(AuthError(message: emailError));
        return;
      }
      
      final passwordError = Validators.validatePassword(event.password);
      if (passwordError != null) {
        emit(AuthError(message: passwordError));
        return;
      }
      
      final confirmPasswordError = Validators.validateConfirmPassword(
        event.password, 
        event.confirmPassword
      );
      if (confirmPasswordError != null) {
        emit(AuthError(message: confirmPasswordError));
        return;
      }
     
      // Simulasi API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Setelah registrasi sukses, buat user baru
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: event.email,
        name: event.name,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
      await prefs.setBool(_isLoggedInKey, true);
      
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: 'Registrasi gagal: ${e.toString()}'));
    }
  }

  /// Handler untuk proses logout
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_isLoggedInKey);  // <-- Gunakan konstanta
      await prefs.remove(_userKey);        // <-- Gunakan konstanta
      
      // Simulasi API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: 'Logout gagal: ${e.toString()}'));
    }
  }
}

