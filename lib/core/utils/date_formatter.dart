// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/core/utils/date_formatter.dart
// PURPOSE: Human-readable date/time formatting for chat timestamps
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

abstract final class DateFormatter {
  /// Formats a timestamp for display in chat bubbles.
  ///
  /// Returns "HH:mm" for today, "Yesterday" for yesterday,
  /// day name for this week, or "dd/MM/yyyy" otherwise.
  static String formatMessageTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final difference = today.difference(messageDay).inDays;

    if (difference == 0) {
      return _twoDigit(dateTime.hour, dateTime.minute);
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return _dayName(dateTime.weekday);
    } else {
      return '${_twoDigitNum(dateTime.day)}/${_twoDigitNum(dateTime.month)}'
          '/${dateTime.year}';
    }
  }

  /// Formats a timestamp for session list previews.
  ///
  /// Same as [formatMessageTime] but includes time for non-today dates.
  static String formatSessionTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final difference = today.difference(messageDay).inDays;

    final time = _twoDigit(dateTime.hour, dateTime.minute);

    if (difference == 0) {
      return time;
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return _dayName(dateTime.weekday);
    } else {
      return '${_twoDigitNum(dateTime.day)}/${_twoDigitNum(dateTime.month)}'
          '/${dateTime.year}';
    }
  }

  /// Formats a date for timestamp dividers between message groups.
  static String formatDivider(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final difference = today.difference(messageDay).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return _dayName(dateTime.weekday);
    } else {
      return '${_dayName(dateTime.weekday)}, '
          '${_twoDigitNum(dateTime.day)}/${_twoDigitNum(dateTime.month)}'
          '/${dateTime.year}';
    }
  }

  static String _twoDigit(int hour, int minute) =>
      '${_twoDigitNum(hour)}:${_twoDigitNum(minute)}';

  static String _twoDigitNum(int n) => n.toString().padLeft(2, '0');

  static String _dayName(int weekday) => switch (weekday) {
        1 => 'Monday',
        2 => 'Tuesday',
        3 => 'Wednesday',
        4 => 'Thursday',
        5 => 'Friday',
        6 => 'Saturday',
        7 => 'Sunday',
        _ => '',
      };
}
