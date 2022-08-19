class DropDownModel {
  String? elementType;
  ElementConfig? elementConfig;
  String? value;
  Validation? validation;
  bool? valid;

  DropDownModel({elementType, elementConfig, value, validation, valid});

  DropDownModel.fromJson(Map<String, dynamic> json) {
    elementType = json['elementType'];
    elementConfig = json['elementConfig'] != null
        ? ElementConfig.fromJson(json['elementConfig'])
        : null;
    value = json['value'];
    validation = json['validation'] != null
        ? Validation.fromJson(json['validation'])
        : null;
    valid = json['valid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['elementType'] = elementType;
    if (elementConfig != null) {
      data['elementConfig'] = elementConfig!.toJson();
    }
    data['value'] = value;
    if (validation != null) {
      data['validation'] = validation!.toJson();
    }
    data['valid'] = valid;
    return data;
  }
}

class ElementConfig {
  String? name;
  String? label;
  String? placeholder;
  String? classProperty;
  List<Options>? options;
  bool? isMultipleSelect;
  bool? isInline;

  ElementConfig(
      {name,
      label,
      placeholder,
      classProperty,
      options,
      isMultipleSelect = false,
      isInline = false});

  ElementConfig.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    label = json['label'];
    placeholder = json['placeholder'];
    classProperty = json.containsKey('class') ? json['class'] : "";
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
    isMultipleSelect =
        json.containsKey('isMulitpleSelect') ? json['isMulitpleSelect'] : false;
    isInline = json.containsKey('isInline') ? json['isInline'] : false;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['label'] = label;
    data['placeholder'] = placeholder;
    data['class'] = classProperty;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    data['isMultipleSelect'] = isMultipleSelect;
    data['isInline'] = isInline;
    return data;
  }
}

class Options {
  String? value;
  String? displayValue;
  bool? checked;

  Options({value, displayValue, checked = false});

  Options.fromJson(Map<String, dynamic> json) {
    value = json.containsKey('value') ? json['value'] : "";
    displayValue = json.containsKey('displayValue') ? json['displayValue'] : "";
    checked = json.containsKey('checked') ? json['checked'] : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['displayValue'] = displayValue;
    data['checked'] = checked;
    return data;
  }
}

class Validation {
  bool? required;
  bool? isReadOnly;
  bool? isDisabled;

  Validation({required, isReadOnly, isDisabled});

  Validation.fromJson(Map<String, dynamic> json) {
    required = json['required'];
    isReadOnly = json['isReadOnly'];
    isDisabled = json['isDisabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['required'] = required;
    data['isReadOnly'] = isReadOnly;
    data['isDisabled'] = isDisabled;
    return data;
  }
}
