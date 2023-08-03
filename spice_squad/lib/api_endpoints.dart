/// This class contains all the endpoints for the API.
abstract class ApiEndpoints {
  /// The base url
  static String get _baseUrl => "http://ravtscheev.com:3080";

  // Authentication endpoints

  /// The base url for the authentication endpoints
  static String get auth => "$_baseUrl/auth";

  /// The url for the registering endpoint
  static String get register => "$auth/register";

  /// The url for the login endpoint
  static String get login => "$auth/login";

  /// The url for the password resetting endpoint
  static String get resetPassword => "$auth/resetPassword";

  /// The url for the user getting endpoint
  static String get getUser => "$auth/getUser";

  /// The url for the logout endpoint
  static String get logout => "$auth/logout";

  /// The url for the token refreshing endpoint
  static String get refreshToken => "$auth/refreshToken";

  // Recipe endpoints

  /// The base url for the recipe endpoints
  static String get recipe => "$_baseUrl/recipe";

  /// The url for the recipe favourite setting endpoint
  static String get setFavourite => "$recipe/setFavorite";

  /// The url for the recipe reporting endpoint
  static String get report => "$recipe/report";

  // Group endpoints

  /// The base url for the group endpoints
  static String get group => "$_baseUrl/group";

  /// The url for the group joining endpoint
  static String get joinGroup => "$group/join";

  /// The url for the group leaving endpoint
  static String get leaveGroup => "$group/leave";

  // User endpoints

  /// The base url for the user endpoints
  static String get user => "$_baseUrl/user";

  // Ingredient endpoints

  /// The base url for the ingredient endpoints
  static String get ingredients => "$_baseUrl/ingredient";

  /// The url for the ingredient icons endpoint
  static String get ingredientIcons => "$ingredients/icons";

  /// The url for the ingredient names endpoint
  static String get ingredientNames => "$ingredients/names";

  // Admin endpoints

  /// The base url for the admin endpoints
  static String get admin => "$_baseUrl/admin";

  /// The url for admin making endpoint
  static String get makeAdmin => "$admin/makeAdmin";

  /// The url for admin removal endpoint
  static String get removeAdmin => "$admin/removeAdmin";

  /// The url for user kicking endpoint
  static String get kickUser => "$admin/kickUser";

  /// The url for user banning endpoint
  static String get banUser => "$admin/banUser";

  /// The url for recipe censoring endpoint
  static String get setCensored => "$admin/setCensored";

  // Image endpoints

  /// The base url for the image endpoints
  static String get image => "$_baseUrl/image";
}
