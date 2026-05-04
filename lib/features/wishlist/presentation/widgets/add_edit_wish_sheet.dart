import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../goals/domain/models/goal_status.dart';
import '../../../goals/presentation/providers/goal_providers.dart';
import '../../domain/models/wish_item.dart';
import '../providers/wish_providers.dart';

class AddEditWishSheet extends ConsumerStatefulWidget {
  const AddEditWishSheet({super.key, this.item});

  final WishItem? item;

  static Future<void> show(BuildContext context, {WishItem? item}) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) => AddEditWishSheet(item: item),
      );

  @override
  ConsumerState<AddEditWishSheet> createState() => _AddEditWishSheetState();
}

class _AddEditWishSheetState extends ConsumerState<AddEditWishSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _cost;
  late DateTime _desiredMonth;
  String? _linkedGoalId;

  bool get _isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _name = TextEditingController(text: item?.name ?? '');
    _cost = TextEditingController(
      text: item != null ? item.estimatedCost.toStringAsFixed(0) : '',
    );
    _desiredMonth = item?.desiredMonth ?? DateTime(DateTime.now().year, DateTime.now().month);
    _linkedGoalId = item?.linkedGoalId;
  }

  @override
  void dispose() {
    _name.dispose();
    _cost.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final goals = ref.watch(goalsProvider).valueOrNull ?? [];
    final activeGoals = goals.where((g) => g.status == GoalStatus.active).toList();

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEdit ? 'Edit Wish' : 'Add to Wish List',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'What do you wish for?',
                hintText: 'e.g. New laptop, Vacation to Goa',
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cost,
              decoration: const InputDecoration(
                labelText: 'Estimated cost (₹)',
                prefixText: '₹ ',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                if (double.tryParse(v) == null) return 'Enter a valid amount';
                return null;
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text('Desired by'),
              subtitle: Text(DateFormat('MMMM y').format(_desiredMonth)),
              onTap: _pickMonth,
            ),
            const Divider(height: 1),
            const SizedBox(height: 4),
            if (activeGoals.isNotEmpty) ...[
              DropdownButtonFormField<String?>(
                initialValue: _linkedGoalId,
                decoration: const InputDecoration(labelText: 'Link to a goal (optional)'),
                items: [
                  const DropdownMenuItem(child: Text('None')),
                  ...activeGoals.map(
                    (g) => DropdownMenuItem(value: g.id, child: Text(g.name)),
                  ),
                ],
                onChanged: (v) => setState(() => _linkedGoalId = v),
              ),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                if (_isEdit)
                  TextButton(
                    onPressed: _delete,
                    style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
                    child: const Text('Delete'),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _submit,
                  child: Text(_isEdit ? 'Save' : 'Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickMonth() async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => _MonthPickerDialog(
        initial: _desiredMonth,
        onSelected: (d) => setState(() => _desiredMonth = d),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final cost = double.parse(_cost.text);
    final ctrl = ref.read(wishControllerProvider.notifier);

    if (_isEdit) {
      await ctrl.update(widget.item!.copyWith(
        name: _name.text.trim(),
        estimatedCost: cost,
        desiredMonth: _desiredMonth,
        linkedGoalId: _linkedGoalId,
      ));
    } else {
      await ctrl.add(
        name: _name.text.trim(),
        estimatedCost: cost,
        desiredMonth: _desiredMonth,
        linkedGoalId: _linkedGoalId,
      );
    }

    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete wish?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(wishControllerProvider.notifier).delete(widget.item!.id);
    if (mounted) Navigator.pop(context);
  }
}

// ── Month Picker Dialog ───────────────────────────────────────────────────────

class _MonthPickerDialog extends StatefulWidget {
  const _MonthPickerDialog({required this.initial, required this.onSelected});

  final DateTime initial;
  final ValueChanged<DateTime> onSelected;

  @override
  State<_MonthPickerDialog> createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<_MonthPickerDialog> {
  late int _year;
  late int _month;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    _year = widget.initial.year;
    _month = widget.initial.month;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => setState(() => _year--),
          ),
          Text('$_year'),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => setState(() => _year++),
          ),
        ],
      ),
      content: SizedBox(
        width: 280,
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: 12,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemBuilder: (ctx, i) {
            final selected = _month == i + 1;
            return InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                setState(() => _month = i + 1);
                widget.onSelected(DateTime(_year, _month));
                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _months[i],
                  style: TextStyle(
                    color: selected
                        ? Theme.of(context).colorScheme.onPrimary
                        : null,
                    fontWeight: selected ? FontWeight.w600 : null,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
