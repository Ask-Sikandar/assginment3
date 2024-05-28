import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
  authenticating,
  error,
}

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  AuthState({required this.status, this.user, this.errorMessage});
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState(status: AuthStatus.unauthenticated));

  Future<void> signInWithGoogle() async {
    state = AuthState(status: AuthStatus.authenticating);
    try {
      final User? user = await _authService.signInWithGoogle();
      if (user != null) {
        state = AuthState(status: AuthStatus.authenticated, user: user);
      } else {
        state = AuthState(status: AuthStatus.unauthenticated);
      }
    } on FirebaseAuthException catch (e) {
      state = AuthState(status: AuthStatus.error, errorMessage: e.message);
    } catch (e) {
      state = AuthState(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = AuthState(status: AuthStatus.authenticating);
    try {
      final User? user = await _authService.signInWithEmailAndPassword(email, password);
      if (user != null) {
        state = AuthState(status: AuthStatus.authenticated, user: user);
      } else {
        state = AuthState(status: AuthStatus.unauthenticated);
      }
    } on FirebaseAuthException catch (e) {
      state = AuthState(status: AuthStatus.error, errorMessage: e.message);
    } catch (e) {
      state = AuthState(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    state = AuthState(status: AuthStatus.authenticating);
    try {
      final User? user = await _authService.signUpWithEmailAndPassword(email, password);
      if (user != null) {
        state = AuthState(status: AuthStatus.authenticated, user: user);
      } else {
        state = AuthState(status: AuthStatus.unauthenticated);
      }
    } on FirebaseAuthException catch (e) {
      state = AuthState(status: AuthStatus.error, errorMessage: e.message);
    } catch (e) {
      state = AuthState(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(AuthService());
});