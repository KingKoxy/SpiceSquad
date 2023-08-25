/// Thrown when a user tries to report a recipe that has already been reported in the last 24 hours.
class TooManyReportsException implements Exception {
  final String _recipeId;

  /// Creates a new [TooManyReportsException] with the given [recipeId]
  const TooManyReportsException(this._recipeId);

  @override
  String toString() => "TooManyReportsException: $_recipeId";
}
