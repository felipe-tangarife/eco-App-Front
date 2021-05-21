String validateText(String text) {
  if (text.isEmpty)
    return "Campo requerido";
  return null;
}

String validatePassword(String password) {
  RegExp hasUpper = RegExp(r'[A-Z]');
  RegExp hasLower = RegExp(r'[a-z]');
  RegExp hasDigit = RegExp(r'\d');
  RegExp hasPunct = RegExp(r'[!@#\$&*~-]');

  if (password.isEmpty)
    return "Ingrese la contraseña";
  if (password.length < 9)
    return "La contraseña debe tener mínimo 8 caracteres";
  if (!hasUpper.hasMatch(password))
    return "La contraseña debe tener una letra mayúscula";
  if (!hasLower.hasMatch(password))
    return "La contraseña debe tener una letra minúscula";
  if (!hasDigit.hasMatch(password))
    return "La contraseña debe tener un número";
  if (!hasPunct.hasMatch(password))
    return "La contraseña debe tener un caracter especial";
  return null;
}
