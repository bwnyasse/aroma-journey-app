import 'dart:ui';

import 'package:aroma_journey/backend/schema/product_record.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_animations.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_choice_chips.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_icon_button.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_theme.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_toggle_icon.dart';
import 'package:aroma_journey/extra/flutter_flow/flutter_flow_util.dart';
import 'package:aroma_journey/extra/flutter_flow/form_field_controller.dart';
import 'package:aroma_journey/modules/product/bloc/product_bloc.dart';
import 'package:aroma_journey/modules/product/bloc/product_event.dart';
import 'package:aroma_journey/modules/product/bloc/product_state.dart';
import 'package:aroma_journey/modules/product/pages/product_model.dart';
import 'package:asuka/snackbars/asuka_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    Key? key,
    required this.productRecord,
  }) : super(key: key);

  final ProductRecord productRecord;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with TickerProviderStateMixin {
  late ProductModel _model;
  Map<String, String> palm2Response = {};

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'blurOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        ShakeEffect(
          curve: Curves.easeInOut,
          delay: 80.ms,
          duration: 1000.ms,
          hz: 5,
          offset: const Offset(0.0, 0.0),
          rotation: 0.105,
        ),
        ScaleEffect(
          curve: Curves.easeInOut,
          delay: 80.ms,
          duration: 1000.ms,
          begin: const Offset(0.0, 0.0),
          end: const Offset(1.0, 1.0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 300.ms,
          begin: const Offset(0.0, 100.0),
          end: const Offset(0.0, 0.0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        ScaleEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: const Offset(0.6, 0.6),
          end: const Offset(1.0, 1.0),
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProductModel());
    BlocProvider.of<ProductBloc>(context)
        .add(ProductInitEvent(widget.productRecord.name));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      bloc: BlocProvider.of<ProductBloc>(context),
      listener: (context, state) {
        if (state is ProductLoadingState) {
          AsukaSnackbar.warning("ProductLoadingState").show();
        }
        if (state is ProductErrorState) {
          AsukaSnackbar.alert("ProductErrorState").show();
        }
        if (state is ProductSuccessState) {
          AsukaSnackbar.success("ProductSuccessState").show();
        }
        if (state is ProductContentState) {
          print(state.content);
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          body: StreamBuilder<ProductRecord>(
            stream: ProductRecord.getDocument(widget.productRecord.reference),
            builder: (context, snapshot) {
              // Customize what your widget looks like when it's loading.
              if (!snapshot.hasData) {
                return Center(
                  child: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                );
              } else {
                final stackProductRecord = snapshot.data!;
                return generateMainContent(context, stackProductRecord);
              }
            },
          ),
        ),
      ),
    );
  }

  SizedBox generateMainContent(
      BuildContext context, ProductRecord stackProductRecord) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: const AlignmentDirectional(0.0, -1.0),
        children: [
          const Align(
            alignment: AlignmentDirectional(0.0, -1.0),
            child: Image(
              // 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
              image: AssetImage('assets/background_Product.png'),
              width: double.infinity,
              height: 500.0,
              fit: BoxFit.cover,
            ),
          ),
          if (stackProductRecord.isOffer)
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 105.0, 0.0, 0.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 2.0,
                    sigmaY: 2.0,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    elevation: 20.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Container(
                      width: 300.0,
                      height: 140.0,
                      decoration: BoxDecoration(
                        color: const Color(0x90000000),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            //stackProductRecord.offerDescription,
                            "Test offer",
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ).animateOnPageLoad(animationsMap['blurOnPageLoadAnimation']!),
            ),
          Align(
            alignment: const AlignmentDirectional(0.0, -0.87),
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4.0,
                          color: Color(0x520E151B),
                          offset: Offset(0.0, 2.0),
                        )
                      ],
                      borderRadius: BorderRadius.circular(50.0),
                      shape: BoxShape.rectangle,
                    ),
                    child: FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 8.0,
                      borderWidth: 1.0,
                      buttonSize: 40.0,
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 20.0,
                      ),
                      onPressed: () async {
                        Modular.to.navigate('/home/');
                      },
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5.0,
                        sigmaY: 5.0,
                      ),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          print("action 1");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'added to favorites!',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              duration: const Duration(milliseconds: 4000),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).primary,
                            ),
                          );
                        },
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: const Color(0x26FFFFFF),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: ToggleIcon(
                            onPressed: () async {
                              print("action 2");
                            },
                            value: true,
                            onIcon: Icon(
                              Icons.favorite,
                              color: FlutterFlowTheme.of(context).alternate,
                              size: 28.0,
                            ),
                            offIcon: Icon(
                              Icons.favorite_border,
                              color: FlutterFlowTheme.of(context).alternate,
                              size: 28.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 140.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: 400.0,
                  decoration: const BoxDecoration(
                    color: Color(0x59000000),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 0.0, 16.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 15.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stackProductRecord.name,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              Text(
                                stackProductRecord.info.maybeHandleOverflow(
                                  maxChars: 45,
                                  replacement: '…',
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 100.0, 0.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: const AlignmentDirectional(0.0, 1.0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 300.0, 0.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        height: 1800.0,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8F7FA),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4.0,
                              color: Color(0x320E151B),
                              offset: Offset(0.0, -2.0),
                            )
                          ],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                            topLeft: Radius.circular(40.0),
                            topRight: Radius.circular(40.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 12.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // FIXME: Hide for the moment
                              //buildExtraContainer(context).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation2']!),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 30.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Product Journey',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Poppins',
                                            fontSize: 20.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              BlocBuilder<ProductBloc, ProductState>(
                                  builder: (context, state) {
                                if (state is ProductLoadingState) {
                                  return const Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 100, 0, 0),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                        strokeWidth: 5.0,
                                      ),
                                    ),
                                  );
                                }
                                if (state is ProductSuccessState) {
                                  palm2Response = state.response;
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 18.0, 0.0, 8.0),
                                        child: FlutterFlowChoiceChips(
                                          options: const [
                                            ChipData('Brewing'),
                                            ChipData('Taste'),
                                            ChipData('Health')
                                          ],
                                          onChanged: (val) {
                                            setState(() {
                                              _model.productSizeOptionsValue =
                                                  val?.first;
                                            });
                                          },
                                          selectedChipStyle: ChipStyle(
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Poppins',
                                                      color: Colors.white,
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                            iconColor: Colors.white,
                                            iconSize: 18.0,
                                            labelPadding:
                                                const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                    15.0, 5.0, 15.0, 5.0),
                                            elevation: 41.0,
                                          ),
                                          unselectedChipStyle: ChipStyle(
                                            backgroundColor: Colors.white,
                                            textStyle: FlutterFlowTheme.of(
                                                    context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: 'Poppins',
                                                  color:
                                                      const Color(0xCC000000),
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                            iconColor: const Color(0xCC000000),
                                            iconSize: 18.0,
                                            labelPadding:
                                                const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                    15.0, 5.0, 15.0, 5.0),
                                            elevation: 4.0,
                                          ),
                                          chipSpacing: 30.0,
                                          rowSpacing: 12.0,
                                          multiselect: false,
                                          initialized:
                                              _model.productSizeOptionsValue !=
                                                  null,
                                          alignment: WrapAlignment.start,
                                          controller: _model
                                                  .productSizeOptionsValueController ??=
                                              FormFieldController<List<String>>(
                                            ['Brewing'],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(16.0, 30.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              'Generative ( experimental )',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 20.0,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Stack(
                                        children: [
                                          for (String key in palm2Response.keys)
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      16.0, 0.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0.0,
                                                              5.0, 40.0, 0.0),
                                                      child: Positioned.fill(
                                                        child: AnimatedOpacity(
                                                          opacity:
                                                              _model.productSizeOptionsValue ==
                                                                      key
                                                                  ? 1.0
                                                                  : 0.0,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      200),
                                                          child: MarkdownBody(
                                                              data:
                                                                  palm2Response[
                                                                      key]!),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  );
                                }
                                return const Text('');
                              }),
                            ],
                          ),
                        ),
                      ).animateOnPageLoad(
                          animationsMap['containerOnPageLoadAnimation1']!),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildExtraContainer(BuildContext context) {
    return Container(
      width: 350.0,
      height: 80.0,
      decoration: BoxDecoration(
        color: const Color(0x35A6A6AA),
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 30.0, 0.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Coffee',
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
            const SizedBox(
              height: 50.0,
              child: VerticalDivider(
                thickness: 1.0,
              ),
            ),
            Text(
              'Chocolate',
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
            const SizedBox(
              height: 50.0,
              child: VerticalDivider(
                thickness: 1.0,
              ),
            ),
            Text(
              'Medium Roasted',
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
