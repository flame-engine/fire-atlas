RegExp _regExp = new RegExp(
    r"^[0-9]+",
    caseSensitive: false,
    multiLine: false,
);

bool isValidNumber(String value) => _regExp.hasMatch(value);
