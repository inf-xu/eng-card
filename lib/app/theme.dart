import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  const scheme = ColorScheme.light(
    primary: Color(0xFF1E6B57),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color.fromARGB(251, 107, 200, 125),
    onSecondary: Color(0xFF23130B),
    tertiary: Color(0xFF2E5B87),
    surface: Color(0xFFF7F3EA),
    onSurface: Color(0xFF1F2420),
    surfaceContainerLowest: Color(0xFFFFFCF4),
    surfaceContainerLow: Color(0xFFFDF8EE),
    surfaceContainer: Color(0xFFF0E8DC),
    outline: Color(0xFFCFC5B6),
    outlineVariant: Color(0xFFE6DCCF),
  );
  return _buildTheme(scheme: scheme, brightness: Brightness.light);
}

ThemeData buildDarkTheme() {
  const scheme = ColorScheme.dark(
    primary: Color(0xFF7ED6B4),
    onPrimary: Color(0xFF0D271F),
    secondary: Color(0xFFFFB27A),
    onSecondary: Color(0xFF332013),
    tertiary: Color(0xFF9FC7F0),
    surface: Color(0xFF151915),
    onSurface: Color(0xFFECE6D8),
    surfaceContainerLowest: Color(0xFF10130F),
    surfaceContainerLow: Color(0xFF1D231E),
    surfaceContainer: Color(0xFF283028),
    outline: Color(0xFF58645A),
    outlineVariant: Color(0xFF384139),
  );
  return _buildTheme(scheme: scheme, brightness: Brightness.dark);
}

ThemeData _buildTheme({
  required ColorScheme scheme,
  required Brightness brightness,
}) {
  final textTheme = Typography.material2021(platform: TargetPlatform.iOS).black
      .apply(
        fontFamily: 'Georgia',
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      );

  return ThemeData(
    colorScheme: scheme,
    brightness: brightness,
    useMaterial3: true,
    scaffoldBackgroundColor: scheme.surface,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.w700,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: scheme.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: scheme.surfaceContainer,
      selectedColor: scheme.primary.withValues(alpha: 0.18),
      labelStyle: TextStyle(color: scheme.onSurface),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 48),
        side: BorderSide(color: scheme.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 0,
      highlightElevation: 0,
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerLow,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: scheme.primary, width: 1.5),
      ),
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      backgroundColor: scheme.surface,
      indicatorColor: scheme.primary.withValues(alpha: 0.14),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
          color: states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.onSurface.withValues(alpha: 0.72),
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.onSurface.withValues(alpha: 0.62),
        ),
      ),
    ),
  );
}
