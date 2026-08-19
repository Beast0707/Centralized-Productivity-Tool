/// Centralized route names used by the application.
///
/// Keep route names in one place so screens/widgets do not duplicate
/// string literals such as '/tasks' and '/task'.
abstract final class AppRoutes {
  static const home = '/home';
  static const notes = '/notes';
  static const calendar = '/calendar';
  static const tasks = '/tasks';
  static const vault = '/vault';
}