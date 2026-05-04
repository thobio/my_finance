import 'package:flutter/material.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../domain/models/transaction_type.dart';
import 'transaction_filter_chips.dart';

class TransactionsHeader extends StatelessWidget {
  const TransactionsHeader({
    super.key,
    required this.searchController,
    required this.onSearch,
    required this.typeFilter,
    required this.onTypeFilter,
    required this.onCsvImport,
    this.onCsvExport,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final TransactionType? typeFilter;
  final ValueChanged<TransactionType?> onTypeFilter;
  final VoidCallback onCsvImport;
  final VoidCallback? onCsvExport;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Transactions',
                  style: AppTextStyles.headlineMedium
                      .copyWith(color: theme.colorScheme.onSurface),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.download_outlined),
                tooltip: 'Export CSV',
                onPressed: onCsvExport,
              ),
              IconButton(
                icon: const Icon(Icons.upload_file_outlined),
                tooltip: 'Import statement (CSV, PDF, Excel)',
                onPressed: onCsvImport,
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: searchController,
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: 'Search transactions…',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        searchController.clear();
                        onSearch('');
                      },
                    )
                  : null,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          TransactionFilterChips(
            typeFilter: typeFilter,
            onChanged: onTypeFilter,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
