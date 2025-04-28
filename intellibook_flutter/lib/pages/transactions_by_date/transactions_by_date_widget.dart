import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intellibook_test/api/dto/TransactionByDateDto.dart';
import 'package:intellibook_test/services/pdf_service.dart';
import 'package:logger/web.dart';
import 'package:printing/printing.dart';

import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'transactions_by_date_model.dart';

export 'transactions_by_date_model.dart';

class TransactionsByDateWidget extends StatefulWidget {
  const TransactionsByDateWidget({super.key});

  @override
  State<TransactionsByDateWidget> createState() =>
      _TransactionsByDateWidgetState();
}

class _TransactionsByDateWidgetState extends State<TransactionsByDateWidget> {
  final Logger logger = Logger();
  late TransactionsByDateModel _model;
  TransactionByDateDto transactionByDateDto = TransactionByDateDto();

  PdfService pdfService = PdfService();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, String> searchQyery = {
    'sortBy': 'Time:Desc',
    'date': '',
  };

  @override
  void initState() {
    super.initState();
    getFakejson();
    _model = createModel(context, () => TransactionsByDateModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void searchDataApi() {
    logger.i('searchDataApi called');
  }

  void _handlePrintReport() async {
    try {
      // Generate the PDF
      final pdfData =
          await pdfService.generateTransactionPdf(transactionByDateDto);
      final now = DateTime.now(); // Current date and time
      final customFileName =
          "Transaction On ${DateFormat('dd-MM-yyyy').format(now)} ";
      await Printing.sharePdf(
        bytes: pdfData,
        filename: '$customFileName.pdf', // Custom file name
      );
    } catch (e) {
      // Handle errors gracefully
      logger.e("Error generating or printing PDF: $e");
    }
  }

  Future<void> getFakejson() async {
    try {
      String jsonString = await rootBundle
          .loadString('assets/jsons/TransactionByDateFakeJson.json');
      final Map<String, dynamic> json = jsonDecode(jsonString);
      setState(() {
        transactionByDateDto = TransactionByDateDto.fromJson(json);
      });
      logger.i("TransactionByDateDto :- $transactionByDateDto");
    } catch (e) {
      logger.e("Error in getFakejson $e");
    }
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
              colors: [Color(0xFFCFD9DF), Color(0xFFE2EBF0)],
              stops: [0.0, 1.0],
              begin: AlignmentDirectional(0.0, -1.0),
              end: AlignmentDirectional(0, 1.0),
            ),
          ),
          child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // mainAxisSize: MainAxisSize.max,
                  spacing: 10,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 60.0, 0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Transactions By Date',
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
                                  fontFamily: 'Inter Tight',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      // height: 50.0,
                      decoration: BoxDecoration(),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 0.0, 0.0, 0.0),
                            child: FlutterFlowDropDown<String>(
                              controller:
                                  _model.sortByDropDownValueController ??=
                                      FormFieldController<String>(null),
                              options: [
                                'Time:Desc',
                                'Time:ASC',
                                'Amount:ASC',
                                'Amount:DESC'
                              ],
                              onChanged: (val) => {
                                setState(() {
                                  if (val != null) {
                                    searchQyery['sortBy'] = val;
                                    searchDataApi();
                                  }
                                })
                              },
                              width: 150.0,
                              height: 40.0,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                  ),
                              hintText: searchQyery['sortBy'] ?? 'Sort By',
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 24.0,
                              ),
                              fillColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              elevation: 2.0,
                              borderColor: Colors.transparent,
                              borderWidth: 0.0,
                              borderRadius: 8.0,
                              margin: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 0.0, 12.0, 0.0),
                              hidesUnderline: true,
                              isOverButton: false,
                              isSearchable: false,
                              isMultiSelect: false,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 10.0, 0.0),
                            child: Container(
                              width: 200.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(8.0),
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
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      searchQyery['date'] ?? 'Select Date',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 2.0, 0.0),
                                    child: FlutterFlowIconButton(
                                      borderRadius: 20.0,
                                      buttonSize: 30.0,
                                      fillColor:
                                          FlutterFlowTheme.of(context).primary,
                                      icon: Icon(
                                        Icons.date_range_outlined,
                                        color:
                                            FlutterFlowTheme.of(context).info,
                                        size: 15.0,
                                      ),
                                      onPressed: () async {
                                        // Date Picker
                                        final datePickedDate =
                                            await showDatePicker(
                                          context: context,
                                          firstDate: DateTime(2021),
                                          lastDate: getCurrentTimestamp,
                                          builder: (context, child) {
                                            return wrapInMaterialDatePickerTheme(
                                              context,
                                              child!,
                                              headerBackgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              headerForegroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .info,
                                              headerTextStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineLarge
                                                      .override(
                                                        fontFamily:
                                                            'Inter Tight',
                                                        fontSize: 32.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                              pickerBackgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              pickerForegroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              selectedDateTimeBackgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              selectedDateTimeForegroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .info,
                                              actionButtonForegroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              iconSize: 24.0,
                                            );
                                          },
                                        );

                                        if (datePickedDate != null) {
                                          safeSetState(() {
                                            final DateFormat formatter =
                                                DateFormat('yyyy-MM-dd');
                                            searchQyery['date'] = formatter
                                                .format(datePickedDate);
                                          });
                                          searchDataApi();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 2.0,
                      color: Colors.white,
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10.0, 0.0, 10.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Cate.. :- ${transactionByDateDto.totalCategories}',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  Text(
                                    'Total Expen.. :- Rs  ${transactionByDateDto.totalExpendature}',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 10.0, 0.0, 0.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      ListView.builder(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 20.0),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: transactionByDateDto
                                            .totalCategories,
                                        itemBuilder: (context, index) {
                                          Category category =
                                              transactionByDateDto
                                                  .categories[index];
                                          return Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 0.0, 10.0, 10.0),
                                            child: Container(
                                              width: 100.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                border: Border.all(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 10.0, 10.0, 10.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      category.name,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyLarge
                                                          .override(
                                                            fontFamily: 'Inter',
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Count :- ${category.transactions.length}',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Inter',
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                        ),
                                                        Text(
                                                          'Ammount :- Rs ${category.totalAmount}',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Inter',
                                                                fontSize: 15.0,
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      thickness: 2.0,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                    ),
                                                    Column(
                                                      children: category
                                                          .transactions
                                                          .map((transaction) {
                                                        // Add your widget here
                                                        return Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      5.0,
                                                                      5.0,
                                                                      5.0,
                                                                      5.0),
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        5.0),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        5.0),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        5.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                        5.0),
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          3.0,
                                                                          5.0,
                                                                          3.0,
                                                                          3.0),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                spacing: 3,
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Text(
                                                                      'Amount :- Rs ${transaction.amount}',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Inter',
                                                                            fontSize:
                                                                                18.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            -1.0,
                                                                            0.0),
                                                                    child: Text(
                                                                      'Time:- ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(transaction.time))}',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Inter',
                                                                            letterSpacing:
                                                                                0.0,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            -1.0,
                                                                            0.0),
                                                                    child: Text(
                                                                      'Description :- ${transaction.description}',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Inter',
                                                                            letterSpacing:
                                                                                0.0,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    spacing: 10,
                                                                    children: [
                                                                      Text(
                                                                        'Tags :- ',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Inter',
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                      ),
                                                                      for (var tag
                                                                          in transaction
                                                                              .tags)
                                                                        Chip(
                                                                          label:
                                                                              Text(
                                                                            tag.name,
                                                                          ),
                                                                          backgroundColor:
                                                                              Colors.blue[100], // Customize the background color
                                                                          labelStyle:
                                                                              TextStyle(color: Colors.blue[800]), // Customize text color
                                                                          // padding:
                                                                        )
                                                                    ],
                                                                  ),
                                                                ].divide(SizedBox(
                                                                    height:
                                                                        10.0)),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            FlutterFlowIconButton(
                              borderRadius: 8,
                              buttonSize: 40,
                              fillColor: FlutterFlowTheme.of(context).tertiary,
                              icon: Icon(
                                Icons.print_outlined,
                                color: FlutterFlowTheme.of(context).info,
                                size: 20,
                              ),
                              onPressed: () {
                                _handlePrintReport();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
