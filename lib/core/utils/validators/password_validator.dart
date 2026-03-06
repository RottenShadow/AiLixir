abstract class PasswordValidator {
  static bool hasUppercase(String password) =>
      RegExp(r'[A-Z]').hasMatch(password);

  static bool hasLowercase(String password) =>
      RegExp(r'[a-z]').hasMatch(password);

  static bool hasDigit(String password) => RegExp(r'[0-9]').hasMatch(password);

  static bool hasSpecialChar(String password) =>
      RegExp(r'[!@#\$&*~]').hasMatch(password);

  static bool hasMinLength(String password) => password.length >= 8;

  static List<String> validate(String password) {
    final errors = <String>[];
    if (!hasMinLength(password)) {
      errors.add("Must be at least 8 characters long");
    }
    if (!hasLowercase(password)) {
      errors.add("Must contain at least one lowercase letter");
    }
    if (!hasUppercase(password)) {
      errors.add("Must contain at least one uppercase letter");
    }
    if (!hasDigit(password)) errors.add("Must contain at least one number");
    if (!hasSpecialChar(password)) {
      errors.add("Must contain at least one special character");
    }
    return errors;
  }
}
