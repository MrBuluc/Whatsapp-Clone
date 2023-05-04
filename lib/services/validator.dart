class Validator {
  static String? textControl(String? text, String label) {
    RegExp regex = RegExp(
        "^[abcçdefgğhıijklmnoöprsştuüvyzqwxABCÇDEFGHIİJKLMNOÖPRSŞTUÜVYZQWX]+\$");
    if (!regex.hasMatch(text!)) {
      return "$label have to have not number or space";
    }
    return null;
  }
}
