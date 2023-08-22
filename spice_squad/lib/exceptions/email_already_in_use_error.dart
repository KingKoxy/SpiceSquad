/// Thrown when a user tries to sign up with an email that is already in use
class EmailAlreadyInUseError implements ArgumentError {
  final String _usedEmail;

  /// Creates a new [EmailAlreadyInUseException]
  ///
  /// The [usedEmail] is the email that is already in use
  EmailAlreadyInUseError({required String usedEmail}) : _usedEmail = usedEmail;

  @override
  get invalidValue => _usedEmail;

  @override
  get message => "The email \"$invalidValue\" is already in use";

  @override
  String? get name => "email";

  @override
  StackTrace? get stackTrace => StackTrace.current;
}
