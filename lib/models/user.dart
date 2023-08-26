///
/// After auth is ok , the current user is populated
///
class CurrentUser {
  final String displayName;
  final String photoURL;
  final String email;

  CurrentUser({
    required this.email,
    required this.displayName,
    required this.photoURL,
  });
}
