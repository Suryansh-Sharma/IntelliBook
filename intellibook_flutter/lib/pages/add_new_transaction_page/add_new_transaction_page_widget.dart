import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_radio_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'add_new_transaction_page_model.dart';
export 'add_new_transaction_page_model.dart';

class AddNewTransactionPageWidget extends StatefulWidget {
  const AddNewTransactionPageWidget({super.key});

  @override
  State<AddNewTransactionPageWidget> createState() =>
      _AddNewTransactionPageWidgetState();
}

class _AddNewTransactionPageWidgetState
    extends State<AddNewTransactionPageWidget> {
  late AddNewTransactionPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime now = DateTime.now();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  List<dynamic> res = [
    {
      'id': 111,
      'name': 'Construction',
      'tags': ['Labour', 'Material', 'Transport']
    },
    {
      'id': 24,
      'name': 'Food',
      'tags': ['Grocery', 'Restaurant', 'Fast Food']
    },
    {
      'id': 13,
      'name': 'Entertainment',
      'tags': ['Movies', 'Games', 'Concerts']
    },
    {
      'id': 43,
      'name': 'Education',
      'tags': ['Books', 'Tuition', 'Stationary']
    },
    {
      'id': 75,
      'name': 'Health',
      'tags': ['Medicine', 'Doctor', 'Hospital']
    },
    {
      'id': 6,
      'name': 'Travel',
      'tags': ['Flight', 'Train', 'Bus']
    },
    {
      'id': 47,
      'name': 'Shopping',
      'tags': ['Clothes', 'Electronics', 'Furniture']
    },
    {
      'id': 82,
      'name': 'Utilities',
      'tags': ['Electricity', 'Water', 'Gas']
    },
    {
      'id': 19,
      'name': 'Others',
      'tags': ['Miscellaneous']
    }
  ];
  List<String> tags = [];

  Map<String, dynamic> formData = {
    'categoryId': 0,
    'categoryName': "",
    'tags': [],
    'description': "",
    'transactionType': "Gave Money",
    'amount': 0.0,
    'date': "",
    'time': ""
  };
  Map<String, String> addNewValues = {'category': '', 'tag': ''};

  void _submitAddNewTransactionForm() {
    // Validate Form Data
    if (_isFormValid()) {
      return;
    } else {
      // Submit Data to API.
    }
  }

  bool _isFormValid() {
    if (formData['categoryId'] == 0) {
      _showAlertDialogute("Please select a category");
      return false;
    } else if (formData['tags'].isEmpty) {
      _showAlertDialogute("Please select atleast one tags");
    } else if (formData['amount'] <= 0.0) {
      _showAlertDialogute("Amount must be greater than 0");
    }

    return true;
  }

  void _addNewCatgory() {
    if (addNewValues['category'] == '') {
      _showAlertDialogute(
          "To add new category, value of category not be empty !!");
      return;
    }
    // Submit Data To Api and add to res.
    setState(() {
      int newCatId = res.isNotEmpty ? res.last['id'] + 1 : 1;
      res.add({'id': newCatId, 'name': addNewValues['category'], 'tags': []});
      formData['categoryId'] = newCatId;
      formData['tags'] = [];
      addNewValues['category'] = '';
      _categoryController.clear();
    });
  }

  void _addNewTag() {
    String tagValue = addNewValues['tag'] ?? '';
    if (tagValue.isEmpty) {
      _showAlertDialogute("To add new tag, value of tag not be empty !!");
      return;
    }
    if (formData['categoryId'] == 0) {
      _showAlertDialogute("To add new tag, please select category first !!");
      return;
    }
    setState(() {
      tags.add(tagValue);
      _tagController.clear();
    });
  }

  void _showAlertDialogute(String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(msg),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddNewTransactionPageModel());

    _model.descriptionTextFieldTextController ??= TextEditingController();
    _model.descriptionTextFieldFocusNode ??= FocusNode();

    _model.ammountTextFieldTextController ??= TextEditingController();
    _model.ammountTextFieldFocusNode ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
    // Initialize Date time

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    formData['date'] = formatter.format(now);
    formData['time'] = DateFormat('HH:mm:ss').format(now);
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFBBEC), Color(0xFFA9C9FF)],
              stops: [0.0, 1.0],
              begin: AlignmentDirectional(0.0, 1.0),
              end: AlignmentDirectional(0, -1.0),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 50.0, 0.0, 0.0),
                    child: Container(
                      width: double.infinity,
                      height: 56.0,
                      decoration: BoxDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 10.0, 0.0, 0.0),
                                  child: Text(
                                    'Add New Transaction',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          fontFamily: 'Inter Tight',
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 700.0,
                  decoration: BoxDecoration(),
                  child: Form(
                    key: _model.formKey2,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(1.0, 0.0, 0.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 15.0, 0.0, 0.0),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 100),
                              curve: Curves.easeIn,
                              width: double.infinity,
                              height: 69.0,
                              decoration: BoxDecoration(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      'Select Transaction Category',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            color: Colors.black,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 3.0, 10.0, 0.0),
                                      child: Container(
                                          height: 48.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 0.0, 12.0, 0.0),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondaryContainer,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface, // Border color
                                              width: 1.0,
                                            ),
                                          ),
                                          child: DropdownButton<int>(
                                            value: formData['categoryId'] == 0
                                                ? null
                                                : formData['categoryId'],
                                            hint: Text(
                                              'Select Category',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color:
                                                    Theme.of(context).hintColor,
                                              ),
                                            ),
                                            isExpanded: true,
                                            icon: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer,
                                              size: 24.0,
                                            ),
                                            items: res.map((item) {
                                              return DropdownMenuItem<int>(
                                                value: item['id']
                                                    as int, // Ensure it's an int
                                                child: Text(
                                                    item['name'] as String),
                                              );
                                            }).toList(),
                                            onChanged: (int? value) {
                                              setState(() {
                                                formData['categoryId'] = value;
                                                formData['tags'] = [];
                                                // Find the selected category safely
                                                var selectedCategory =
                                                    res.firstWhere(
                                                  (item) => item['id'] == value,
                                                  orElse: () =>
                                                      null, // Prevents errors if ID is not found
                                                );

                                                if (selectedCategory != null) {
                                                  tags =
                                                      selectedCategory['tags'];
                                                }
                                              });
                                            },
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 15.0, 0.0, 0.0),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 100),
                              curve: Curves.easeIn,
                              width: double.infinity,
                              height: 71.0,
                              decoration: BoxDecoration(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      'Select Transaction Tags',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            color: Colors.black,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 3.0, 10.0, 0.0),
                                      child: FlutterFlowDropDown<String>(
                                          multiSelectController: _model
                                                  .dropDownValueController2 ??=
                                              FormListFieldController<String>(
                                                  null),
                                          options: tags,
                                          width: double.infinity,
                                          height: 48.0,
                                          searchHintTextStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily: 'Inter',
                                                    letterSpacing: 0.0,
                                                  ),
                                          searchTextStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Inter',
                                                    letterSpacing: 0.0,
                                                  ),
                                          textStyle: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                letterSpacing: 0.0,
                                              ),
                                          hintText: 'Select Tags',
                                          searchHintText: 'Search...',
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 24.0,
                                          ),
                                          fillColor: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          elevation: 2.0,
                                          borderColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                          borderWidth: 0.0,
                                          borderRadius: 8.0,
                                          margin:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 0.0, 12.0, 0.0),
                                          hidesUnderline: true,
                                          isOverButton: false,
                                          isSearchable: true,
                                          isMultiSelect: true,
                                          onMultiSelectChanged: (val) {
                                            formData['tags'] = val;
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 15.0, 12.0, 0.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: TextFormField(
                                  autofocus: false,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: 'Description',
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Inter Tight',
                                          letterSpacing: 0.0,
                                        ),
                                    hintText: 'Enter description',
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          color: Colors.black,
                                          letterSpacing: 0.0,
                                        ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    filled: true,
                                    fillColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            12.0, 0.0, 12.0, 0.0),
                                    prefixIcon: Icon(
                                      Icons.description_sharp,
                                    ),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                      ),
                                  maxLines: null,
                                  onChanged: (value) {
                                    setState(() {
                                      formData['description'] = value;
                                    });
                                  },
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primaryText,
                                  validator: _model
                                      .descriptionTextFieldTextControllerValidator
                                      .asValidator(context),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 15.0, 10.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              height: 54.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        'Select Type',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: FlutterFlowRadioButton(
                                      options: ['Gave Money', 'Received Money']
                                          .toList(),
                                      onChanged: (val) => safeSetState(() {
                                        formData['transactionType'] = val;
                                      }),
                                      controller:
                                          _model.radioButtonValueController ??=
                                              FormFieldController<String>(
                                                  'Gave Money'),
                                      optionHeight: 32.0,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                      selectedTextStyle:
                                          FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                letterSpacing: 0.0,
                                              ),
                                      buttonPosition: RadioButtonPosition.left,
                                      direction: Axis.horizontal,
                                      radioButtonColor: Color(0xFFEF39A6),
                                      inactiveRadioButtonColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryText,
                                      toggleable: false,
                                      horizontalAlignment: WrapAlignment.start,
                                      verticalAlignment:
                                          WrapCrossAlignment.start,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 15.0, 12.0, 0.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: TextFormField(
                                controller:
                                    _model.ammountTextFieldTextController,
                                focusNode: _model.ammountTextFieldFocusNode,
                                autofocus: false,
                                obscureText: false,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                onChanged: (value) {
                                  setState(() {
                                    // Parse the input to double and store it in formData['amount']
                                    try {
                                      formData['amount'] = double.tryParse(
                                              value) ??
                                          0.0; // Default to 0.0 if parsing fails
                                    } catch (e) {
                                      formData['amount'] =
                                          0.0; // Handle invalid input
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: 'Amount',
                                  hintText: 'Enter ammount',
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  filled: true,
                                  fillColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  prefixIcon: Icon(
                                    Icons.currency_rupee,
                                  ),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Inter Tight',
                                      letterSpacing: 0.0,
                                    ),
                                cursorColor:
                                    FlutterFlowTheme.of(context).primaryText,
                                validator: _model
                                    .ammountTextFieldTextControllerValidator
                                    .asValidator(context),
                              ),
                            ),
                          ),

                          // Generated code for this DateTimeRow Widget...
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12, 15, 12, 0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 67,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(-1, 0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 0, 0, 1),
                                            child: Text(
                                              'Select Time',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: Colors.black,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(12, 0, 0, 0),
                                                child: Text(
                                                  formData['time'],
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(2, 2, 2, 2),
                                                child: FlutterFlowIconButton(
                                                  borderRadius: 20,
                                                  buttonSize: 30,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                  icon: Icon(
                                                    Icons.timelapse_sharp,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .info,
                                                    size: 15,
                                                  ),
                                                  onPressed: () async {
                                                    // TimePicker
                                                    final pickedTime =
                                                        await showTimePicker(
                                                      context: context,
                                                      initialTime: TimeOfDay
                                                          .fromDateTime(
                                                              getCurrentTimestamp),
                                                      builder:
                                                          (context, child) {
                                                        return wrapInMaterialTimePickerTheme(
                                                          context,
                                                          child!,
                                                          headerBackgroundColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .primary,
                                                          headerForegroundColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .info,
                                                          headerTextStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineLarge
                                                                  .override(
                                                                    fontFamily:
                                                                        'Inter Tight',
                                                                    fontSize:
                                                                        32,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                          pickerBackgroundColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                          pickerForegroundColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .primaryText,
                                                          selectedDateTimeBackgroundColor:
                                                              Color(0xFFE839EF),
                                                          selectedDateTimeForegroundColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .info,
                                                          actionButtonForegroundColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .primaryText,
                                                          iconSize: 24,
                                                        );
                                                      },
                                                    );
                                                    if (pickedTime != null) {
                                                      final selectedTime =
                                                          DateTime(
                                                              now.year,
                                                              now.month,
                                                              now.day,
                                                              pickedTime.hour,
                                                              pickedTime.minute,
                                                              now.second);
                                                      final formatedTime =
                                                          DateFormat('HH:mm:ss')
                                                              .format(
                                                                  selectedTime);

                                                      setState(() {
                                                        formData['time'] =
                                                            formatedTime;
                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12, 15, 12, 0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 67,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(-1, 0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 0, 0, 1),
                                            child: Text(
                                              'Date',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: Colors.black,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(12, 0, 0, 0),
                                                child: Text(
                                                  formData['date'],
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(2, 2, 2, 2),
                                                child: FlutterFlowIconButton(
                                                  borderRadius: 20,
                                                  buttonSize: 30,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                  icon: Icon(
                                                    Icons.date_range_outlined,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .info,
                                                    size: 15,
                                                  ),
                                                  onPressed: () async {
                                                    // Date Picker
                                                    final pickedDate =
                                                        await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          getCurrentTimestamp,
                                                      firstDate: DateTime(2021),
                                                      lastDate: now,
                                                      builder:
                                                          (context, child) {
                                                        return wrapInMaterialDatePickerTheme(
                                                          context,
                                                          child!,
                                                          headerBackgroundColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .primary,
                                                          headerForegroundColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .info,
                                                          headerTextStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineLarge
                                                                  .override(
                                                                    fontFamily:
                                                                        'Inter Tight',
                                                                    fontSize:
                                                                        32,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                          pickerBackgroundColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                          pickerForegroundColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .primaryText,
                                                          selectedDateTimeBackgroundColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .primary,
                                                          selectedDateTimeForegroundColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .info,
                                                          actionButtonForegroundColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .primaryText,
                                                          iconSize: 24,
                                                        );
                                                      },
                                                    );
                                                    if (pickedDate != null) {
                                                      safeSetState(() {
                                                        final DateFormat
                                                            formatter =
                                                            DateFormat(
                                                                'yyyy-MM-dd');
                                                        formData['date'] =
                                                            formatter.format(
                                                                pickedDate);
                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 30.0, 0.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () {
                                _submitAddNewTransactionForm();
                              },
                              text: 'Submit Data',
                              options: FFButtonOptions(
                                width: 350.0,
                                height: 50.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Inter Tight',
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                    ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 2.0,
                  color: Colors.black,
                ),
                Container(
                  width: double.infinity,
                  height: 300.0,
                  decoration: BoxDecoration(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 10.0, 0.0, 0.0),
                          child: Text(
                            'Add New Category Or Tag',
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
                                  fontFamily: 'Inter Tight',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Form(
                            key: _model.formKey1,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 0.0, 10.0, 0.0),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: TextFormField(
                                          controller: _categoryController,
                                          onChanged: (value) {
                                            setState(() {
                                              addNewValues['category'] = value;
                                            });
                                          },
                                          autofocus: false,
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            labelText: 'Category',
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .override(
                                                      fontFamily: 'Inter Tight',
                                                      letterSpacing: 0.0,
                                                    ),
                                            hintText: 'Enter Category',
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily: 'Inter',
                                                      letterSpacing: 0.0,
                                                    ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                letterSpacing: 0.0,
                                              ),
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                          validator: _model
                                              .textController3Validator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                  ),
                                  FFButtonWidget(
                                    onPressed: () {
                                      _addNewCatgory();
                                    },
                                    text: 'Add Category',
                                    options: FFButtonOptions(
                                      height: 40.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Inter Tight',
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                          ),
                                      elevation: 0.0,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Form(
                            key: _model.formKey3,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: Container(
                              height: 100.0,
                              decoration: BoxDecoration(),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 0.0, 10.0, 0.0),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: TextFormField(
                                          controller: _tagController,
                                          focusNode: _model.textFieldFocusNode2,
                                          autofocus: false,
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          onChanged: (value) {
                                            addNewValues['tag'] = value;
                                          },
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            labelText: 'Tag',
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .override(
                                                      fontFamily: 'Inter Tight',
                                                      letterSpacing: 0.0,
                                                    ),
                                            hintText: 'Enter Tag',
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily: 'Inter',
                                                      letterSpacing: 0.0,
                                                    ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                letterSpacing: 0.0,
                                              ),
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                          validator: _model
                                              .textController4Validator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                  ),
                                  FFButtonWidget(
                                    onPressed: () {
                                      _addNewTag();
                                    },
                                    text: 'Add Tag',
                                    options: FFButtonOptions(
                                      height: 40.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Inter Tight',
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                          ),
                                      elevation: 0.0,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
