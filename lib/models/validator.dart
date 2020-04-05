class Validator{
  static RegExp _emailReg = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static RegExp _passwordReg = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");


  static String ValidateEmail(String email){
    return IsEmailValid(email) ? '' : null;
  }

  static bool IsEmailValid(String email){
    return _emailReg.allMatches(email).isNotEmpty;
  }

  static bool IsPasswordValid(String email){
    return _passwordReg.allMatches(email).isNotEmpty;
  }
}