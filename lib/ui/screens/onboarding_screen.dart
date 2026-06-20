import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../data/seed_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _occCtrl = TextEditingController();
  String _city = 'Arusha';
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _occCtrl.dispose();
    super.dispose();
  }

  static const _fields = [
    ["Full Name", "name"],
    ["Phone", "phone"],
    ["Occupation", "occupation"],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Welcome to Akiba Flow',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1D9E75),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tell us a bit about yourself',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 32),
                      ..._fields.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final label = entry.value[0];
                        final key = entry.value[1];
                        final ctrl = switch (key) {
                          'phone' => _phoneCtrl,
                          'occupation' => _occCtrl,
                          _ => _nameCtrl,
                        };
                        final icon = switch (key) {
                          'phone' => Icons.phone_rounded,
                          'occupation' => Icons.work_rounded,
                          _ => Icons.person_rounded,
                        };
                        final keyboard = switch (key) {
                          'phone' => TextInputType.phone,
                          _ => TextInputType.text,
                        };
                        return Padding(
                          padding: EdgeInsets.only(bottom: idx < _fields.length - 1 ? 16 : 0),
                          child: TextFormField(
                            controller: ctrl,
                            keyboardType: keyboard,
                            textCapitalization: key == 'name' || key == 'occupation'
                                ? TextCapitalization.words
                                : TextCapitalization.none,
                            style: const TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                              labelText: label,
                              prefixIcon: key == 'phone'
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 12, right: 4),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text('🇹🇿', style: TextStyle(fontSize: 20)),
                                          const SizedBox(width: 6),
                                          Text('+255',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey.shade700,
                                              )),
                                        ],
                                      ),
                                    )
                                  : Icon(icon, size: 20),
                              prefixIconConstraints: key == 'phone'
                                  ? const BoxConstraints(minWidth: 0, minHeight: 0)
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF5F5F5),
                              contentPadding: key == 'phone'
                                  ? const EdgeInsets.only(left: 110, top: 14, bottom: 14, right: 16)
                                  : const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Please enter your $label';
                              }
                              return null;
                            },
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: _city,
                        decoration: InputDecoration(
                          labelText: 'City / Region',
                          prefixIcon: const Icon(Icons.location_on_rounded, size: 20),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        items: kTanzaniaRegions.map((r) => DropdownMenuItem(
                          value: r,
                          child: Text(r, style: const TextStyle(fontSize: 14)),
                        )).toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _city = v);
                        },
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Please select your city/region';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _saving ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1D9E75),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: _saving
                              ? const SizedBox(
                                  width: 20, height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Text(
                                  'Get Started',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final prov = context.read<DashboardProvider>();
    await prov.saveUserProfile(
      name: _nameCtrl.text.trim(),
      phone: '+255${_phoneCtrl.text.trim()}',
      occupation: _occCtrl.text.trim(),
      city: _city,
    );
  }
}
