RegExp _regExp = RegExp(
  r'^[0-9]+$',
  caseSensitive: false,
);

bool isValidNumber(String value) => _regExp.hasMatch(value);
