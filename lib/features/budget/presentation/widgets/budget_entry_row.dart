import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BudgetEntry {
  BudgetEntry(String name, String amount)
      : nameCtrl = TextEditingController(text: name),
        amountCtrl = TextEditingController(text: amount);

  final TextEditingController nameCtrl;
  final TextEditingController amountCtrl;

  void dispose() {
    nameCtrl.dispose();
    amountCtrl.dispose();
  }
}

class BudgetEntryRow extends StatelessWidget {
  const BudgetEntryRow({
    super.key,
    required this.entry,
    required this.onRemove,
    required this.amountLabel,
  });

  final BudgetEntry entry;
  final VoidCallback? onRemove;
  final String amountLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: entry.nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Name',
                isDense: true,
              ),
              textCapitalization: TextCapitalization.words,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: entry.amountCtrl,
              decoration: InputDecoration(
                labelText: '₹$amountLabel',
                isDense: true,
                prefixText: '₹ ',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(Icons.close,
                  size: 16,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.4)),
              onPressed: onRemove,
            ),
          ] else
            const SizedBox(width: 36),
        ],
      ),
    );
  }
}
