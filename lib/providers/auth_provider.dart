import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated, loading }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.uninitialized;
  User? _user;
  String? _error;

  AuthStatus get status => _status;
  User? get user => _user;
  String? get error => _error;
  bool get isSignedIn => _status == AuthStatus.authenticated;

  final SupabaseClient _supabase = Supabase.instance.client;

  AuthProvider() {
    _user = _supabase.auth.currentUser;
    _status = _user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    _supabase.auth.onAuthStateChange.listen((authState) {
      switch (authState.event) {
        case AuthChangeEvent.signedIn:
        case AuthChangeEvent.tokenRefreshed:
          _user = _supabase.auth.currentUser;
          _status = AuthStatus.authenticated;
          _error = null;
          break;
        case AuthChangeEvent.signedOut:
          _user = null;
          _status = AuthStatus.unauthenticated;
          break;
        default:
          break;
      }
      notifyListeners();
    });
  }

  Future<void> signInWithGoogle() async {
    debugPrint('[AkibaFlow] Attempting Google sign-in...');
    try {
      await _socialSignIn(OAuthProvider.google);
      debugPrint('[AkibaFlow] Google sign-in completed, user=${_user?.id}');
    } catch (e) {
      debugPrint('[AkibaFlow] Google sign-in error: $e');
      _error = e.toString();
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  Future<void> signInWithApple() async {
    await _socialSignIn(OAuthProvider.apple);
  }

  Future<void> signInWithEmail(String email, String password) async {
    _setLoading();
    try {
      final res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      ).timeout(const Duration(seconds: 15));
      _user = res.user;
      _status = AuthStatus.authenticated;
      _error = null;
    } on TimeoutException {
      _error = 'Request timed out. Check your internet connection.';
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> signUpWithEmail(String email, String password) async {
    _setLoading();
    try {
      final res = await _supabase.auth.signUp(
        email: email,
        password: password,
      ).timeout(const Duration(seconds: 15));
      _user = res.user;
      _status = AuthStatus.authenticated;
      _error = null;
    } on TimeoutException {
      _error = 'Request timed out. Check your internet connection.';
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<void> _socialSignIn(OAuthProvider provider) async {
    _setLoading();
    try {
      await _supabase.auth.signInWithOAuth(
        provider,
        redirectTo: 'io.supabase.akibaflow://callback',
      );
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  void _setLoading() {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
