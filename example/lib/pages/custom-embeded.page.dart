import 'dart:async';
import 'dart:convert';

import 'package:editorapp/pages/custom_embed_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visual_editor/rules/controllers/insert/auto-format-multiple-links.rule.dart';
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

  int index = 0;

  @override
  void initState() {
    _loadDocument();
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      _scaffold(
        children: _controller != null
            ? [
          _editor(context),
          _toolbar(),
        ]
            : [
          Loading(),
        ],
      );

  Widget _scaffold({required List<Widget> children}) =>
      DemoScaffold(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      );

  Widget _editor(context) =>
      Flexible(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: VisualEditor(
              controller: _controller!,
              scrollController: ScrollController(),
              focusNode: _focusNode,
              config: EditorConfigM(
                  placeholder: 'Enter text',

                  onTagClicked: (tag) async {
                    print("the tag is: $tag");
                    await showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return Material(
                            color: Colors.transparent,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                    child: GestureDetector(onTap: () {
                                      Navigator.pop(context);
                                    },)),
                                Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: 400,
                                        width: 400,
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius: BorderRadius.circular(
                                              12),),
                                        child: Text('$tag'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  }),
            ),
          ),
        ),
      );

  Widget _toolbar() =>
      EditorToolbar.basic(
        controller: _controller!,
        onImagePickCallback: _editorService.onImagePickCallback,
        onVideoPickCallback: kIsWeb ? _editorService.onVideoPickCallback : null,
        filePickImpl: _editorService.isDesktop()
            ? _editorService.openFileSystemPickerForDesktop
            : null,
        webImagePickImpl: _editorService.webImagePickImpl,
        // Uncomment to provide a custom "pick from" dialog.
        // mediaPickSettingSelector: _editorService.selectMediaPickSettingE,
        showDividers: false,
        showFontSize: false,
        showBoldButton: true,
        showItalicButton: true,
        showSmallButton: false,
        showUnderLineButton: true,
        showStrikeThrough: true,
        showInlineCode: false,
        showColorButton: false,
        showBackgroundColorButton: false,
        showClearFormat: false,
        showAlignmentButtons: true,
        showLeftAlignment: true,
        showCenterAlignment: true,
        showRightAlignment: true,
        showJustifyAlignment: true,
        showHeaderStyle: false,
        showListNumbers: false,
        showListBullets: false,
        showListCheck: false,
        showCodeBlock: false,
        showQuote: false,
        showIndent: false,
        showLink: false,
        showUndo: false,
        showRedo: false,
        multiRowsDisplay: false,
        showImageButton: false,
        showVideoButton: false,
        showCameraButton: false,
        showDirection: true,
        showMarkers: false,
        customIcons: [
          customButtonTag()
        ],
      );

  EditorCustomButtonM customButtonTag() {
    return EditorCustomButtonM(
            icon: Icons.tag,
            onTap: () {
              setState(() {
                var editorController = _controller;
                if (editorController?.selection.start ==
                    editorController?.selection.end) {
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
                } else {





                  int start = editorController?.selection.start ?? 0;

                  int len = editorController!.selection.end -
                      editorController.selection.start;

                  /// Append space to the start
                  editorController.document
                      .insert(editorController.selection.start , " ");

                  editorController.document.replace(
                      start + 1,
                      len,

                      /// hashtag from click on text
                      EmbeddableM.fromJson({
                        'hashtag': HashTagObject(
                            bgColor: getbankColor(),
                            textColor: Colors.black,
                            tagTitle: extractText(
                                editorController, start + 1, len))
                            .toJsonObject(),
                      }));
                  /// Append space to the end
                  editorController.document
                      .insert(editorController.selection.start + 2, " ");

                  editorController.moveCursorToPosition(
                      editorController.selection.start + 3);
                }

              });
            });
  }

  extractText(EditorController editorController, start, len) {
    editorController.document.toDelta().toList().map((e) {
      print("$e");
      return e;
    });
    return editorController.document.getPlainText(start, len);
  }

  Future<void> _loadDocument() async {
    final result = await rootBundle.loadString(
      'assets/docs/custom-embeded.json',
    );
    final document = DocumentM.fromJson(jsonDecode(result));
    document.setCustomRules([
      // const AutoFormatMultipleTagRule(),
    ]);
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
  ];

  getbankColor() {
    colors.shuffle();
    return colors[0];
  }
}
