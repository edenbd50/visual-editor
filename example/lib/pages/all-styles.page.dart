import 'dart:async';
import 'dart:convert';

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
class AllStylesPage extends StatefulWidget {
  @override
  _AllStylesPageState createState() => _AllStylesPageState();
}

class _AllStylesPageState extends State<AllStylesPage> {
  final _editorService = EditorService();

  EditorController? _controller;
  final FocusNode _focusNode = FocusNode();

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
            textDirection: TextDirection.rtl,
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
        showAlignmentButtons: true,
        multiRowsDisplay: false,
      );

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
        highlights: SAMPLE_HIGHLIGHTS,
      );
    });
  }
}
