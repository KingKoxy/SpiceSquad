class InvalidCredentialsError extends ArgumentError {
  /// Creates a new [InvalidCredentialsError]
  InvalidCredentialsError();

  @override
  get invalidValue => null;

  @override
  get message => "The credentials are invalid";

  @override
  String? get name => null;

  @override
  StackTrace? get stackTrace => StackTrace.current;
}
