class User {
  static int id = -1;
  static String name = '';
  static String email = '';
  static String photoUrl = '';

  static void setValues(int newId, String newName, String newEmail, String newPhotoUrl) {
    id = newId;
    name = newName;
    email = newEmail;
    photoUrl = newPhotoUrl;
  }
}