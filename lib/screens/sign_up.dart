// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// import 'signup_model.dart';
// export 'signup_model.dart';

// class SignupWidget extends StatefulWidget {
//   const SignupWidget({Key? key}) : super(key: key);

//   @override
//   _SignupWidgetState createState() => _SignupWidgetState();
// }

// class _SignupWidgetState extends State<SignupWidget> {
//   late SignupModel _model;

//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => SignupModel());

//     _model.textController1 ??= TextEditingController();
//     _model.textFieldFocusNode1 ??= FocusNode();

//     _model.textController2 ??= TextEditingController();
//     _model.textFieldFocusNode2 ??= FocusNode();

//     _model.textController3 ??= TextEditingController();
//     _model.textFieldFocusNode3 ??= FocusNode();

//     _model.textController4 ??= TextEditingController();
//     _model.textFieldFocusNode4 ??= FocusNode();

//     _model.textController5 ??= TextEditingController();
//     _model.textFieldFocusNode5 ??= FocusNode();

//     _model.textController6 ??= TextEditingController();
//     _model.textFieldFocusNode6 ??= FocusNode();
//   }

//   @override
//   void dispose() {
//     _model.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isiOS) {
//       SystemChrome.setSystemUIOverlayStyle(
//         SystemUiOverlayStyle(
//           statusBarBrightness: Theme.of(context).brightness,
//           systemStatusBarContrastEnforced: true,
//         ),
//       );
//     }

//     return GestureDetector(
//       onTap: () => _model.unfocusNode.canRequestFocus
//           ? FocusScope.of(context).requestFocus(_model.unfocusNode)
//           : FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         key: scaffoldKey,
//         backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
//         body: SafeArea(
//           top: true,
//           child: Align(
//             alignment: AlignmentDirectional(0.00, 0.00),
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   height: 200,
//                   child: Stack(
//                     children: [
//                       Container(
//                         width: double.infinity,
//                         height: 140,
//                         decoration: BoxDecoration(
//                           color:
//                               FlutterFlowTheme.of(context).secondaryBackground,
//                           image: DecorationImage(
//                             fit: BoxFit.cover,
//                             image: Image.network(
//                               'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=1280&h=720',
//                             ).image,
//                           ),
//                         ),
//                       ),
//                       Align(
//                         alignment: AlignmentDirectional(-1.00, 1.00),
//                         child: Padding(
//                           padding: EdgeInsetsDirectional.fromSTEB(24, 0, 0, 16),
//                           child: Container(
//                             width: 90,
//                             height: 90,
//                             decoration: BoxDecoration(
//                               color: FlutterFlowTheme.of(context).primary,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Padding(
//                               padding:
//                                   EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(50),
//                                 child: Image.network(
//                                   'https://images.unsplash.com/photo-1520932767681-47fc69dd54e5?w=512&h=512',
//                                   width: 100,
//                                   height: 100,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
//                   child: Text(
//                     'Sign Up',
//                     style: FlutterFlowTheme.of(context).headlineSmall,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 16),
//                   child: TextFormField(
//                     controller: _model.textController1,
//                     focusNode: _model.textFieldFocusNode1,
//                     obscureText: false,
//                     decoration: InputDecoration(
//                       labelText: 'Email',
//                       hintStyle: FlutterFlowTheme.of(context).bodyLarge,
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: FlutterFlowTheme.of(context).primaryBackground,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0x00000000),
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0x00000000),
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0x00000000),
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     style: FlutterFlowTheme.of(context).bodyLarge,
//                     validator:
//                         _model.textController1Validator.asValidator(context),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 16),
//                   child: TextFormField(
//                     controller: _model.textController2,
//                     focusNode: _model.textFieldFocusNode2,
//                     obscureText: !_model.passwordVisibility,
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       hintStyle: FlutterFlowTheme.of(context).bodyLarge,
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: FlutterFlowTheme.of(context).primaryBackground,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0x00000000),
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0x00000000),
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0x00000000),
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       suffixIcon: InkWell(
//                         onTap: () => setState(
//                           () => _model.passwordVisibility =
//                               !_model.passwordVisibility,
//                         ),
//                         focusNode: FocusNode(skipTraversal: true),
//                         child: Icon(
//                           _model.passwordVisibility
//                               ? Icons.visibility_outlined
//                               : Icons.visibility_off_outlined,
//                           color: FlutterFlowTheme.of(context).secondaryText,
//                           size: 22,
//                         ),
//                       ),
//                     ),
//                     style: FlutterFlowTheme.of(context).bodyLarge,
//                     validator:
//                         _model.textController2Validator.asValidator(context),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 16),
//                   child: TextFormField(
//                     controller: _model.textController3,
//                     focusNode: _model.textFieldFocusNode3,
//                     obscureText: false,
//                     decoration: InputDecoration(
//                       labelText: 'Name',
//                       hintStyle: FlutterFlowTheme.of(context).bodyLarge,
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: FlutterFlowTheme.of(context).primaryBackground,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0x00000000),
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0x00000000),
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0x00000000),
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     style: FlutterFlowTheme.of(context).bodyLarge,
//                     validator:
//                         _model.textController3Validator.asValidator(context),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 16),
//                   child: TextFormField(
//                     controller: _model.textController4,
//                     focusNode: _model.textFieldFocusNode4,
//                     obscureText: false,
//                     decoration: InputDecoration(
//                       labelText: 'Bio',
//                       hintStyle: FlutterFlowTheme.of(context).bodyLarge,
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: FlutterFlowTheme.of(context).primaryBackground,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0x00000000),
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0x00000000),
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0x00000000),
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     style: FlutterFlowTheme.of(context).bodyLarge,
//                     minLines: 3,
//                     validator:
//                         _model.textController4Validator.asValidator(context),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 16),
//                   child: TextFormField(
//                     controller: _model.textController5,
//                     focusNode: _model.textFieldFocusNode5,
//                     obscureText: false,
//                     decoration: InputDecoration(
//                       labelText: 'Age',
//                       hintStyle: FlutterFlowTheme.of(context).bodyLarge,
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: FlutterFlowTheme.of(context).primaryBackground,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0x00000000),
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0x00000000),
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0x00000000),
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     style: FlutterFlowTheme.of(context).bodyLarge,
//                     validator:
//                         _model.textController5Validator.asValidator(context),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 16),
//                   child: TextFormField(
//                     controller: _model.textController6,
//                     focusNode: _model.textFieldFocusNode6,
//                     obscureText: false,
//                     decoration: InputDecoration(
//                       labelText: 'Home City',
//                       hintStyle: FlutterFlowTheme.of(context).bodyLarge,
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: FlutterFlowTheme.of(context).primaryBackground,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0x00000000),
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0x00000000),
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0x00000000),
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     style: FlutterFlowTheme.of(context).bodyLarge,
//                     validator:
//                         _model.textController6Validator.asValidator(context),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 16),
//                   child: FFButtonWidget(
//                     onPressed: () {
//                       print('Button pressed ...');
//                     },
//                     text: 'Sign Up',
//                     options: FFButtonOptions(
//                       width: 370,
//                       height: 44,
//                       padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                       iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                       color: FlutterFlowTheme.of(context).primary,
//                       textStyle:
//                           FlutterFlowTheme.of(context).titleSmall.override(
//                                 fontFamily: 'Plus Jakarta Sans',
//                                 color: Colors.white,
//                               ),
//                       elevation: 3,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

