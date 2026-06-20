import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../data/seed_data.dart';
import '../widgets/currency_selector.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _editing = false;
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _occCtrl;

  @override
  void initState() {
    super.initState();
    final prov = context.read<DashboardProvider>();
    _nameCtrl = TextEditingController(text: prov.profile.name);
    _phoneCtrl = TextEditingController(text: prov.profile.phone);
    _occCtrl = TextEditingController(text: prov.profile.occupation);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _occCtrl.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    if (_editing) {
      final prov = context.read<DashboardProvider>();
      prov.saveProfile();
    }
    setState(() => _editing = !_editing);
  }

  void _cancelEdit() {
    final prov = context.read<DashboardProvider>();
    prov.cancelEditingProfile();
    _nameCtrl.text = prov.profile.name;
    _phoneCtrl.text = prov.profile.phone;
    _occCtrl.text = prov.profile.occupation;
    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, prov, _) {
        final t = prov.themeTokens;
        return Scaffold(
          backgroundColor: t.bg,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: t.text),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('Settings', style: TextStyle(color: t.text, fontWeight: FontWeight.w600)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              if (_editing)
                IconButton(
                  icon: Icon(Icons.close_rounded, color: t.muted),
                  onPressed: _cancelEdit,
                ),
              IconButton(
                icon: Icon(_editing ? Icons.check_rounded : Icons.edit_rounded,
                    color: _editing ? AppColors.primary : t.muted),
                onPressed: _toggleEdit,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: Column(
              children: [
                _profilePhoto(t),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(prov.profile.name,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: t.text)),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _toggleEdit,
                      child: Icon(Icons.edit_rounded, size: 16, color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _sectionCard(t,
                  child: Column(
                    children: [
                      _field(t, 'Full Name', _nameCtrl, prov.profile.name, prov, _editing),
                      const Divider(height: 1, color: Color(0xFFE7E5E4)),
                      _field(t, 'Phone', _phoneCtrl, prov.profile.phone, prov, _editing),
                      const Divider(height: 1, color: Color(0xFFE7E5E4)),
                      _field(t, 'Occupation', _occCtrl, prov.profile.occupation, prov, _editing),
                      const Divider(height: 1, color: Color(0xFFE7E5E4)),
                      _cityField(t, prov),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text('Preferences'.toUpperCase(),
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: t.muted, letterSpacing: 1)),
                const SizedBox(height: 12),
                _sectionCard(t,
                  child: Column(
                    children: [
                      _prefRow(t, 'Currency',
                        CurrencySelector(currency: prov.currency, onSelect: prov.setCurrency, theme: t),
                      ),
                      const Divider(height: 1, color: Color(0xFFE7E5E4)),
                      _prefRow(t, 'Dark Mode',
                        Switch(
                          value: prov.isDark,
                          onChanged: (_) => prov.toggleDarkMode(),
                          activeThumbColor: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text('Account'.toUpperCase(),
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: t.muted, letterSpacing: 1)),
                const SizedBox(height: 12),
                _sectionCard(t,
                  child: Column(
                    children: [
                      _prefRow(t, 'Private Account ID',
                        Text(prov.anonymousId,
                            style: TextStyle(fontSize: 13, color: t.secondary, fontFamily: 'monospace')),
                      ),
                      const Divider(height: 1, color: Color(0xFFE7E5E4)),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          onPressed: () {
                            prov.generateNewAnonymousId();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('New Private Account ID generated')),
                            );
                          },
                          icon: Icon(Icons.refresh_rounded, size: 16, color: AppColors.primary),
                          label: Text('Generate Private Account ID',
                              style: TextStyle(fontSize: 13, color: AppColors.primary)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final auth = context.read<AuthProvider>();
                      final dash = context.read<DashboardProvider>();
                      await auth.signOut();
                      dash.signOut();
                    },
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text('Sign Out'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.coral,
                      side: const BorderSide(color: AppColors.coral),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text('AkibaFlow v1.0.0',
                    style: TextStyle(fontSize: 12, color: t.muted)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _profilePhoto(ThemeTokens t) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 44,
            backgroundColor: const Color(0xFFD6D3D1),
            child: Icon(Icons.person_rounded, size: 48, color: const Color(0xFFA8A29E)),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 28, height: 28,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(ThemeTokens t, String label, TextEditingController ctrl, String value, DashboardProvider prov, bool editing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(label, style: TextStyle(fontSize: 13, color: t.secondary)),
          ),
          Expanded(
            child: editing
                ? TextField(
                    controller: ctrl,
                    onChanged: (v) {
                      if (label == 'Full Name') {
                        prov.updateProfileDraft(name: v);
                      } else if (label == 'Phone') {
                        prov.updateProfileDraft(phone: v);
                      } else if (label == 'Occupation') {
                        prov.updateProfileDraft(occupation: v);
                      }
                    },
                    style: TextStyle(fontSize: 14, color: t.text),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    ),
                  )
                : Text(value, style: TextStyle(fontSize: 14, color: t.text, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _cityField(ThemeTokens t, DashboardProvider prov) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const SizedBox(width: 96, child: Text('City / Region', style: TextStyle(fontSize: 13, color: Color(0xFF78716C)))),
          Expanded(
            child: _editing
                ? DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: prov.profileDraft.city,
                      dropdownColor: t.card,
                      items: kTanzaniaRegions.map((r) => DropdownMenuItem(
                        value: r,
                        child: Text(r, style: TextStyle(color: t.text, fontSize: 14)),
                      )).toList(),
                      onChanged: (v) {
                        if (v != null) prov.updateProfileDraft(city: v);
                      },
                      isExpanded: true,
                    ),
                  )
                : Text('${prov.profile.city}, ${prov.profile.country}',
                    style: TextStyle(fontSize: 14, color: t.text, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _prefRow(ThemeTokens t, String label, Widget trailing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: t.text, fontWeight: FontWeight.w500)),
          trailing,
        ],
      ),
    );
  }

  Widget _sectionCard(ThemeTokens t, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: t.border),
      ),
      child: child,
    );
  }
}
