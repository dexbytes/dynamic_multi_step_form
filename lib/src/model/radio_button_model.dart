class RadioButtonModel {
  String? elementType;
  ElementConfig? elementConfig;
  String? value;
  Validation? validation;
  bool? valid;

  RadioButtonModel({this.elementType, this.elementConfig, this.value, this.validation, this.valid});

  RadioButtonModel.fromJson(Map<String, dynamic> json) {
    elementType = json['elementType'];
    elementConfig = json['elementConfig'] != null ?  ElementConfig.fromJson(json['elementConfig']) : null;
    value = json['value'];
    validation = json['validation'] != null ?  Validation.fromJson(json['validation']) : null;
    valid = json['valid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['elementType'] = this.elementType;
    if (this.elementConfig != null) {
      data['elementConfig'] = this.elementConfig!.toJson();
    }
    data['value'] = this.value;
    if (this.validation != null) {
      data['validation'] = this.validation!.toJson();
    }
    data['valid'] = this.valid;
    return data;
  }
}

class ElementConfig {
  String? name;
  String? label;
  String? classProperty;
  String? initialValue;
  List<RadioButtonOptions>? options;

  ElementConfig({this.name, this.label, this.classProperty,this.initialValue, this.options});

  ElementConfig.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    label = json['label'];
    classProperty = json.containsKey('class')?json['class']:"";
    if (json['options'] != null) {
      options = <RadioButtonOptions>[];
      json['options'].forEach((v) { options!.add(new RadioButtonOptions.fromJson(v)); });
    }
    initialValue = json.containsKey('initialValue')?json['initialValue']:null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['name'] = this.name;
    data['label'] = this.label;
    data['class'] = this.classProperty;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    data['initialValue'] = this.initialValue;
    return data;
  }
}

class RadioButtonOptions {
  String? value;
  String? displayValue;


  RadioButtonOptions({this.value, this.displayValue});

  RadioButtonOptions.fromJson(Map<String, dynamic> json) {
    value = json.containsKey('value')?json['value']:"";
    displayValue = json.containsKey('displayValue')?json['displayValue']:"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['displayValue'] = this.displayValue;
    return data;
  }
}

class Validation {
  bool? required;
  bool? isReadOnly;
  bool? isDisabled;
  ErrorMessage? errorMessage;

  Validation({this.required, this.isReadOnly, this.isDisabled,this.errorMessage});

  Validation.fromJson(Map<String, dynamic> json) {
    required = json['required'];
    isReadOnly = json['isReadOnly'];
    isDisabled = json['isDisabled'];
    errorMessage = json['errorMessage'] != null ? ErrorMessage.fromJson(json['errorMessage']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['required'] = this.required;
    data['isReadOnly'] = this.isReadOnly;
    data['isDisabled'] = this.isDisabled;
    if (this.errorMessage != null) {
      data['errorMessage'] = this.errorMessage!.toJson();
    }
    return data;
  }
}

class ErrorMessage {
  String? required;


  ErrorMessage({this.required});

  ErrorMessage.fromJson(Map<String, dynamic> json) {
    required = json['required'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['required'] = this.required;
    return data;
  }
}