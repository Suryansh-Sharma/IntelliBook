import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'add_new_transaction_page_widget.dart' show AddNewTransactionPageWidget;
import 'package:flutter/material.dart';

class AddNewTransactionPageModel
    extends FlutterFlowModel<AddNewTransactionPageWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey2 = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  // State field(s) for DropDown widget.
  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;
  // State field(s) for DropDown widget.
  List<String>? dropDownValue2;
  FormFieldController<List<String>>? dropDownValueController2;
  // State field(s) for DescriptionTextField widget.
  FocusNode? descriptionTextFieldFocusNode;
  TextEditingController? descriptionTextFieldTextController;
  String? Function(BuildContext, String?)?
      descriptionTextFieldTextControllerValidator;
  // State field(s) for RadioButton widget.
  FormFieldController<String>? radioButtonValueController;
  // State field(s) for AmmountTextField widget.
  FocusNode? ammountTextFieldFocusNode;
  TextEditingController? ammountTextFieldTextController;
  String? Function(BuildContext, String?)?
      ammountTextFieldTextControllerValidator;
  String? _ammountTextFieldTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Amount is required';
    }

    if (val.isEmpty) {
      return 'Ammount must be greater than 0';
    }

    return null;
  }

  DateTime? datePicked1;
  DateTime? datePicked2;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController4;
  String? Function(BuildContext, String?)? textController4Validator;

  @override
  void initState(BuildContext context) {
    ammountTextFieldTextControllerValidator =
        _ammountTextFieldTextControllerValidator;
  }

  @override
  void dispose() {
    descriptionTextFieldFocusNode?.dispose();
    descriptionTextFieldTextController?.dispose();

    ammountTextFieldFocusNode?.dispose();
    ammountTextFieldTextController?.dispose();

    textFieldFocusNode1?.dispose();
    textController3?.dispose();

    textFieldFocusNode2?.dispose();
    textController4?.dispose();
  }

  /// Additional helper methods.
  String? get radioButtonValue => radioButtonValueController?.value;
}
