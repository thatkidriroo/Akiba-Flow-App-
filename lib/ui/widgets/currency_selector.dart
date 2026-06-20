import 'package:flutter/material.dart';
import '../../data/models/currency.dart';
import '../../data/seed_data.dart';
import '../../theme/app_theme.dart';

class CurrencySelector extends StatefulWidget {
  final Currency currency;
  final ValueChanged<Currency> onSelect;
  final ThemeTokens theme;

  const CurrencySelector({
    super.key,
    required this.currency,
    required this.onSelect,
    required this.theme,
  });

  @override
  State<CurrencySelector> createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelector> {
  bool _open = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Currency> get _filtered {
    final q = _searchController.text.toLowerCase();
    if (q.isEmpty) return kCurrencies;
    return kCurrencies.where((c) =>
        c.name.toLowerCase().contains(q) ||
        c.code.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => setState(() => _open = !_open),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.currency.flag, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Text(widget.currency.code,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, color: Colors.white70, size: 16),
              ],
            ),
          ),
        ),
        if (_open)
          Positioned(
            right: 0,
            top: 40,
            child: Material(
              elevation: 24,
              borderRadius: BorderRadius.circular(14),
              color: widget.theme.card,
              child: SizedBox(
                width: 256,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: widget.theme.searchBg,
                        border: Border(bottom: BorderSide(color: widget.theme.border)),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Search currency...',
                          hintStyle: TextStyle(color: widget.theme.muted, fontSize: 13),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: widget.theme.inputBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: widget.theme.inputBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: widget.theme.inputBorder),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          filled: true,
                          fillColor: widget.theme.inputBg,
                        ),
                        style: TextStyle(color: widget.theme.text, fontSize: 13),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 220),
                      child: ListView(
                        shrinkWrap: true,
                        children: _filtered.map((c) => InkWell(
                          onTap: () {
                            widget.onSelect(c);
                            setState(() {
                              _open = false;
                              _searchController.clear();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                            color: widget.currency.code == c.code ? AppColors.primaryLight : Colors.transparent,
                            child: Row(
                              children: [
                                Text(c.flag, style: const TextStyle(fontSize: 18)),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: 36,
                                  child: Text(c.code,
                                      style: TextStyle(fontWeight: FontWeight.w600,                                       color: widget.theme.heading, fontSize: 13)),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(c.name,
                                      style: TextStyle(                                      color: widget.theme.muted, fontSize: 12)),
                                ),
                              ],
                            ),
                          ),
                        )).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
