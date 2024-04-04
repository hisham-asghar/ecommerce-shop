abstract class AppUser {
  String get uid;
  String? get email;

  Future<bool> isAdminUser();
}
