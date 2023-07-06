/// This class contains all the endpoints for the API.
abstract class ApiEndpoints {
  /// The base url
  static String get _baseUrl => "http://ravtscheev.com/spicesquad";

  /// The base url for the authentication endpoints
  static String get authBase => "$_baseUrl/auth";

  /// The url for the registering endpoint
  static String get register => "$authBase/register";

  /// The url for the login endpoint
  static String get login => "$authBase/login";

  /// The url for the password resetting endpoint
  static String get resetPassword => "$authBase/resetPassword";

  /// The url for the user getting endpoint
  static String get getUser => "$authBase/getUser";

  /// The url for the logout endpoint
  static String get logout => "$authBase/logout";

  /// The url for the token refreshing endpoint
  static String get refreshToken => "$authBase/refreshToken";

  /// The base url for the admin action endpoints
  static String get adminBase => "$_baseUrl/admin";

  /// The url for admin making endpoint
  static String get makeAdmin => "$adminBase/makeAdmin";

  /// The base url for the group endpoints
  static String get groupBase => "$_baseUrl/group";

  /// The url for the group joining endpoint
  static String get joinGroup => "$groupBase/join";

  /// The base url for the recipe endpoints
  static String get recipeBase => "$_baseUrl/recipe";
}
