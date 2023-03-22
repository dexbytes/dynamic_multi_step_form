# Dynamic form

Most of the time, filling out forms with lots of fields can be cumbersome, and this can discourage users from completing the process. This is where a multi-step form comes into play.
Multi-step forms are just as the name implies: a multi-step form is a long form broken down into short pieces. They provide a less daunting experience to the users of your application.

This  flutter package renders a dynamic multi step form with different input fields and step indicator. Step indicator helps to display on which step you are at the moment.  Form fields, field level validations and design elements are managed via JSON, this JSON can store on the server and call through api or it can store in app code as well.
This plugin supports both iOS and Android.

|               | Android   | iOS    |
| :-------------| :---------| :------|
| **Support**   | SDK 21+   | 10.0+  |

# Dynamic form Implementation Guide

## Features

Use this plugin in your Flutter app to:

* To manage dynamic multi step from with different fields from server according to field type.
* Auto manage field validation according to field type.
* Easy to manage field decoration by developers.

## Getting started

This plugin relies on the flutter core.

## Usage

To use the plugin you just need to add dynamic_multi_step_form: ^1.0.0 into your pubspec.yaml file and run pub get.


## Add following into your package's pubspec.yaml (and run an implicit dart pub get):
dynamic_multi_step_form: ^1.0.0

## UI
[this file](./lib/ui_image/multi_step_form.png).

## Example

            Column(
             children: [
            //Get all fields of form
                   DynamicMultiStepFormScreen(jsonString,dynamicFormKey: _formKeyNew, finalSubmitCallBack: (Map<String, dynamic> data) async {
                   Navigator.push(
                   context,MaterialPageRoute(builder: (context) => SecondScreen(data: data)),);},),
                Align(alignment: Alignment.center,
                  child: ElevatedButton(clipBehavior: Clip.hardEdge,
                    onPressed: () async {
                      if(_formKeyNew.currentState!.validateFields()){
                     var data =  _formKeyNew.currentState!.getFormData();
                     if(data!.isNotEmpty){
                       Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) => SecondScreen(data: data)),
                       );
                     }
                     }
                    },
                    child: const Text('Submit Form'),
                    //color: Colors.green,
                  ),
                )
              ],
            )


## Changelog

All notable changes to this project will be documented in [this file](./CHANGELOG.md).

## Issues

To report your issues, submit them directly in the [Issues](https://github.com/dexbytes/dynamic_multi_step_form/issues) section.

## License
[this file](./LICENSE).