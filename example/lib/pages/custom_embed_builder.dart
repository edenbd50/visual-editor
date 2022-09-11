import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:visual_editor/visual-editor.dart';
import 'package:visual_editor/controller/controllers/editor-controller.dart';
import 'package:visual_editor/documents/models/attributes/attributes.model.dart';
import 'package:visual_editor/documents/models/attributes/styling-attributes.dart';
import 'package:visual_editor/documents/models/nodes/block-embed.model.dart';
import 'package:visual_editor/documents/models/nodes/embed.model.dart';
import 'package:visual_editor/embeds/models/content-size.model.dart';
import 'package:visual_editor/embeds/models/image.model.dart';
import 'package:visual_editor/embeds/services/image.utils.dart';
import 'package:visual_editor/embeds/widgets/image-resizer.dart';
import 'package:visual_editor/embeds/widgets/image-tap-wrapper.dart';
import 'package:visual_editor/embeds/widgets/simple-dialog-item.dart';
import 'package:visual_editor/embeds/widgets/video-app.dart';
import 'package:visual_editor/embeds/widgets/youtube-video-app.dart';
import 'package:visual_editor/shared/translations/toolbar.i18n.dart';
import 'package:visual_editor/shared/utils/platform.utils.dart';
import 'package:visual_editor/shared/utils/string.utils.dart';

Widget customEmbedBuilder(
  BuildContext context,
  EditorController controller,
  EmbedM node,
  bool readOnly,
) {
  //assert(!kIsWeb, 'Please provide EmbedBuilder for Web');
  ContentSizeM? _widthHeight;

  switch (node.value.type) {
    case 'hashtag':
      print('${node.value.data}');
      HashTagObject tagObject = HashTagObject.fromJson(node.value.data);
      return SizedBox(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
          decoration: BoxDecoration(
              color: tagObject.bgColor,
              borderRadius: BorderRadius.circular(9.0)),
          child: InkWell(
            onTap: () async {
              print('${tagObject.toString()}');
            },
            child: Text(
              "#${tagObject.tagTitle}",
              style: TextStyle(color: tagObject.textColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );

    // return InkWell(
    //   onTap: (){
    //     print('clicked');
    //   },
    //     child: Container(
    //   child: Text('eden'),
    // ));
    default:
      // Throwing an error here does not help at all.
      // Even when there's only one Operation with a video attribute in the
      // whole doc it will be flushed away from the console by a large callstack.
      // The error that gets printed on repeat will flood the terminal filling up the entire
      // buffer with a message that is completely  misleading.
      // By rendering this text we can save countless hours of searching for the origin of the bug.
      // ignore: avoid_print
      print(
        'Embeddable type "${node.value.type}" is not supported by default web'
        'embed builder of VisualEditor. You must pass your own builder function '
        'to embedBuilder property of VisualEditor or EditorField widgets.',
      );

      return const SizedBox.shrink();
  }
}

class HashTagObject {
  String tagTitle;
  Color bgColor;
  Color textColor;
  Map<String, dynamic> data;

  HashTagObject(
      {this.tagTitle = 'Example',
      this.bgColor = const Color(0xFFFFDEE7),
      this.textColor = Colors.black,
      this.data = const {}});

  factory HashTagObject.fromJson(Map<String, dynamic> json) {
    return HashTagObject(
      tagTitle: json['tagTitle'],
      bgColor: HexColor(json['bgColor'], defaultColor: Color(0xFFFFDEE7)),
      textColor: HexColor(json['textColor'], defaultColor: Colors.black),
      data: json['data'] ?? {},
    );
  }

  static Map<String, dynamic> toJson(HashTagObject value) => {
        "tagTitle": value.tagTitle,
        "bgColor": value.bgColor.toHex(leadingHashSign: false),
        "txtColor": value.textColor.toHex(leadingHashSign: false),
        "data": value.data,
      };

  Map<String, dynamic> toJsonObject() => {
        "tagTitle": this.tagTitle,
        "bgColor": this.bgColor.toHex(leadingHashSign: false),
        "txtColor": this.textColor.toHex(leadingHashSign: false),
        "data": this.data,
      };

  @override
  String toString() {
    return '{'
        'tagTitle: $tagTitle,'
        ' bgColor: ${bgColor.toHex(leadingHashSign: false)},'
        ' txtColor: ${textColor.toHex(leadingHashSign: false)},'
        ' data:$data'
        '}';
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String? hexColor,
      {Color defaultColor = Colors.transparent}) {
    hexColor ??= defaultColor.toHex();
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String? hexColor, {Color defaultColor = Colors.transparent})
      : super(_getColorFromHex(hexColor, defaultColor: defaultColor));
}

extension HexColorExtension on Color {
  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true, bool withAlpha = true}) =>
      '${leadingHashSign ? '#' : ''}'
      '${withAlpha ? alpha.toRadixString(16).padLeft(2, '0') : ''}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
