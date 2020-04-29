import 'dart:io';

class Validator {
  static RegExp _emailReg = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static RegExp _passwordReg =
  RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");
  static RegExp _fullnameReg =
  RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$");

  static String ValidateEmail(String email) {
    return _IsEmailValid(email) ? '' : 'Email is invalid.';
  }


  static String ValidatePassword(String password) {
    //return _IsPasswordValid(password) ? '' : 'Password must be between 8 and 30 characters and contain at least one digit, lowercase and uppercase letters.';
    String error = '';
    if(password.isEmpty) {
      error = 'Password cannot be empty.\n\n';
    }
    return error;
  }

  static String ValidatePasswords(String password,String passwordValidation) {
    //return _IsPasswordValid(password) ? '' : 'Password must be between 8 and 30 characters and contain at least one digit, lowercase and uppercase letters.';
    String error = ValidatePassword(password);

    if(error.isEmpty && password != passwordValidation){
      error = 'Passwords do not match.\n\n';
    }

    return error;
  }

  static String ValidateFullName(String fullname) {
    return _IsFullNameValid(fullname) ? '' : 'Full name is invalid.\n\n';
  }

  static String ValidateGender(String gender) {
    return gender != null ? '' : 'choose gender.\n\n';
  }

  static String ValidateBirthday(DateTime birthday) {
    return birthday != null ? '' : 'choose birthday.\n\n';
  }

  static String ValidateImage(File image) {
    return image != null ? '' : 'choose image.\n\n';
  }

  static bool _IsEmailValid(String email) {
    return _emailReg
        .allMatches(email)
        .isNotEmpty;
  }

  static bool _IsPasswordValid(String email) {
    return _passwordReg
        .allMatches(email)
        .isNotEmpty;
  }

  static bool _IsFullNameValid(String fullname) {
    return _fullnameReg
        .allMatches(fullname)
        .isNotEmpty;
  }

}