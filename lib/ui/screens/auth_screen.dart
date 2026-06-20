import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class AuthScreen extends StatelessWidget {
  final VoidCallback onSignIn;

  const AuthScreen({super.key, required this.onSignIn});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF085041), Color(0xFF1D9E75)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 60,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Akiba Flow',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1D9E75),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Your financial empowerment journey starts here',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Color(0xFF6b7280)),
                  ),
                  const SizedBox(height: 32),
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      return Column(
                        children: [
                          _SocialButton(
                            onTap: () async {
                              await auth.signInWithGoogle();
                              if (auth.isSignedIn && context.mounted) onSignIn();
                            },
                            label: 'Sign in with Google',
                            textColor: const Color(0xFF374151),
                            bgColor: Colors.white,
                            border: Border.all(color: const Color(0xFFdadce0)),
                            child: Image.network(
                              'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.png',
                              width: 22, height: 22,
                              errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata, size: 28, color: Color(0xFF4285F4)),
                            ),
                          ),
                          const SizedBox(height: 14),
                          _SocialButton(
                            onTap: () async {
                              await auth.signInWithApple();
                              if (auth.isSignedIn && context.mounted) onSignIn();
                            },
                            label: 'Sign in with Apple',
                            textColor: Colors.white,
                            bgColor: Colors.black,
                            child: const Icon(Icons.apple, size: 22, color: Colors.white),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              const Expanded(child: Divider(color: Color(0xFFe5e7eb))),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text('OR',
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
                              ),
                              const Expanded(child: Divider(color: Color(0xFFe5e7eb))),
                            ],
                          ),
                          const SizedBox(height: 18),
                          _EmailForm(onSignIn: onSignIn),
                          if (auth.error != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(auth.error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                            ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              const Expanded(child: Divider(color: Color(0xFFe5e7eb))),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text('SECURE & PRIVATE',
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
                              ),
                              const Expanded(child: Divider(color: Color(0xFFe5e7eb))),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'By signing in, you agree to our Terms of Service and Privacy Policy.\nYour data is encrypted and never shared without your consent.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade400, height: 1.5),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailForm extends StatefulWidget {
  final VoidCallback onSignIn;
  const _EmailForm({required this.onSignIn});

  @override
  State<_EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<_EmailForm> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _showForm = false;
  bool _isSignUp = false;
  bool _loading = false;
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!_showForm)
          _SocialButton(
            onTap: () => setState(() => _showForm = true),
            label: 'Continue with Email',
            textColor: const Color(0xFF374151),
            bgColor: Colors.white,
            border: Border.all(color: const Color(0xFFdadce0)),
            child: const Icon(Icons.email_rounded, size: 22, color: Color(0xFF6b7280)),
          )
        else
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFdadce0)),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_rounded, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _obscurePass,
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_rounded, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePass ? Icons.visibility_off_rounded : Icons.visibility_rounded, size: 20),
                      onPressed: () => setState(() => _obscurePass = !_obscurePass),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                if (_isSignUp) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _confirmCtrl,
                    obscureText: _obscureConfirm,
                    style: const TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock_rounded, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirm ? Icons.visibility_off_rounded : Icons.visibility_rounded, size: 20),
                        onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D9E75),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: _loading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text(_isSignUp ? 'Create Account' : 'Sign In',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => setState(() {
                    _isSignUp = !_isSignUp;
                    context.read<AuthProvider>().clearError();
                  }),
                  child: Text(
                    _isSignUp ? 'Already have an account? Sign in' : "Don't have an account? Create one",
                    style: const TextStyle(fontSize: 13, color: Color(0xFF1D9E75), fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _submit() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (email.isEmpty || password.isEmpty) return;

    if (_isSignUp) {
      if (password != _confirmCtrl.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }
      if (password.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password must be at least 6 characters')),
        );
        return;
      }
    }

    final auth = context.read<AuthProvider>();
    auth.clearError();
    setState(() => _loading = true);

    if (_isSignUp) {
      await auth.signUpWithEmail(email, password);
    } else {
      await auth.signInWithEmail(email, password);
    }

    setState(() => _loading = false);

    if (auth.isSignedIn && context.mounted) {
      widget.onSignIn();
    } else if (!_isSignUp && auth.error != null && context.mounted) {
      final err = auth.error!.toLowerCase();
      if (err.contains('invalid login credentials') || err.contains('user not found')) {
        setState(() => _isSignUp = true);
      }
    }
  }
}

class _SocialButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final Color textColor;
  final Color bgColor;
  final BoxBorder? border;
  final Widget child;

  const _SocialButton({
    required this.onTap,
    required this.label,
    required this.textColor,
    required this.bgColor,
    this.border,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          side: border?.top is BorderSide
              ? BorderSide(color: (border!.top).color)
              : null,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            child,
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
