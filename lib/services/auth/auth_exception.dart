//Login
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

//Register
class WeakPassAuthException implements Exception {}

class EmailAlreadyUsedAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//generate
class GenericAuthException implements Exception {}

class UserNotLoginAuthException implements Exception {}
