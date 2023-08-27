import 'package:aroma_journey/backend/backend.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_animations.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_choice_chips.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_model.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_theme.dart';
import 'package:aroma_journey/extra/flutter_flow/form_field_controller.dart';
import 'package:aroma_journey/modules/home/pages/home_model.dart';
import 'package:aroma_journey/modules/shared/shared.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeCategoriesWidget extends StatefulWidget {
  const HomeCategoriesWidget({
    super.key,
  });

  @override
  State<HomeCategoriesWidget> createState() => _HomeCategoriesWidgetState();
}

class _HomeCategoriesWidgetState extends State<HomeCategoriesWidget> {
  late HomeModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());
    _model.searchController ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Categories',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                    ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 13, 0, 13),
                    child: FlutterFlowChoiceChips(
                      options: const [
                        ChipData('Cappuccino', FontAwesomeIcons.mugSaucer),
                        ChipData('Cold Brew', Icons.local_cafe_outlined),
                        ChipData('Expresso', FontAwesomeIcons.mugHot)
                      ],
                      onChanged: (val) =>
                          setState(() => _model.choiceChipsValue = val?.first),
                      selectedChipStyle: ChipStyle(
                        backgroundColor: const Color(0xFF846046),
                        textStyle:
                            FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                        iconColor: Colors.white,
                        iconSize: 15,
                        elevation: 2,
                      ),
                      unselectedChipStyle: ChipStyle(
                        backgroundColor: Colors.white,
                        textStyle:
                            FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                        iconColor: Colors.black,
                        iconSize: 18,
                        elevation: 0,
                      ),
                      chipSpacing: 10,
                      rowSpacing: 12,
                      multiselect: false,
                      initialized: _model.choiceChipsValue != null,
                      alignment: WrapAlignment.start,
                      controller: _model.choiceChipsValueController ??=
                          FormFieldController<List<String>>(
                        ['Cappuccino'],
                      ),
                    ).animateOnPageLoad(
                        animationsMap['choiceChipsOnPageLoadAnimation']!),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
            child: FutureBuilder<List<ProductRecord>>(
              future: queryProductRecordOnce(
                queryBuilder: (productRecord) => productRecord
                    .where('category_name', isEqualTo: _model.choiceChipsValue),
              ),
              builder: (context, snapshot) {
                // Customize what your widget looks like when it's loading.
                if (!snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                  );
                }
                List<ProductRecord> productListProductRecordList =
                    snapshot.data!;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: List.generate(
                      productListProductRecordList.length,
                      (productListIndex) {
                        final productListProductRecord =
                            productListProductRecordList[productListIndex];
                        return Stack(
                          children: [
                            Container(
                              width: 160,
                              height: 185,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                            ),
                            Container(
                              width: 145,
                              height: 165,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 5,
                                    color: Color(0x33000000),
                                    offset: Offset(0, 5),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Stack(
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    // TODO: navigate to the details page
                                    onTap: () async {},
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  7, 7, 7, 0),
                                          child: Container(
                                            width: MediaQuery.sizeOf(context)
                                                .width,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image:
                                                    CachedNetworkImageProvider(
                                                  productListProductRecord
                                                      .image,
                                                ),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  7, 0, 0, 0),
                                          child: Text(
                                            productListProductRecord.name,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
