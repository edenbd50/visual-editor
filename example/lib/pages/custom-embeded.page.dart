import 'dart:async';
import 'dart:convert';

import 'package:editorapp/pages/custom_embed_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visual_editor/visual-editor.dart';

import '../const/sample-highlights.const.dart';
import '../services/editor.service.dart';
import '../widgets/demo-scaffold.dart';
import '../widgets/loading.dart';

// Demo of all the styles that can be applied to a document.
class CustomEmbededPage extends StatefulWidget {
  @override
  _CustomEmbededPageState createState() => _CustomEmbededPageState();
}

class _CustomEmbededPageState extends State<CustomEmbededPage> {
  final _editorService = EditorService();

  EditorController? _controller;
  final FocusNode _focusNode = FocusNode();

  static int index = 0;

  @override
  void initState() {
    _loadDocument();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _scaffold(
        children: _controller != null
            ? [
                _editor(),
                _toolbar(),
              ]
            : [
                Loading(),
              ],
      );

  Widget _scaffold({required List<Widget> children}) => DemoScaffold(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      );

  Widget _editor() => Flexible(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: VisualEditor(
              controller: _controller!,
              scrollController: ScrollController(),
              focusNode: _focusNode,
              config: EditorConfigM(
                placeholder: 'הקלד..',
                embedBuilder: customEmbedBuilder,
              ),
            ),
          ),
        ),
      );

  Widget _toolbar() => EditorToolbar.basic(
        controller: _controller!,
        onImagePickCallback: _editorService.onImagePickCallback,
        onVideoPickCallback: kIsWeb ? _editorService.onVideoPickCallback : null,
        filePickImpl: _editorService.isDesktop()
            ? _editorService.openFileSystemPickerForDesktop
            : null,
        webImagePickImpl: _editorService.webImagePickImpl,
        // Uncomment to provide a custom "pick from" dialog.
        // mediaPickSettingSelector: _editorService.selectMediaPickSettingE,
        showAlignmentButtons: true,
        multiRowsDisplay: false,
        showMarkers: true,
        customIcons: [
          EditorCustomButtonM(
              icon: Icons.tag,
              onTap: () {
                setState(() {
                  var editorController = _controller;

                  /// Append space from the start
                  editorController?.document
                      .insert(editorController.selection.start, " ");

                  /// Replace text with tag
                  editorController?.document.insert(
                      editorController.selection.start + 1,

                      /// hashtag from button
                      EmbeddableM.fromJson({
                        'hashtag': HashTagObject(
                          tagTitle: "${index++}",
                          bgColor: getbankColor(),
                          textColor: Colors.black,
                          data: {"val": 'Hey there'},
                        ).toJsonObject(),
                      }));

                  /// Append space to the end
                  editorController?.document
                      .insert(editorController.selection.start + 2, " ");

                  editorController?.moveCursorToPosition(
                      editorController.selection.start + 3);
                });
              })
        ],
      );

  Future<void> _loadDocument() async {
    // final result = await rootBundle.loadString(
    //   'assets/docs/custom-embeded.json',
    // );
    // final document = DocumentM.fromJson(jsonDecode(result));
     final document = DocumentM();
    setState(() {
      _controller = EditorController(
        document: document,
      );
      _controller?.document.changes.listen((event) {
        print(_controller?.document.toDelta().toJson());
      });
    });
  }

  List<Color> colors = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.yellowAccent,
    Colors.greenAccent,
    Colors.cyanAccent,
    Colors.purpleAccent,
    Colors.pinkAccent,
    Colors.black
  ];

  getbankColor() {
    colors.shuffle();
    return colors[0];
  }
}
