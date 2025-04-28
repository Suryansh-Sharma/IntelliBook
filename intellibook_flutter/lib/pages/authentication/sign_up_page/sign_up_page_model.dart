import '/flutter_flow/flutter_flow_util.dart';
import 'sign_up_page_widget.dart' show SignUpPageWidget;
import 'package:flutter/material.dart';

class SignUpPageModel extends FlutterFlowModel<SignUpPageWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for UsernameInput widget.
  FocusNode? usernameInputFocusNode;
  TextEditingController? usernameInputTextController;
  String? Function(BuildContext, String?)? usernameInputTextControllerValidator;
  String? _usernameInputTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for ContactInput widget.
  FocusNode? contactInputFocusNode;
  TextEditingController? contactInputTextController;
  String? Function(BuildContext, String?)? contactInputTextControllerValidator;
  String? _contactInputTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for PasswordInput widget.
  FocusNode? passwordInputFocusNode;
  TextEditingController? passwordInputTextController;
  late bool passwordInputVisibility;
  String? Function(BuildContext, String?)? passwordInputTextControllerValidator;
  String? _passwordInputTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for EmailInput widget.
  FocusNode? emailInputFocusNode;
  TextEditingController? emailInputTextController;
  String? Function(BuildContext, String?)? emailInputTextControllerValidator;
  String? _emailInputTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    usernameInputTextControllerValidator =
        _usernameInputTextControllerValidator;
    contactInputTextControllerValidator = _contactInputTextControllerValidator;
    passwordInputVisibility = false;
    passwordInputTextControllerValidator =
        _passwordInputTextControllerValidator;
    emailInputTextControllerValidator = _emailInputTextControllerValidator;
  }

  @override
  void dispose() {
    usernameInputFocusNode?.dispose();
    usernameInputTextController?.dispose();

    contactInputFocusNode?.dispose();
    contactInputTextController?.dispose();

    passwordInputFocusNode?.dispose();
    passwordInputTextController?.dispose();

    emailInputFocusNode?.dispose();
    emailInputTextController?.dispose();
  }
}
