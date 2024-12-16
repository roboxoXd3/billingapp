class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
}
