class AppDateUtils {
  AppDateUtils._();

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static String shortDate(DateTime date) =>
      '${date.day} ${_months[date.month - 1]}';

  static String fullDate(DateTime date) => '${shortDate(date)} ${date.year}';
}