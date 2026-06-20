import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../services/firebase_auth_service.dart';

enum AuthBackend { none, supabase, firebase, both }

class AuthProvider extends ChangeNotifier {
  AuthBackend _activeBackend = AuthBackend.none;
  User? _supabaseUser;
  fb.User? _firebaseUser;
  String? _error;

  AuthBackend get activeBackend => _activeBackend;
  User? get supabaseUser => _supabaseUser;
  fb.User? get firebaseUser => _firebaseUser;
  String? get error => _error;
  bool get isSignedIn => _activeBackend != AuthBackend.none;

  final SupabaseClient _supabase = Supabase.instance.client;
  final FirebaseAuthService _firebaseAuth = FirebaseAuthService();

  AuthProvider() {
    _supabaseUser = _supabase.auth.currentUser;
    _firebaseUser = _firebaseAuth.currentUser;
    if (_supabaseUser != null && _firebaseUser != null) {
      _activeBackend = AuthBackend.both;
    } else if (_supabaseUser != null) {
      _activeBackend = AuthBackend.supabase;
    } else if (_firebaseUser != null) {
      _activeBackend = AuthBackend.firebase;
    }

    _supabase.auth.onAuthStateChange.listen((authState) {
      switch (authState.event) {
        case AuthChangeEvent.signedIn:
        case AuthChangeEvent.tokenRefreshed:
          _supabaseUser = _supabase.auth.currentUser;
          _activeBackend = _firebaseUser != null ? AuthBackend.both : AuthBackend.supabase;
          _error = null;
          break;
        case AuthChangeEvent.signedOut:
          _supabaseUser = null;
          _activeBackend = _firebaseUser != null ? AuthBackend.firebase : AuthBackend.none;
          break;
        default:
          break;
      }
      notifyListeners();
    });

    _firebaseAuth.authStateChanges.listen((fbUser) {
      _firebaseUser = fbUser;
      if (fbUser != null) {
        _activeBackend = _supabaseUser != null ? AuthBackend.both : AuthBackend.firebase;
        _error = null;
      } else {
        _activeBackend = _supabaseUser != null ? AuthBackend.supabase : AuthBackend.none;
      }
      notifyListeners();
    });
  }

  Future<void> signInWithSupabaseGoogle() async {
    debugPrint('[AkibaFlow] Attempting Supabase Google sign-in...');
    try {
      await _socialSignIn(OAuthProvider.google);
      debugPrint('[AkibaFlow] Supabase Google sign-in completed, user=${_supabaseUser?.id}');
    } catch (e) {
      debugPrint('[AkibaFlow] Supabase Google sign-in error: $e');
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> signInWithSupabaseApple() async {
    await _socialSignIn(OAuthProvider.apple);
  }

  Future<void> signInWithSupabaseEmail(String email, String password) async {
    _setLoading();
    try {
      final res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      ).timeout(const Duration(seconds: 15));
      _supabaseUser = res.user;
      _activeBackend = _firebaseUser != null ? AuthBackend.both : AuthBackend.supabase;
      _error = null;
    } on TimeoutException {
      _error = 'Request timed out. Check your internet connection.';
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  Future<void> signUpWithSupabaseEmail(String email, String password) async {
    _setLoading();
    try {
      final res = await _supabase.auth.signUp(
        email: email,
        password: password,
      ).timeout(const Duration(seconds: 15));
      _supabaseUser = res.user;
      _activeBackend = _firebaseUser != null ? AuthBackend.both : AuthBackend.supabase;
      _error = null;
    } on TimeoutException {
      _error = 'Request timed out. Check your internet connection.';
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  Future<void> signInWithFirebaseEmail(String email, String password) async {
    _setLoading();
    try {
      final cred = await _firebaseAuth.signInWithEmail(email, password);
      _firebaseUser = cred.user;
      _activeBackend = _supabaseUser != null ? AuthBackend.both : AuthBackend.firebase;
      _error = null;
    } on fb.FirebaseAuthException catch (e) {
      _error = e.message ?? 'Firebase sign-in failed';
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  Future<void> signUpWithFirebaseEmail(String email, String password) async {
    _setLoading();
    try {
      final cred = await _firebaseAuth.signUpWithEmail(email, password);
      _firebaseUser = cred.user;
      _activeBackend = _supabaseUser != null ? AuthBackend.both : AuthBackend.firebase;
      _error = null;
    } on fb.FirebaseAuthException catch (e) {
      _error = e.message ?? 'Firebase sign-up failed';
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await Future.wait([
      _supabase.auth.signOut(),
      _firebaseAuth.signOut(),
    ]);
    _supabaseUser = null;
    _firebaseUser = null;
    _activeBackend = AuthBackend.none;
    _error = null;
    notifyListeners();
  }

  Future<void> signOutSupabase() async {
    await _supabase.auth.signOut();
    _supabaseUser = null;
    _activeBackend = _firebaseUser != null ? AuthBackend.firebase : AuthBackend.none;
    notifyListeners();
  }

  Future<void> signOutFirebase() async {
    await _firebaseAuth.signOut();
    _firebaseUser = null;
    _activeBackend = _supabaseUser != null ? AuthBackend.supabase : AuthBackend.none;
    notifyListeners();
  }

  Future<void> _socialSignIn(OAuthProvider provider) async {
    try {
      await _supabase.auth.signInWithOAuth(
        provider,
        redirectTo: 'io.supabase.akibaflow://callback',
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void _setLoading() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> signInWithGoogle() => signInWithSupabaseGoogle();
  Future<void> signInWithApple() => signInWithSupabaseApple();
  Future<void> signInWithEmail(String email, String password) => signInWithSupabaseEmail(email, password);
  Future<void> signUpWithEmail(String email, String password) => signUpWithSupabaseEmail(email, password);
}
