/// Thrown when a user tries to sign up with an email that is already in use
class InvalidGroupCodeError implements ArgumentError {
  final String _invalidValue;

  /// Creates a new [InvalidGroupCodeError] with the given [invalidValue]
  InvalidGroupCodeError(this._invalidValue);

  @override
  get invalidValue => _invalidValue;

  @override
  get message => "The group code \"$invalidValue\" does not belong to any groups";

  @override
  String? get name => "groupCode";

  @override
  StackTrace? get stackTrace => StackTrace.current;
}
