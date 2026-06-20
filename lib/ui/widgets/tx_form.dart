import 'package:flutter/material.dart';
import '../../data/models/transaction.dart';
import '../../theme/app_theme.dart';

class TxForm extends StatefulWidget {
  final Transaction tx;
  final ValueChanged<Transaction> onSave;
  final VoidCallback onCancel;
  final ThemeTokens theme;

  const TxForm({
    super.key,
    required this.tx,
    required this.onSave,
    required this.onCancel,
    required this.theme,
  });

  @override
  State<TxForm> createState() => _TxFormState();
}

class _TxFormState extends State<TxForm> {
  late String _type;
  late TextEditingController _labelCtrl;
  late TextEditingController _amountCtrl;
  late String _date;

  @override
  void initState() {
    super.initState();
    _type = widget.tx.type;
    _labelCtrl = TextEditingController(text: widget.tx.label);
    _amountCtrl = TextEditingController(
      text: widget.tx.amount == 0 ? '' : widget.tx.amount.toString(),
    );
    _date = widget.tx.date;
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  void _save() {
    widget.onSave(Transaction(
      id: widget.tx.id,
      type: _type,
      label: _labelCtrl.text,
      amount: double.tryParse(_amountCtrl.text) ?? 0,
      date: _date,
      category: widget.tx.category,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.theme.card,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: widget.theme.isDark ? 0.4 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.tx.id != 0 ? 'Edit' : 'New'} Transaction',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: widget.theme.text),
          ),
          const SizedBox(height: 12),
          Row(
            children: ['income', 'expense'].map((t) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: t == 'income' ? 0 : 4, right: t == 'expense' ? 0 : 4),
                child: GestureDetector(
                  onTap: () => setState(() => _type = t),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _type == t
                            ? (t == 'income' ? AppColors.green : AppColors.coral)
                            : widget.theme.border,
                        width: 2,
                      ),
                      color: _type == t
                          ? (t == 'income' ? AppColors.greenLight : AppColors.coralLight)
                          : widget.theme.card,
                    ),
                    child: Text(
                      t,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _type == t
                            ? (t == 'income' ? AppColors.green : AppColors.coral)
                            : widget.theme.muted,
                      ),
                    ),
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _labelCtrl,
            decoration: InputDecoration(
              hintText: 'Label',
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              filled: true,
              fillColor: widget.theme.inputBg,
            ),
            style: TextStyle(color: widget.theme.text, fontSize: 13),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _amountCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Amount',
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              filled: true,
              fillColor: widget.theme.inputBg,
            ),
            style: TextStyle(color: widget.theme.text, fontSize: 13),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: 'Date',
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              filled: true,
              fillColor: widget.theme.inputBg,
            ),
            readOnly: true,
            controller: TextEditingController(text: _date),
            style: TextStyle(color: widget.theme.text, fontSize: 13),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.tryParse(_date) ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() {
                  _date = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                });
              }
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _save,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Save', textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: widget.onCancel,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: widget.theme.lightBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Cancel', textAlign: TextAlign.center,
                        style: TextStyle(color: widget.theme.secondary, fontSize: 13)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
