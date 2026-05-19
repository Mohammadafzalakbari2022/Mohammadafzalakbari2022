// isar_generator resolves @immutable only via foundation, not material.dart.
// ignore: unnecessary_import
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';

const Color _seed = Color(0xFF7C3AED);

/// Semantic button intents — each maps to a distinct vibrant color.
enum PrideButtonVariant { primary, add, edit, delete, cancel, warning, payment }

/// Vibrant semantic colors for actions (add, edit, delete, …).

@immutable
class PrideActionColors extends ThemeExtension<PrideActionColors> {
  const PrideActionColors({
    required this.add,

    required this.onAdd,

    required this.addContainer,

    required this.onAddContainer,

    required this.edit,

    required this.onEdit,

    required this.editContainer,

    required this.onEditContainer,

    required this.delete,

    required this.onDelete,

    required this.deleteContainer,

    required this.onDeleteContainer,

    required this.cancel,

    required this.onCancel,

    required this.cancelContainer,

    required this.onCancelContainer,

    required this.warning,

    required this.onWarning,

    required this.warningContainer,

    required this.onWarningContainer,

    required this.payment,

    required this.onPayment,

    required this.paymentContainer,

    required this.onPaymentContainer,
  });

  final Color add;

  final Color onAdd;

  final Color addContainer;

  final Color onAddContainer;

  final Color edit;

  final Color onEdit;

  final Color editContainer;

  final Color onEditContainer;

  final Color delete;

  final Color onDelete;

  final Color deleteContainer;

  final Color onDeleteContainer;

  final Color cancel;

  final Color onCancel;

  final Color cancelContainer;

  final Color onCancelContainer;

  final Color warning;

  final Color onWarning;

  final Color warningContainer;

  final Color onWarningContainer;

  final Color payment;

  final Color onPayment;

  final Color paymentContainer;

  final Color onPaymentContainer;

  static const PrideActionColors light = PrideActionColors(
    add: Color(0xFF059669),

    onAdd: Colors.white,

    addContainer: Color(0xFFD1FAE5),

    onAddContainer: Color(0xFF064E3B),

    edit: Color(0xFF2563EB),

    onEdit: Colors.white,

    editContainer: Color(0xFFDBEAFE),

    onEditContainer: Color(0xFF1E3A8A),

    delete: Color(0xFFDC2626),

    onDelete: Colors.white,

    deleteContainer: Color(0xFFFEE2E2),

    onDeleteContainer: Color(0xFF7F1D1D),

    cancel: Color(0xFF64748B),

    onCancel: Color(0xFF334155),

    cancelContainer: Color(0xFFF1F5F9),

    onCancelContainer: Color(0xFF334155),

    warning: Color(0xFFD97706),

    onWarning: Colors.white,

    warningContainer: Color(0xFFFEF3C7),

    onWarningContainer: Color(0xFF78350F),

    payment: Color(0xFF0D9488),

    onPayment: Colors.white,

    paymentContainer: Color(0xFFCCFBF1),

    onPaymentContainer: Color(0xFF042F2E),
  );

  static const PrideActionColors dark = PrideActionColors(
    add: Color(0xFF34D399),

    onAdd: Color(0xFF022C22),

    addContainer: Color(0xFF065F46),

    onAddContainer: Color(0xFFD1FAE5),

    edit: Color(0xFF60A5FA),

    onEdit: Color(0xFF172554),

    editContainer: Color(0xFF1E40AF),

    onEditContainer: Color(0xFFDBEAFE),

    delete: Color(0xFFF87171),

    onDelete: Color(0xFF450A0A),

    deleteContainer: Color(0xFF991B1B),

    onDeleteContainer: Color(0xFFFEE2E2),

    cancel: Color(0xFF94A3B8),

    onCancel: Color(0xFFE2E8F0),

    cancelContainer: Color(0xFF334155),

    onCancelContainer: Color(0xFFF1F5F9),

    warning: Color(0xFFFBBF24),

    onWarning: Color(0xFF422006),

    warningContainer: Color(0xFF92400E),

    onWarningContainer: Color(0xFFFEF3C7),

    payment: Color(0xFF2DD4BF),

    onPayment: Color(0xFF042F2E),

    paymentContainer: Color(0xFF115E59),

    onPaymentContainer: Color(0xFFCCFBF1),
  );

  @override
  PrideActionColors copyWith({
    Color? add,

    Color? onAdd,

    Color? addContainer,

    Color? onAddContainer,

    Color? edit,

    Color? onEdit,

    Color? editContainer,

    Color? onEditContainer,

    Color? delete,

    Color? onDelete,

    Color? deleteContainer,

    Color? onDeleteContainer,

    Color? cancel,

    Color? onCancel,

    Color? cancelContainer,

    Color? onCancelContainer,

    Color? warning,

    Color? onWarning,

    Color? warningContainer,

    Color? onWarningContainer,

    Color? payment,

    Color? onPayment,

    Color? paymentContainer,

    Color? onPaymentContainer,
  }) {
    return PrideActionColors(
      add: add ?? this.add,

      onAdd: onAdd ?? this.onAdd,

      addContainer: addContainer ?? this.addContainer,

      onAddContainer: onAddContainer ?? this.onAddContainer,

      edit: edit ?? this.edit,

      onEdit: onEdit ?? this.onEdit,

      editContainer: editContainer ?? this.editContainer,

      onEditContainer: onEditContainer ?? this.onEditContainer,

      delete: delete ?? this.delete,

      onDelete: onDelete ?? this.onDelete,

      deleteContainer: deleteContainer ?? this.deleteContainer,

      onDeleteContainer: onDeleteContainer ?? this.onDeleteContainer,

      cancel: cancel ?? this.cancel,

      onCancel: onCancel ?? this.onCancel,

      cancelContainer: cancelContainer ?? this.cancelContainer,

      onCancelContainer: onCancelContainer ?? this.onCancelContainer,

      warning: warning ?? this.warning,

      onWarning: onWarning ?? this.onWarning,

      warningContainer: warningContainer ?? this.warningContainer,

      onWarningContainer: onWarningContainer ?? this.onWarningContainer,

      payment: payment ?? this.payment,

      onPayment: onPayment ?? this.onPayment,

      paymentContainer: paymentContainer ?? this.paymentContainer,

      onPaymentContainer: onPaymentContainer ?? this.onPaymentContainer,
    );
  }

  @override
  PrideActionColors lerp(ThemeExtension<PrideActionColors>? other, double t) {
    if (other is! PrideActionColors) return this;

    return PrideActionColors(
      add: Color.lerp(add, other.add, t)!,

      onAdd: Color.lerp(onAdd, other.onAdd, t)!,

      addContainer: Color.lerp(addContainer, other.addContainer, t)!,

      onAddContainer: Color.lerp(onAddContainer, other.onAddContainer, t)!,

      edit: Color.lerp(edit, other.edit, t)!,

      onEdit: Color.lerp(onEdit, other.onEdit, t)!,

      editContainer: Color.lerp(editContainer, other.editContainer, t)!,

      onEditContainer: Color.lerp(onEditContainer, other.onEditContainer, t)!,

      delete: Color.lerp(delete, other.delete, t)!,

      onDelete: Color.lerp(onDelete, other.onDelete, t)!,

      deleteContainer: Color.lerp(deleteContainer, other.deleteContainer, t)!,

      onDeleteContainer: Color.lerp(
        onDeleteContainer,
        other.onDeleteContainer,
        t,
      )!,

      cancel: Color.lerp(cancel, other.cancel, t)!,

      onCancel: Color.lerp(onCancel, other.onCancel, t)!,

      cancelContainer: Color.lerp(cancelContainer, other.cancelContainer, t)!,

      onCancelContainer: Color.lerp(
        onCancelContainer,
        other.onCancelContainer,
        t,
      )!,

      warning: Color.lerp(warning, other.warning, t)!,

      onWarning: Color.lerp(onWarning, other.onWarning, t)!,

      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,

      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        t,
      )!,

      payment: Color.lerp(payment, other.payment, t)!,

      onPayment: Color.lerp(onPayment, other.onPayment, t)!,

      paymentContainer: Color.lerp(
        paymentContainer,
        other.paymentContainer,
        t,
      )!,

      onPaymentContainer: Color.lerp(
        onPaymentContainer,
        other.onPaymentContainer,
        t,
      )!,
    );
  }
}

/// Filled / outlined style for a semantic [PrideButtonVariant].

ButtonStyle prideButtonStyle(BuildContext context, PrideButtonVariant variant) {
  final actions = Theme.of(context).extension<PrideActionColors>()!;

  final base = FilledButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),

    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

    elevation: 0,
  );

  switch (variant) {
    case PrideButtonVariant.add:
      return base.copyWith(
        backgroundColor: WidgetStatePropertyAll(actions.add),

        foregroundColor: WidgetStatePropertyAll(actions.onAdd),
      );

    case PrideButtonVariant.edit:
      return base.copyWith(
        backgroundColor: WidgetStatePropertyAll(actions.edit),

        foregroundColor: WidgetStatePropertyAll(actions.onEdit),
      );

    case PrideButtonVariant.delete:
      return base.copyWith(
        backgroundColor: WidgetStatePropertyAll(actions.delete),

        foregroundColor: WidgetStatePropertyAll(actions.onDelete),
      );

    case PrideButtonVariant.warning:
      return base.copyWith(
        backgroundColor: WidgetStatePropertyAll(actions.warning),

        foregroundColor: WidgetStatePropertyAll(actions.onWarning),
      );

    case PrideButtonVariant.payment:
      return base.copyWith(
        backgroundColor: WidgetStatePropertyAll(actions.payment),

        foregroundColor: WidgetStatePropertyAll(actions.onPayment),
      );

    case PrideButtonVariant.cancel:
      return OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        foregroundColor: actions.onCancelContainer,

        side: BorderSide(color: actions.cancel, width: 1.5),

        backgroundColor: actions.cancelContainer,
      );

    case PrideButtonVariant.primary:
      final s = Theme.of(context).colorScheme;

      return base.copyWith(
        backgroundColor: WidgetStatePropertyAll(s.primary),

        foregroundColor: WidgetStatePropertyAll(s.onPrimary),
      );
  }
}

/// Material 3 themes — vibrant accents, airy surfaces, semantic actions.

ThemeData buildPrideLightTheme() {
  final base = ColorScheme.fromSeed(
    seedColor: _seed,

    brightness: Brightness.light,

    dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
  );

  final scheme = base.copyWith(
    primary: const Color(0xFF7C3AED),

    onPrimary: Colors.white,

    primaryContainer: const Color(0xFFEDE9FE),

    onPrimaryContainer: const Color(0xFF4C1D95),

    secondary: const Color(0xFF0D9488),

    onSecondary: Colors.white,

    secondaryContainer: const Color(0xFFCCFBF1),

    onSecondaryContainer: const Color(0xFF042F2E),

    tertiary: const Color(0xFFEA580C),

    onTertiary: Colors.white,

    tertiaryContainer: const Color(0xFFFFEDD5),

    onTertiaryContainer: const Color(0xFF431407),

    error: const Color(0xFFDC2626),

    onError: Colors.white,

    errorContainer: const Color(0xFFFEE2E2),

    onErrorContainer: const Color(0xFF7F1D1D),

    surface: const Color(0xFFF8FAFC),

    surfaceContainerLowest: Colors.white,

    surfaceContainerLow: const Color(0xFFF1F5F9),

    surfaceContainer: const Color(0xFFE8EDF4),

    surfaceContainerHigh: const Color(0xFFCBD5E1),

    surfaceContainerHighest: const Color(0xFF94A3B8),

    outline: const Color(0xFF94A3B8),

    outlineVariant: const Color(0xFFCBD5E1),

    onSurface: const Color(0xFF0F172A),

    onSurfaceVariant: const Color(0xFF475569),

    surfaceTint: _seed,

    shadow: const Color(0xFF0F172A),
  );

  return _buildTheme(scheme, Brightness.light, PrideActionColors.light);
}

ThemeData buildPrideDarkTheme() {
  final base = ColorScheme.fromSeed(
    seedColor: _seed,

    brightness: Brightness.dark,

    dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
  );

  final scheme = base.copyWith(
    primary: const Color(0xFFA78BFA),

    onPrimary: const Color(0xFF2E1065),

    primaryContainer: const Color(0xFF5B21B6),

    onPrimaryContainer: const Color(0xFFEDE9FE),

    secondary: const Color(0xFF2DD4BF),

    onSecondary: const Color(0xFF042F2E),

    secondaryContainer: const Color(0xFF115E59),

    onSecondaryContainer: const Color(0xFFCCFBF1),

    tertiary: const Color(0xFFFDBA74),

    onTertiary: const Color(0xFF431407),

    tertiaryContainer: const Color(0xFF9A3412),

    onTertiaryContainer: const Color(0xFFFFEDD5),

    error: const Color(0xFFF87171),

    onError: const Color(0xFF450A0A),

    errorContainer: const Color(0xFF991B1B),

    onErrorContainer: const Color(0xFFFEE2E2),

    surface: const Color(0xFF12131A),

    surfaceContainerLowest: const Color(0xFF0C0D12),

    surfaceContainerLow: const Color(0xFF181924),

    surfaceContainer: const Color(0xFF1F2230),

    surfaceContainerHigh: const Color(0xFF282C3D),

    surfaceContainerHighest: const Color(0xFF32374A),

    outline: const Color(0xFF64748B),

    outlineVariant: const Color(0xFF3D4458),

    onSurface: const Color(0xFFE8EDF4),

    onSurfaceVariant: const Color(0xFF94A3B8),

    surfaceTint: _seed,
  );

  return _buildTheme(scheme, Brightness.dark, PrideActionColors.dark);
}

ThemeData _buildTheme(
  ColorScheme scheme,

  Brightness brightness,

  PrideActionColors actions,
) {
  final isDark = brightness == Brightness.dark;

  final snackShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  );

  final typography = isDark
      ? Typography.material2021(platform: TargetPlatform.android).white
      : Typography.material2021(platform: TargetPlatform.android).black;
  final textTheme = typography.apply(
    bodyColor: scheme.onSurface,
    displayColor: scheme.onSurface,
  );

  return ThemeData(
    colorScheme: scheme,

    useMaterial3: true,

    brightness: brightness,

    visualDensity: VisualDensity.standard,

    scaffoldBackgroundColor: scheme.surface,

    textTheme: textTheme,

    extensions: [actions],

    appBarTheme: AppBarTheme(
      centerTitle: false,

      scrolledUnderElevation: isDark ? 1 : 0.5,

      backgroundColor: scheme.surfaceContainerLow,

      foregroundColor: scheme.onSurface,

      iconTheme: IconThemeData(color: scheme.onSurface, size: 22),

      actionsIconTheme: IconThemeData(color: scheme.onSurface, size: 22),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size(44, 44)),
        padding: const WidgetStatePropertyAll(EdgeInsets.all(8)),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return actions.cancelContainer.withValues(alpha: 0.35);
          }
          return actions.cancelContainer;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return actions.onCancelContainer.withValues(alpha: 0.45);
          }
          return actions.onCancelContainer;
        }),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 0,

      color: scheme.surfaceContainerLowest,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),

        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.6)),
      ),

      margin: EdgeInsets.zero,

      clipBehavior: Clip.antiAlias,
    ),

    navigationBarTheme: NavigationBarThemeData(
      height: 72,

      backgroundColor: scheme.surfaceContainerLowest,

      surfaceTintColor: Colors.transparent,

      indicatorColor: scheme.primaryContainer,

      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            fontWeight: FontWeight.w700,

            color: scheme.onPrimaryContainer,

            fontSize: 12,
          );
        }

        return TextStyle(
          fontWeight: FontWeight.w500,

          color: scheme.onSurfaceVariant,

          fontSize: 12,
        );
      }),

      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: scheme.primary, size: 26);
        }

        return IconThemeData(color: scheme.onSurfaceVariant, size: 24);
      }),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: actions.add,

      foregroundColor: actions.onAdd,

      elevation: 4,

      highlightElevation: 8,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: scheme.primary,

        foregroundColor: scheme.onPrimary,

        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),

        minimumSize: const Size(64, 44),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        elevation: 0,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: actions.onCancelContainer,

        side: BorderSide(color: actions.cancel, width: 1.5),

        backgroundColor: actions.cancelContainer,

        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),

        minimumSize: const Size(64, 44),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: scheme.primary,

        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),

    chipTheme: ChipThemeData(
      side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.7)),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

      backgroundColor: isDark
          ? scheme.surfaceContainerHigh
          : scheme.surfaceContainerLow,

      labelStyle: TextStyle(
        color: scheme.onSurface,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark
          ? scheme.surfaceContainerLow
          : scheme.surfaceContainerLowest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: scheme.outlineVariant.withValues(alpha: 0.85),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
      labelStyle: TextStyle(color: scheme.onSurfaceVariant),
      hintStyle: TextStyle(
        color: scheme.onSurfaceVariant.withValues(alpha: 0.85),
      ),
    ),

    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      backgroundColor: scheme.surfaceContainerLowest,

      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    ),

    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,

      elevation: 6,

      shape: snackShape,

      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),

    listTileTheme: ListTileThemeData(
      iconColor: scheme.onSurfaceVariant,

      contentPadding: const EdgeInsetsDirectional.only(start: 16, end: 12),

      minVerticalPadding: 12,
    ),

    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant.withValues(alpha: 0.5),

      space: 1,

      thickness: 1,
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return isDark
              ? scheme.onSurface.withValues(alpha: 0.35)
              : scheme.onSurface.withValues(alpha: 0.28);
        }
        if (states.contains(WidgetState.selected)) {
          return scheme.onPrimary;
        }
        return isDark ? scheme.surfaceContainerLowest : Colors.white;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return scheme.surfaceContainerHighest.withValues(alpha: 0.5);
        }
        if (states.contains(WidgetState.selected)) {
          return scheme.primary;
        }
        return isDark
            ? scheme.surfaceContainerHigh
            : scheme.surfaceContainerHigh;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.transparent;
        }
        return scheme.outline;
      }),
    ),

    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return scheme.onSurface.withValues(alpha: 0.28);
        }
        if (states.contains(WidgetState.selected)) {
          return scheme.primary;
        }
        return scheme.outline;
      }),
    ),
  );
}

/// Payment / ledger actions (teal).

ButtonStyle prideLedgerTonalButtonStyle(BuildContext context) {
  return prideButtonStyle(context, PrideButtonVariant.payment);
}

/// Settings and nav tiles — colored icon in a soft circle.

class PrideColoredLeading extends StatelessWidget {
  const PrideColoredLeading({
    super.key,

    required this.icon,

    required this.color,

    this.background,
  });

  final IconData icon;

  final Color color;

  final Color? background;

  @override
  Widget build(BuildContext context) {
    final bg = background ?? color.withValues(alpha: 0.14);

    return Container(
      width: 40,

      height: 40,

      alignment: Alignment.center,

      decoration: BoxDecoration(
        color: bg,

        borderRadius: BorderRadius.circular(12),
      ),

      child: Icon(icon, color: color, size: 22),
    );
  }
}

/// Palette for settings / menu icons (cycle by index).

/// Bottom-nav tab accent (Orders, Customers, Catalog, Reports, Settings).
Color prideNavTabColor(int index) {
  const palette = [
    Color(0xFF7C3AED),
    Color(0xFF2563EB),
    Color(0xFFEA580C),
    Color(0xFF0D9488),
    Color(0xFF64748B),
  ];
  return palette[index % palette.length];
}

Color prideSettingsIconColor(int index) {
  const palette = [
    Color(0xFF7C3AED),

    Color(0xFF059669),

    Color(0xFF2563EB),

    Color(0xFF0D9488),

    Color(0xFFEA580C),

    Color(0xFFDB2777),

    Color(0xFFCA8A04),

    Color(0xFFDC2626),

    Color(0xFF4F46E5),

    Color(0xFF0891B2),
  ];

  return palette[index % palette.length];
}
