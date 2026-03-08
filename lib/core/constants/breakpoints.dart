// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/constants/breakpoints.dart
// PURPOSE: Responsive layout breakpoint constants
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

abstract final class Breakpoints {
  static const double mobile = 600.0;
  static const double tablet = 1024.0;

  static bool isMobile(double width) => width < tablet;
  static bool isDesktop(double width) => width >= tablet;
}
