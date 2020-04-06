class Validator{
  static RegExp _emailReg = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static RegExp _passwordReg = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");


  static String ValidateEmail(String email){
    return _IsEmailValid(email) ? '' : 'Email is invalid.';
  }

  static String ValidatePassword(String password){
    //return _IsPasswordValid(password) ? '' : 'Password must be between 8 and 30 characters and contain at least one digit, lowercase and uppercase letters.';
    return password.isNotEmpty ? '' : 'Enter a password.';
  }

  static bool _IsEmailValid(String email){
    return _emailReg.allMatches(email).isNotEmpty;
  }

  static bool _IsPasswordValid(String email){
    return _passwordReg.allMatches(email).isNotEmpty;
  }
}