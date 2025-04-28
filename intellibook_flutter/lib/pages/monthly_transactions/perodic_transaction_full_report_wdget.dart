import 'package:intellibook_test/api/dto/PerodicTransactionDto.dart';
import 'package:logger/web.dart';

import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'monthly_transactions_model.dart';
export 'monthly_transactions_model.dart';

class PerodicTransactionFullReportWidget extends StatefulWidget {
  const PerodicTransactionFullReportWidget({super.key});

  @override
  State<PerodicTransactionFullReportWidget> createState() =>
      _PerodicTransactionFullReportWidgetState();
}

class _PerodicTransactionFullReportWidgetState
    extends State<PerodicTransactionFullReportWidget> {
  late MonthlyTransactionsModel _model;
  Logger logger = Logger();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  PerodicTransactionDto perodicTransactionDto = PerodicTransactionDto();
  Map<String, String> searchQuery = {'query': "", 'sortBy': "Time:ASC"};
  Map<String, dynamic> res = {
    'topic': "Ajay Steel",
    'fromDate': "2024-12-01",
    'toDate': "2025-01-01",
    'sortBy': "amount",
    'sortOrder': "DESC",
    'pageSize': 4,
    'pageNo': 0,
    'transactions': [
      {
        'id': 1,
        'amount': 2000.02,
        'time': '2019-01-21T05:47:26.853Z',
        'description': "Random Description"
      },
      {
        'id': 16,
        'amount': 2000.02,
        'time': '2019-01-21T05:47:26.853Z',
        'description': "Random Description"
      },
      {
        'id': 23,
        'amount': 2000.02,
        'time': '2019-01-21T05:47:26.853Z',
        'description': "Random Description"
      },
      {
        'id': 32,
        'amount': 2000.02,
        'time': '2019-01-21T05:47:26.853Z',
        'description': "Random Description"
      },
      {
        'id': 5,
        'amount': 2000.02,
        'time': '2019-01-21T05:47:26.853Z',
        'description':
            "Random Description cjsdakclsd ADCLSHNDLNSDFLNSDFV;LNDV;FNJR;AVN;RENV;REV;NMSDA;CVLN tEST"
      }
    ],
    'totalData': 24,
    'totalPages': 5
  };

  void _handlePrintPdf() {}

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MonthlyTransactionsModel());
    _fetchDataApi();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void _fetchDataApi() {
    perodicTransactionDto = PerodicTransactionDto.fromJson(res);
    // logger.i("Res $perodicTransactionDto");
    setState(() {
      _model.sortByDropDownValueController?.value = 'Time:ASC';
      _model.sortByDropDownValue = 'Time:ASC';
    });
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 50.0, 0.0, 0.0),
                  child: Text(
                    'Transaction Periodic Report',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Inter Tight',
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                child: Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5.0),
                      bottomRight: Radius.circular(5.0),
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0),
                    ),
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'TOPIC:- ',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        Text(
                          perodicTransactionDto.topic,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                child: Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5.0),
                      bottomRight: Radius.circular(5.0),
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0),
                    ),
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'PERIOID:- ',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        Text(
                          '${perodicTransactionDto.fromDate} to ${perodicTransactionDto.toDate}',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-1.0, 0.0),
                      child: FlutterFlowDropDown<String>(
                        controller: _model.sortByDropDownValueController ??=
                            FormFieldController<String>(null),
                        options: [
                          'Time:ASC',
                          'Time:DESC',
                          'Ammount:ASC',
                          'Ammount:DESC'
                        ],
                        onChanged: (val) => safeSetState(
                            () => _model.sortByDropDownValue = val),
                        width: 150.0,
                        height: 40.0,
                        textStyle:
                            FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                        hintText: searchQuery['sortBy'],
                        icon: Icon(
                          Icons.sort_rounded,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 24.0,
                        ),
                        fillColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                        elevation: 2.0,
                        borderColor: Colors.transparent,
                        borderWidth: 2.0,
                        borderRadius: 8.0,
                        margin: EdgeInsetsDirectional.fromSTEB(
                            12.0, 0.0, 12.0, 0.0),
                        hidesUnderline: true,
                        isOverButton: false,
                        isSearchable: false,
                        isMultiSelect: false,
                      ),
                    ),
                    FlutterFlowIconButton(
                      borderRadius: 8.0,
                      buttonSize: 40.0,
                      fillColor: FlutterFlowTheme.of(context).tertiary,
                      icon: Icon(
                        Icons.print_outlined,
                        color: FlutterFlowTheme.of(context).info,
                        size: 24.0,
                      ),
                      onPressed: () {
                        _handlePrintPdf();
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 2.0,
                color: FlutterFlowTheme.of(context).alternate,
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                child: Container(
                  width: double.infinity,
                  height: 472.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(
                            height: 10,
                          ),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: perodicTransactionDto.transactions.length,
                          itemBuilder: (context, index) {
                            var transaction =
                                perodicTransactionDto.transactions[index];
                            return Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5.0),
                                  bottomRight: Radius.circular(5.0),
                                  topLeft: Radius.circular(5.0),
                                  topRight: Radius.circular(5.0),
                                ),
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    5.0, 0.0, 5.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Ammount:- ',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily: 'Inter',
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                        Text(
                                          'Rs ${transaction.amount}',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily: 'Inter',
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Time:- ',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        Text(
                                          DateFormat('yyyy-MM-dd HH:mm:ss')
                                              .format(DateTime.parse(
                                                  transaction.time)),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Description:- ',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            transaction.description,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Inter',
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ]
                                      .divide(SizedBox(height: 5.0))
                                      .around(SizedBox(height: 5.0)),
                                ),
                              ),
                            );
                          },

                          //
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 50.0,
                decoration: BoxDecoration(),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlutterFlowIconButton(
                        borderRadius: 8.0,
                        buttonSize: 35.0,
                        fillColor: perodicTransactionDto.pageNo == 0
                            ? Colors.grey
                            : FlutterFlowTheme.of(context).primary,
                        icon: Icon(
                          Icons.arrow_back,
                          color: FlutterFlowTheme.of(context).info,
                          size: 20.0,
                        ),
                        onPressed: () {
                          if (perodicTransactionDto.pageNo > 0) {}
                        },
                      ),
                      Container(
                        width: 100.0,
                        height: 38.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5.0),
                            bottomRight: Radius.circular(5.0),
                            topLeft: Radius.circular(5.0),
                            topRight: Radius.circular(5.0),
                          ),
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Text(
                            '${perodicTransactionDto.pageNo}',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                      ),
                      FlutterFlowIconButton(
                        borderRadius: 8.0,
                        buttonSize: 35.0,
                        fillColor: perodicTransactionDto.pageNo ==
                                perodicTransactionDto.totalPages
                            ? Colors.grey
                            : FlutterFlowTheme.of(context).primary,
                        icon: Icon(
                          Icons.arrow_forward,
                          color: FlutterFlowTheme.of(context).info,
                          size: 20.0,
                        ),
                        onPressed: () {
                          if (perodicTransactionDto.pageNo ==
                              perodicTransactionDto.totalPages) {}
                        },
                      ),
                    ].divide(SizedBox(width: 10.0)),
                  ),
                ),
              ),
            ].divide(SizedBox(height: 10.0)),
          ),
        ),
      ),
    );
  }
}
