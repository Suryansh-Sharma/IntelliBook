import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intellibook_test/api/dto/SearchResDto.dart';
import 'package:intellibook_test/flutter_flow/flutter_flow_icon_button.dart';
import 'package:intellibook_test/flutter_flow/flutter_flow_theme.dart';
import 'package:intellibook_test/flutter_flow/flutter_flow_util.dart';
import 'package:intellibook_test/flutter_flow/flutter_flow_widgets.dart';
import 'package:intellibook_test/pages/search_transacton_page/search_transaction_page_model.dart';
import 'package:logger/web.dart';

class SearchTransactionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchTransactionPageState();

  const SearchTransactionPage({super.key});
}

class _SearchTransactionPageState extends State<SearchTransactionPage> {
  final Logger logger = Logger();
  late SearchTransactonPageModel _model;

  bool showFilters = false;
  String selectedSortBy = 'Name: ASC';
  SearchResdto searchResdto = SearchResdto();
  final List<String> sortByOptions = [
    'Name: ASC',
    'Name: DESC',
    'Amount: ASC',
    'Amount: DESC',
  ];
  Map<String, bool> stateMap = {
    'showCategory': true,
    'showTags': true,
    'showTransaction': true,
    'isLoading': true,
  };
  Map<String, String> searchQuery = {
    'value': "",
    'target': "ALL",
    'sortBy': "Name: ASC",
    'filter.AllRecord': 'true',
    'filter.Categories': 'false',
    'filter.Tags': 'false',
    'filter.AmountRange': '0',
    'filter.DateRange': '',
  };
  @override
  void initState() {
    super.initState();
    getFakeJson();
    _model = createModel(context, () => SearchTransactonPageModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    stateMap['isLoading'] = false;
  }

  Future<void> getFakeJson() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/jsons/SearchFakeJson.json');

      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      setState(() {
        searchResdto = SearchResdto.fromJson(jsonData);
      });
    } catch (e) {
      logger.e('Error loading JSON: $e');
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void toggleFilters() {
    setState(() {
      showFilters = !showFilters;
    });
  }

  void handleToggleResult(String key) {
    setState(() {
      stateMap[key] = !stateMap[key]!;
    });
  }

  void _handleFilterStateChange(String key) {
    setState(() {
      searchQuery['filter.AllRecord'] = 'false';
      searchQuery[key] = searchQuery[key] == 'true' ? 'false' : 'true';
    });
    if (searchQuery['filter.Categories'] == 'false' &&
        searchQuery['filter.Tags'] == 'false') {
      setState(() {
        searchQuery['filter.AllRecord'] = 'true';
      });
    }
  }

  void _handleSearch() {
    if (searchQuery['value'] == "") {
      return;
    }
    _submitDataToApi();
  }

  void _submitDataToApi() {
    stateMap['isLoading'] = true;
    setState(() {});
    logger.i(searchQuery);
    stateMap['isLoading'] = false;
    setState(() {});
  }

  RangeValues _currentRangeValues = RangeValues(0, 100000);
  @override
  Widget build(BuildContext context) {
    if (stateMap['isLoading']!) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Loading, please wait...',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20), // More spacing
            // CircularProgressIndicator with accent color
            CircularProgressIndicator(
              strokeWidth: 4, // Optional: Adjust thickness
              valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.blue), // Spinner color
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          body: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
            child: Column(
              spacing: 10,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        FlutterFlowTheme.of(context).primary,
                        Color(0xFF6B63FF)
                      ],
                      stops: [0, 1],
                      begin: AlignmentDirectional(0, -1),
                      end: AlignmentDirectional(0, 1),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 60, 24, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Text(
                            'Search Transaction',
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                    fontFamily: 'Inter Tight',
                                    color: Colors.white,
                                    letterSpacing: 0.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                          child: Material(
                            color: Colors.transparent,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5, 0, 0, 0),
                                      child: TextField(
                                        controller: _model.textController,
                                        focusNode: _model.textFieldFocusNode,
                                        autofocus: false,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          hintText:
                                              'Search by name, amount, or date...',
                                          hintStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyLarge
                                                  .override(
                                                    fontFamily: 'Inter',
                                                    letterSpacing: 0.0,
                                                  ),
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          focusedErrorBorder: InputBorder.none,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              letterSpacing: 0.0,
                                            ),
                                        minLines: 1,
                                        onChanged: (value) {
                                          setState(() {
                                            searchQuery['value'] = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.search,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 24,
                                    ),
                                    onPressed: _handleSearch,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                // Filter Sections
                Container(
                  padding: EdgeInsetsDirectional.all(20), // 10px top padding
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 10,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Filters',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: 'Inter Tight',
                                  letterSpacing: 0.0,
                                ),
                          ),
                          GestureDetector(
                            onTap: toggleFilters,
                            child: Text(
                              showFilters ? 'Hide' : 'Show',
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      if (showFilters)
                        Align(
                          alignment: AlignmentDirectional(-1, -1),
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            direction: Axis.horizontal,
                            runAlignment: WrapAlignment.start,
                            verticalDirection: VerticalDirection.down,
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                onTap: () => {
                                  if (searchQuery['filter.AllRecord'] != 'true')
                                    {
                                      setState(() {
                                        searchQuery['filter.AllRecord'] =
                                            'true';
                                        searchQuery['filter.Categories'] =
                                            'false';
                                        searchQuery['filter.Tags'] = 'false';
                                        searchQuery['filter.AmountRange'] = '0';
                                        _currentRangeValues =
                                            RangeValues(0, 100000);
                                        searchQuery['filter.DateRange'] = '';
                                      })
                                    }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: searchQuery['filter.AllRecord'] ==
                                            'true'
                                        ? Color(0xFFE3F2FD)
                                        : Color(0xFFBBDEFB),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: searchQuery['filter.AllRecord'] ==
                                              'true'
                                          ? Color.fromARGB(255, 18, 18, 18)
                                          : Color.fromARGB(0, 248, 248, 248),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 16, 8, 16),
                                    child: Text(
                                      'All Record',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            color: Color(0xFF1565C0),
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _handleFilterStateChange(
                                    'filter.Categories'),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFE8F5E9),
                                    borderRadius: BorderRadius.circular(20),
                                    border: searchQuery['filter.Categories'] ==
                                            'true'
                                        ? Border.all(
                                            color:
                                                Color.fromARGB(255, 18, 18, 18),
                                          )
                                        : Border.all(
                                            color: Color.fromARGB(
                                                0, 248, 248, 248),
                                          ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 16, 8, 16),
                                    child: Text(
                                      'Categories',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            color: Color(0xFF2E7D32),
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    _handleFilterStateChange('filter.Tags'),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFF3E0),
                                    borderRadius: BorderRadius.circular(20),
                                    border: searchQuery['filter.Tags'] == 'true'
                                        ? Border.all(
                                            color:
                                                Color.fromARGB(255, 18, 18, 18),
                                          )
                                        : Border.all(
                                            color: Color.fromARGB(
                                                0, 248, 248, 248),
                                          ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 16, 8, 16),
                                    child: Text(
                                      'Tags',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            color: Color(0xFFEF6C00),
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF3E5F5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),

                                  padding: EdgeInsets.all(
                                      16), // Padding for the entire container

                                  child: Column(
                                    mainAxisSize: MainAxisSize
                                        .min, // Minimize the height of the column

                                    children: [
                                      Text(
                                        'Amount: ${searchQuery['filter.AmountRange']}',
                                        style: TextStyle(
                                          fontFamily: 'Inter',

                                          color: Color(0xFF7B1FA2),

                                          letterSpacing: 0.0,

                                          fontSize:
                                              16, // Adjust font size as needed
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('MIN'),
                                          Text('MAX'),
                                        ],
                                      ),
                                      RangeSlider(
                                        values: _currentRangeValues,
                                        min: 0,
                                        max: 100000,
                                        divisions: 100,
                                        labels: RangeLabels(
                                          _currentRangeValues.start
                                              .round()
                                              .toString(),
                                          _currentRangeValues.end
                                              .round()
                                              .toString(),
                                        ),
                                        onChanged: (RangeValues values) {
                                          setState(() {
                                            searchQuery['filter.AllRecord'] =
                                                'false';

                                            _currentRangeValues = values;
                                            if (values.start == 0 &&
                                                values.end == 100000) {
                                              if (searchQuery[
                                                          'filter.Categories'] ==
                                                      'false' &&
                                                  searchQuery['filter.Tags'] ==
                                                      'false') {
                                                searchQuery[
                                                        'filter.AllRecord'] =
                                                    'true';
                                              }

                                              searchQuery[
                                                  'filter.AmountRange'] = '0';
                                            } else {
                                              searchQuery[
                                                      'filter.AmountRange'] =
                                                  ' ${values.start} - ${values.end}';
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 250,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF3E5F5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12, 16, 0, 16),
                                      child: Text(
                                        searchQuery['filter.DateRange'] == ''
                                            ? 'Select Date Range'
                                            : '${searchQuery['filter.DateRange']}',
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
                                          0, 0, 2, 0),
                                      child: FlutterFlowIconButton(
                                        onPressed: () async {
                                          DateTime now = DateTime.now();
                                          DateTimeRange? picked =
                                              await showDateRangePicker(
                                            context: context,
                                            firstDate: DateTime(2021),
                                            lastDate: now,
                                            initialDateRange: DateTimeRange(
                                              start: DateTime(now.year,
                                                  now.month - 1, now.day),
                                              end: now,
                                            ),
                                          );

                                          if (picked != null) {
                                            final DateFormat formatter =
                                                DateFormat('yyyy-MM-dd');
                                            setState(() {
                                              searchQuery['filter.DateRange'] =
                                                  '${formatter.format(picked.start)} to ${formatter.format(picked.end)}';
                                              searchQuery['filter.AllRecord'] =
                                                  'false';
                                            });
                                          }
                                        },
                                        borderRadius: 20,
                                        buttonSize: 35,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .primary,
                                        icon: Icon(
                                          Icons.date_range_outlined,
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              FFButtonWidget(
                                onPressed: () {
                                  _submitDataToApi();
                                },
                                text: 'Apply Filters',
                                options: FFButtonOptions(
                                  height: 50,
                                  width: 150,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16, 0, 16, 0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Inter Tight',
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                      ),
                                  elevation: 0,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                /* Result Section*/

                Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Results (${searchResdto.totalData})',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: 'Inter Tight',
                                  letterSpacing: 0.0,
                                ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.sort,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 24,
                              ),
                              DropdownButton(
                                value: searchQuery['sortBy'],
                                items: sortByOptions
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    searchQuery['sortBy'] = newValue!;
                                    _handleSearch();
                                  });
                                },
                              )
                            ].divide(SizedBox(width: 8)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                /* Result Category Section */
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(
                          0,
                          2,
                        ),
                      )
                    ],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'CATEGORIES',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        fontSize: 19,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      handleToggleResult('showCategory'),
                                  child: Icon(
                                    stateMap['showCategory']!
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                            /*Show Data Of Category */
                            if (stateMap['showCategory']!)
                              ListView.builder(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: searchResdto.categories.length,
                                itemBuilder: (context, index) {
                                  Category category =
                                      searchResdto.categories[index];
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 5, 5, 0),
                                    child: Container(
                                      width: double
                                          .infinity, // Use double.infinity for full width

                                      height: 50,

                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .secondaryHeaderColor, // Replace with your theme color

                                        borderRadius: BorderRadius.circular(8),

                                        border: Border.all(
                                          color: Theme.of(context)
                                              .hintColor, // Replace with your theme color
                                        ),
                                      ),

                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            5, 0, 5, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              category
                                                  .name, // Display transaction description

                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                /**Result Tags Section */
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(
                          0,
                          2,
                        ),
                      )
                    ],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'TAGS',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        fontSize: 19,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      handleToggleResult('showTags'),
                                  child: Icon(
                                    stateMap['showTags']!
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                            /*Show Data Of Category */
                            if (stateMap['showTags']!)
                              ListView.builder(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: searchResdto.tags.length,
                                itemBuilder: (context, index) {
                                  Tag tag = searchResdto.tags[index];
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 5, 5, 0),
                                    child: Container(
                                      width: double
                                          .infinity, // Use double.infinity for full width

                                      height: 50,

                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .secondaryHeaderColor, // Replace with your theme color

                                        borderRadius: BorderRadius.circular(8),

                                        border: Border.all(
                                          color: Theme.of(context)
                                              .hintColor, // Replace with your theme color
                                        ),
                                      ),

                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            5, 0, 5, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              tag.name, // Display transaction description

                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                /* Result Transaction Section */
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(
                          0,
                          2,
                        ),
                      )
                    ],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'TRANSACTION',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        fontSize: 19,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      handleToggleResult('showTransaction'),
                                  child: Icon(
                                    stateMap['showTransaction']!
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                            /*Show Data Of Category */
                            if (stateMap['showTransaction']!)
                              ListView.builder(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: searchResdto.transactions.length,
                                itemBuilder: (context, index) {
                                  Transaction transaction =
                                      searchResdto.transactions[index];
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 5, 5, 0),
                                    child: Container(
                                      width: double
                                          .infinity, // Use double.infinity for full width

                                      height: 50,

                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .secondaryHeaderColor, // Replace with your theme color

                                        borderRadius: BorderRadius.circular(8),

                                        border: Border.all(
                                          color: Theme.of(context)
                                              .hintColor, // Replace with your theme color
                                        ),
                                      ),

                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            5, 0, 5, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              'RS ${transaction.amount.toStringAsFixed(2)}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ));
    }
  }
}
