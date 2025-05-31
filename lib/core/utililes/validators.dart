class Validators {
  static bool isValidUsername(String username) {

    final usernameRegex = RegExp(r'^[a-z0-9]+$');
    return usernameRegex.hasMatch(username);
  }

  static bool isValidPassword(String password) {
  
    if (password.length < 7) return false;

    bool hasUpperCase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowerCase = password.contains(RegExp(r'[a-z]'));
    bool hasNumbers = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return hasUpperCase && hasLowerCase && hasNumbers && hasSpecialCharacters;
  }

  static String? getUsernameError(String username) {
    if (username.isEmpty) {
      return 'Username is required';
    }
    if (username.contains(' ')) {
      return 'Username cannot contain spaces';
    }
    if (username.contains(RegExp(r'[A-Z]'))) {
      return 'Username cannot contain capital letters';
    }
    if (!isValidUsername(username)) {
      return 'Username can only contain lowercase letters and numbers';
    }
    return null;
  }

  static String? getPasswordError(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 7) {
      return 'Password must be at least 7 characters';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one capital letter';
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one small letter';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }
} 