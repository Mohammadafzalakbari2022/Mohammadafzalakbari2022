import '../../l10n/app_localizations.dart';

/// Thrown when a customer create/update violates shop uniqueness rules.
class CustomerRepositoryException implements Exception {
  const CustomerRepositoryException(this.code);

  final String code;

  @override
  String toString() => 'CustomerRepositoryException($code)';
}

String customerRepositoryErrorMessage(
  CustomerRepositoryException error,
  AppLocalizations l10n,
) {
  switch (error.code) {
    case 'duplicate_name':
      return l10n.customerDuplicateName;
    case 'duplicate_phone':
      return l10n.customerDuplicatePhone;
    default:
      return l10n.customerDuplicateName;
  }
}
