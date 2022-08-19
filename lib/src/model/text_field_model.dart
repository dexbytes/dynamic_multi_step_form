class TextFieldModel {
  String? elementType;
  ElementConfig? elementConfig;
  Help? help;
  String? value;
  Validation? validation;
  Map<String, dynamic>? validationStr;
  bool? valid;
  bool? onchange;

  TextFieldModel(
      {this.elementType,
      this.elementConfig,
      this.help,
      this.value,
      this.validation,
      this.validationStr,
      this.valid,
      this.onchange});

  TextFieldModel.fromJson(Map<String, dynamic> json) {
    elementType = json['elementType'];
    elementConfig = json['elementConfig'] != null
        ? ElementConfig.fromJson(json['elementConfig'])
        : null;
    help = !json.containsKey('help')
        ? null
        : json['help'] != null
            ? Help.fromJson(json['help'])
            : null;
    value = json['value'];
    validation = json['validation'] != null
        ? Validation.fromJson(json['validation'])
        : null;
    validationStr = json['validation'];
    valid = json['valid'];
    onchange = json['onchange'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['elementType'] = elementType;
    if (elementConfig != null) {
      data['elementConfig'] = elementConfig!.toJson();
    }
    if (help != null) {
      data['help'] = help!.toJson();
    }
    data['value'] = value;
    if (validation != null) {
      data['validation'] = validation!.toJson();
    }
    data['valid'] = valid;
    data['onchange'] = onchange;
    data['validationStr'] = validationStr;
    return data;
  }
}

class ElementConfig {
  String? type;
  String? textCapitalization;
  String? name;
  String? label;
  bool? enableLabel;
  String? placeholder;
  String? classProperty;
  String? keyboardRejex;
  bool? resetIcon;
  String? nextName;
  int? minLine;
  int? maxLine;

  ElementConfig(
      {this.type,
      this.textCapitalization,
      this.name,
      this.keyboardRejex = "",
      this.label,
      this.enableLabel,
      this.placeholder,
      this.classProperty,
      this.resetIcon,
      this.nextName,
      this.minLine = 1,
      this.maxLine = 2});

  ElementConfig.fromJson(Map<String, dynamic> json) {
    type = json['type'];

    textCapitalization = json.containsKey('textCapitalization')
        ? json['textCapitalization']
        : "none";
    name = json['name'];
    label = json['label'];
    if (json.containsKey('enableLabel')) {
      enableLabel = json['enableLabel'];
    }
    keyboardRejex =
        json.containsKey('keyboardRejex') ? json['keyboardRejex'] : "";

    placeholder = json['placeholder'];
    classProperty = json['class'];
    resetIcon = json['resetIcon'];
    nextName = json['nextName'];
    maxLine = json.containsKey('maxLine') ? json['maxLine'] : 1;
    minLine = json.containsKey('minLine') ? json['minLine'] : 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['textCapitalization'] = textCapitalization;
    data['type'] = type;
    data['name'] = name;
    data['keyboardRejex'] = keyboardRejex;
    data['label'] = label;
    data['enableLabel'] = enableLabel;
    data['placeholder'] = placeholder;
    data['class'] = classProperty;
    data['resetIcon'] = resetIcon;
    data['nextName'] = nextName;
    data['maxLine'] = maxLine;
    data['minLine'] = minLine;
    return data;
  }
}

class Help {
  String? text;
  String? placement;

  Help({text, this.placement});

  Help.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    placement = json['placement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['placement'] = placement;
    return data;
  }
}

class Validation {
  bool? required;
  int? minLength;
  int? maxLength;
  String? rejex;
  bool? isReadOnly;
  bool? isDisabled;
  ErrorMessage? errorMessage;

  Validation(
      {this.required,
      this.minLength,
      this.maxLength,
      this.rejex,
      this.isReadOnly = false,
      this.isDisabled = false,
      this.errorMessage});

  Validation.fromJson(Map<String, dynamic> json) {
    required = json['required'];
    minLength = json.containsKey('minLength') ? json['minLength'] : 10;
    maxLength = json.containsKey('maxLength') ? json['maxLength'] : 50;
    rejex = json.containsKey('rejex') ? json['rejex'] : "";
    isReadOnly = json.containsKey('isReadOnly') ? json['isReadOnly'] : false;
    isDisabled = json.containsKey('isDisabled') ? json['isDisabled'] : false;
    errorMessage = json['errorMessage'] != null
        ? ErrorMessage.fromJson(json['errorMessage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['required'] = required;
    data['minLength'] = minLength;
    data['maxLength'] = maxLength;
    data['rejex'] = rejex;
    data['isReadOnly'] = isReadOnly;
    data['isDisabled'] = isDisabled;
    if (errorMessage != null) {
      data['errorMessage'] = errorMessage!.toJson();
    }
    return data;
  }
}

class ErrorMessage {
  String? required;
  String? minLength;
  String? maxLength;
  String? rejex;

  ErrorMessage({this.required, this.minLength, this.maxLength, this.rejex});

  ErrorMessage.fromJson(Map<String, dynamic> json) {
    required = json['required'];
    minLength = json['minLength'];
    maxLength = json['maxLength'];
    rejex = json['rejex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['required'] = required;
    data['minLength'] = minLength;
    data['maxLength'] = maxLength;
    data['rejex'] = rejex;
    return data;
  }
}
