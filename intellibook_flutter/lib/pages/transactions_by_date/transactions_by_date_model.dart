import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'transactions_by_date_widget.dart' show TransactionsByDateWidget;
import 'package:flutter/material.dart';

class TransactionsByDateModel
    extends FlutterFlowModel<TransactionsByDateWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for SortByDropDown widget.
  String? sortByDropDownValue;
  FormFieldController<String>? sortByDropDownValueController;
  DateTime? datePicked;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
