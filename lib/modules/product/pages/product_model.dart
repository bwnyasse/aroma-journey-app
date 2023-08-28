import 'package:aroma_journey/extra/flutter_flow/flutter_flow_model.dart';
import 'package:aroma_journey/extra/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';

class ProductModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for coffeeSizeOptions widget.
  String? coffeeSizeOptionsValue;
  FormFieldController<List<String>>? coffeeSizeOptionsValueController;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
