//Sign in Exceptions
class UserNotFoundException implements Exception {}

class WrongPasswordAuthException implements Exception {}

//Sign up Excpetions
class WeakPasswordAuthException implements Exception {}

class EmailInUseAuthException implements Exception {}

class OperationNotAllowedException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//Generic Auth Excpetions

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
