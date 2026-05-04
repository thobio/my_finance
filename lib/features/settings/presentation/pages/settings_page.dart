import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/theme_provider.dart';
import '../../../auth/domain/models/auth_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final user = ref.watch(authUserProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          if (user != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  if (user.photoURL != null)
                    ClipOval(
                      child: Image.network(
                        user.photoURL!,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (context2, e, trace) => _initials(user),
                      ),
                    )
                  else
                    _initials(user),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (user.displayName?.isNotEmpty == true)
                          Text(
                            user.displayName!,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        Text(
                          user.email ?? '',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
          ],
          const _SectionHeader('Tools'),
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: const Text('Manage Categories'),
            subtitle: const Text('Add, edit, or delete custom categories'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/categories'),
          ),
          const Divider(height: 1, indent: 16),
          ListTile(
            leading: const Icon(Icons.calculate_outlined),
            title: const Text('Tax Estimator'),
            subtitle: const Text('Old vs New regime comparison'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/tax'),
          ),
          const Divider(height: 1, indent: 16),
          const _SectionHeader('Appearance'),
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: const Text('Theme'),
            subtitle: Text(_themeLabel(themeMode)),
            trailing: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: Icon(Icons.dark_mode, size: 16),
                ),
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: Icon(Icons.brightness_auto, size: 16),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: Icon(Icons.light_mode, size: 16),
                ),
              ],
              selected: {themeMode},
              onSelectionChanged: (s) =>
                  ref.read(themeModeProvider.notifier).setTheme(s.first),
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
          const Divider(height: 1, indent: 16),
          const _SectionHeader('Account'),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign out'),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Sign out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Sign out'),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                await ref.read(authRepositoryProvider).signOut();
              }
            },
          ),
          const Divider(height: 1, indent: 16),
          const _SectionHeader('About'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('My Finance'),
            subtitle: Text('v1.0.0'),
          ),
          const ListTile(
            leading: Icon(Icons.security_outlined),
            title: Text('Privacy'),
            subtitle: Text('All data stored locally in your Firebase account'),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  String _themeLabel(ThemeMode mode) => switch (mode) {
        ThemeMode.dark => 'Dark',
        ThemeMode.light => 'Light',
        ThemeMode.system => 'System',
      };
}

Widget _initials(AuthUser user) => CircleAvatar(
      radius: 24,
      child: Text(
        user.displayName?.isNotEmpty == true
            ? user.displayName![0].toUpperCase()
            : '?',
      ),
    );

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              letterSpacing: 1.2,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
