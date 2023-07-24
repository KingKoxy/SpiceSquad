/// Thrown when a user tries to sign up with an email that is already in use
class EmailAlreadyInUseError implements ArgumentError {
  final String _invalidValue;

  /// Creates a new [EmailAlreadyInUseException] with the given [invalidValue]
  EmailAlreadyInUseError(this._invalidValue);

  @override
  get invalidValue => _invalidValue;

  @override
  get message => "The email \"$invalidValue\" is already in use";

  @override
  String? get name => "email";

  @override
  StackTrace? get stackTrace => StackTrace.current;
}
