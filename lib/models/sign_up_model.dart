import 'package:flutter/widgets.dart';

SignupModel createModel(BuildContext context) {
  return SignupModel();
}

class SignupModel {
  late TextEditingController? textController1;
  late FocusNode? textFieldFocusNode1;

  late TextEditingController? textController2;
  late FocusNode? textFieldFocusNode2;

  late TextEditingController? textController3;
  late FocusNode? textFieldFocusNode3;

  late TextEditingController? textController4;
  late FocusNode? textFieldFocusNode4;

  late TextEditingController? textController5;
  late FocusNode? textFieldFocusNode5;

  late TextEditingController? textController6;
  late FocusNode? textFieldFocusNode6;

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
