import 'package:flutter/material.dart';
import 'package:intellibook_test/pages/search_transacton_page/search_transaction_page.dart';

import '/flutter_flow/flutter_flow_util.dart';

class SearchTransactonPageModel
    extends FlutterFlowModel<SearchTransactionPage> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  DateTime? datePicked;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
