class User {
  static int id = -1;
  static String name = '';
  static String email = '';

  static void setValues(int newId, String newName, String newEmail) {
    id = newId;
    name = newName;
    email = newEmail;
  }
}