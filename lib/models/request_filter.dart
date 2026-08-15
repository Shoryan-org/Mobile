/// Filter options shown as chips at the top of the Requests screen.
enum RequestFilter {
  all('All'),
  compatible('Compatible'),
  critical('Critical'),
  routine('Routine');

  final String label;

  const RequestFilter(this.label);
}