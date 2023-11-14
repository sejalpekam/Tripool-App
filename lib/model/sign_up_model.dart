import 'package:flutter/widgets.dart';

SignupModel createModel(BuildContext context) {
  return SignupModel();
}

class SignupModel {
  TextEditingController? textController1;
  FocusNode? textFieldFocusNode1;

  TextEditingController? textController2;
  FocusNode? textFieldFocusNode2;

  TextEditingController? textController3;
  FocusNode? textFieldFocusNode3;

  TextEditingController? textController4;
  FocusNode? textFieldFocusNode4;

  TextEditingController? textController5;
  FocusNode? textFieldFocusNode5;

  TextEditingController? textController6;
  FocusNode? textFieldFocusNode6;

  bool passwordVisibility = false;

  SignupModel() {}

  void dispose() {
    // Dispose of your controllers and focus nodes here
    textController1?.dispose();
    textFieldFocusNode1?.dispose();

    textController2?.dispose();
    textFieldFocusNode2?.dispose();

    textController3?.dispose();
    textFieldFocusNode3?.dispose();

    textController4?.dispose();
    textFieldFocusNode4?.dispose();

    textController5?.dispose();
    textFieldFocusNode5?.dispose();

    textController6?.dispose();
    textFieldFocusNode6?.dispose();
  }
}
