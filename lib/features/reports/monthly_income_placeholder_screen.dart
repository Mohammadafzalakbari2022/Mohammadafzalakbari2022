import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

class MonthlyIncomePlaceholderScreen extends StatelessWidget {
  const MonthlyIncomePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.reportsMonthlyIncomeTitle),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.reportsMonthlyIncomePlaceholder,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}

