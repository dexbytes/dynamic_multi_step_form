class UploadImageModel {
  String? elementType;
  ElementConfig? elementConfig;
  String? value;
  Validation? validation;
  bool? valid;

  UploadImageModel(
      {this.elementType,
      this.elementConfig,
      this.value,
      this.validation,
      this.valid});

  UploadImageModel.fromJson(Map<String, dynamic> json) {
    elementType = json['elementType'];
    elementConfig = json['elementConfig'] != null
        ? new ElementConfig.fromJson(json['elementConfig'])
        : null;
    value = json['value'];
    validation = json['validation'] != null
        ? new Validation.fromJson(json['validation'])
        : null;
    valid = json['valid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
  bool? enableLabel;
  String? initialValue;

  ElementConfig({this.name, this.label, this.enableLabel, this.initialValue});

  ElementConfig.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    label = json['label'] ?? "";
    enableLabel = json['enableLabel'];
    initialValue = json['initialValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['label'] = this.label;
    data['enableLabel'] = this.enableLabel;
    data['initialValue'] = this.initialValue;
    return data;
  }
}

class Validation {
  bool? required;
  bool? isReadOnly;
  bool? isDisabled;
  ErrorMessage? errorMessage;

  Validation(
      {this.required, this.isReadOnly, this.isDisabled, this.errorMessage});

  Validation.fromJson(Map<String, dynamic> json) {
    required = json['required'];
    isReadOnly = json['isReadOnly'];
    isDisabled = json['isDisabled'];
    errorMessage = json['errorMessage'] != null
        ? new ErrorMessage.fromJson(json['errorMessage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['required'] = this.required;
    return data;
  }
}
