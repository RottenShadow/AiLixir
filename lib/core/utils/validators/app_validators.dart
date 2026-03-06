import 'password_validator.dart';

enum AppValidatorType {
  email,
  password,
  username,
  dateOfBirth,
  notNull,
  noValidator,
}

abstract class AppValidators {
  static final _emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    caseSensitive: false,
    multiLine: false,
  );
  static final usernameRegex = RegExp(
    r'^[a-zA-Z0-9_]+$',
  );

  static String? validate(AppValidatorType type, String value) {
    switch (type) {
      case AppValidatorType.notNull:
        if (value.isEmpty) {
          return 'Please enter a value';
        }
        return null;
      case AppValidatorType.email:
        if (value.isEmpty) {
          return 'Please enter your email';
        }
        if (!_emailRegex.hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      case AppValidatorType.password:
        var errors = PasswordValidator.validate(value);
        if (errors.isNotEmpty) {
          return errors.first;
        }
        return null;
      case AppValidatorType.username:
        if (value.isEmpty) {
          return 'Please enter your username';
        }
        if (value.length < 3) {
          return 'Username must be at least 3 characters long';
        }
        if (value.length > 30) {
          return 'Username must be at most 30 characters long';
        }
        if (!usernameRegex.hasMatch(value)) {
          return 'Please enter a valid username';
        }
        return null;
      case AppValidatorType.dateOfBirth:
        if (value.isEmpty) {
          return 'Please enter your date of birth';
        }

        try {
          // Split the input by '-'
          final parts = value.split('-');
          if (parts.length != 3) {
            return 'Invalid date format (use MM-DD-YYYY)';
          }

          final month = int.parse(parts[0]);
          final day = int.parse(parts[1]);
          final year = int.parse(parts[2]);

          final dateOfBirth = DateTime(year, day, month);
          final now = DateTime.now();

          int age = now.year - dateOfBirth.year;
          if (now.month < dateOfBirth.month ||
              (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
            age--;
          }

          if (age < 13) {
            return 'You must be at least 13 years old to register';
          }
        } catch (e) {
          return 'Invalid date format (use MM-DD-YYYY)';
        }

        return null;
      case AppValidatorType.noValidator:
        return null;
    }
  }
}
