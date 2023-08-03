/// Thrown when a user tries to sign up with an email that is already in use
class InvalidGroupCodeError implements ArgumentError {
  final String _groupCode;

  /// Creates a new [InvalidGroupCodeError]
  ///
  /// The [groupCode] is the group code that is invalid
  InvalidGroupCodeError({required String groupCode}) : _groupCode = groupCode;

  @override
  get invalidValue => _groupCode;

  @override
  get message => "The group code \"$invalidValue\" does not belong to any groups";

  @override
  String? get name => "groupCode";

  @override
  StackTrace? get stackTrace => StackTrace.current;
}
