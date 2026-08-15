class AppDateUtils {
  AppDateUtils._();

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// Formats a date as "12 May" to match the mockups افتراضى حاليا لحد ما تفرج
  static String shortDate(DateTime date) =>
      '${date.day} ${_months[date.month - 1]}';
}